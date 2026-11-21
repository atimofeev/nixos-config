import argparse
import asyncio
import fcntl
import json
import logging
import os
from pathlib import Path
import re

from niri_session import command, replace_text, watch

LOG = logging.getLogger("niri-dgpu-dock")
SETTLE_DELAYS = (0.5, 1.0, 2.0)
BOUND = "// niri-dgpu-dock: dGPU available to Niri\n"


def ignored(gpu):
    return f"debug {{\n    ignore-drm-device {json.dumps(str(gpu))}\n}}\n"


def connected(gpu, drm=Path("/sys/class/drm")):
    card = gpu.resolve(strict=True).name
    if not re.fullmatch(r"card[0-9]+", card):
        raise ValueError(f"Not a DRM card: {gpu}")
    statuses = [(p / "status").read_text().strip() for p in drm.glob(f"{card}-*")]
    if "connected" in statuses:
        return True
    if not statuses or any(s != "disconnected" for s in statuses):
        raise ValueError(f"Connector state unavailable for {gpu}")
    return False


def optional(path, default=None):
    try:
        return path.read_text().strip()
    except FileNotFoundError:
        return default


def on_battery(power=Path("/sys/class/power_supply")):
    # Peripheral batteries and USB ports supplying devices are not laptop power.
    supplies = [p for p in power.iterdir() if optional(p / "scope") != "Device"]
    batteries, online = [], []
    for p in supplies:
        if (p / "type").read_text().strip() == "Battery":
            if optional(p / "present", "1") != "0":
                batteries.append(p)
        else:
            state = optional(p / "online")
            if state is not None:
                online.append(state)
    if "1" in online or not batteries:
        return False
    statuses = [optional(p / "status", "Unknown") for p in batteries]
    if "Charging" in statuses:
        return False
    if any(state not in ("0", "1") for state in online):
        raise ValueError("External power state is unknown")
    if "Discharging" in statuses or online:
        return True
    raise ValueError("Battery power state is unknown")


def should_ignore(gpu):
    return on_battery() and not connected(gpu)


def initialize(fragment, gpu):
    fragment.parent.mkdir(parents=True, exist_ok=True)
    # Retire manual policy state from the previous implementation.
    fragment.with_suffix(".mode").unlink(missing_ok=True)
    if fragment.exists():
        return
    try:
        ignore = should_ignore(gpu)
    except (OSError, ValueError):
        ignore = False
    try:
        with fragment.open("x") as f:
            f.write(ignored(gpu) if ignore else BOUND)
    except FileExistsError:
        pass


class Controller:
    def __init__(self, gpu, fragment, niri):
        self.gpu, self.fragment, self.niri = gpu, fragment, niri
        self.event = asyncio.Event()
        self.sleeping = False
        self.pending_reload = True

    def trigger(self):
        self.event.set()

    def sleep_changed(self, sleeping):
        self.sleeping = sleeping
        self.trigger()

    async def refresh(self, allow_disable=True):
        try:
            if self.sleeping:
                return None
            bound = not should_ignore(self.gpu)
            if bound or allow_disable:
                if replace_text(self.fragment, BOUND if bound else ignored(self.gpu)):
                    LOG.info("GPU-ignore workaround %s", "inactive" if bound else "active")
                    self.pending_reload = True
                if self.pending_reload:
                    code, _, stderr = await command(self.niri, "msg", "action", "load-config-file")
                    if code:
                        raise RuntimeError(f"Niri reload failed ({code}): {stderr.strip()}")
                    self.pending_reload = False
            return bound
        except (OSError, ValueError, RuntimeError, TimeoutError) as exc:
            LOG.warning("Update incomplete; preserving fragment: %s", exc)
            return None

    async def run(self):
        while True:
            await self.event.wait()
            self.event.clear()
            if self.sleeping:
                continue
            for i, delay in enumerate(SETTLE_DELAYS):
                try:
                    await asyncio.wait_for(self.event.wait(), timeout=delay)
                    break
                except TimeoutError:
                    pass
                if await self.refresh(allow_disable=i == len(SETTLE_DELAYS) - 1) is True:
                    break


def main():
    parser = argparse.ArgumentParser(description="Automatically ignore Niri's dGPU on battery with no attached display")
    parser.add_argument("action", choices=("init", "status", "update", "watch"))
    parser.add_argument("--gpu", type=Path, default=Path("/dev/dri/dgpu"))
    parser.add_argument("--fragment", type=Path, default=Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "niri/dgpu-dock.kdl")
    parser.add_argument("--niri", default="niri")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    try:
        if args.action == "status":
            print("active" if should_ignore(args.gpu) else "inactive")
            return 0
        initialize(args.fragment, args.gpu)
        if args.action == "init":
            return 0
        with args.fragment.with_suffix(".lock").open("a") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            controller = Controller(args.gpu, args.fragment, args.niri)
            if args.action == "update":
                return 0 if asyncio.run(controller.refresh()) is not None else 1
            asyncio.run(watch(controller, subsystems=("drm", "power_supply")))
            return 0
    except (OSError, ValueError, RuntimeError, TimeoutError) as exc:
        LOG.error("%s", exc)
        return 1
    except KeyboardInterrupt:
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
