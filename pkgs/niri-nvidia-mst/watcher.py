import argparse
import asyncio
import fcntl
import json
import logging
import os
from pathlib import Path
import signal

from niri_session import command, replace_text, watch, watch_niri

LOG = logging.getLogger("niri-nvidia-mst")
ENABLED = "debug {\n    wait-for-frame-completion-before-queueing\n}\n"
DISABLED = "// No active NVIDIA MST display.\n"
SETTLE_DELAYS = (0.5, 1.0, 2.0)


def initialize(fragment):
    fragment.parent.mkdir(parents=True, exist_ok=True)
    try:
        with fragment.open("x") as f:
            # Preserve the previous always-enabled behavior until detection succeeds.
            f.write(ENABLED)
    except FileExistsError:
        pass


def write_fragment(fragment, active):
    return replace_text(fragment, ENABLED if active else DISABLED)


def gpu_address(gpu, drm=Path("/sys/class/drm")):
    card = gpu.resolve(strict=True).name
    device = drm / card / "device"
    if (device / "vendor").read_text().strip() != "0x10de":
        raise ValueError(f"{gpu} is not an NVIDIA GPU")
    connectors = list(drm.glob(f"{card}-*"))
    if not connectors:
        raise ValueError(f"No connectors found for {gpu}")
    # Status reads do not open NVIDIA's device nodes or hold an RM client alive.
    external = [c for c in connectors if not c.name.startswith((f"{card}-eDP-", f"{card}-LVDS-"))]
    states = [(c / "status").read_text().strip() for c in external]
    if any(s not in ("connected", "disconnected") for s in states):
        raise ValueError("Connector detection is incomplete")
    return device.resolve(strict=True).name if "connected" in states else None


async def detect(gpu, probe):
    pci = gpu_address(gpu)
    if pci is None:
        return False
    code, stdout, stderr = await command(probe, pci)
    if (code, stdout.strip()) == (0, "active"):
        return True
    if (code, stdout.strip()) == (1, "inactive"):
        return False
    raise RuntimeError(f"Probe failed ({code}): {stderr.strip() or stdout.strip()}")


class Controller:
    def __init__(self, gpu, probe, fragment, niri):
        self.gpu, self.probe, self.fragment, self.niri = gpu, probe, fragment, niri
        self.event = asyncio.Event()
        self.epoch = 0
        self.sleeping = False
        # A previous process may have exited after writing but before reloading.
        self.pending_reload = True

    def trigger(self):
        self.epoch += 1
        self.event.set()

    def sleep_changed(self, sleeping):
        self.sleeping = sleeping
        self.trigger()

    async def refresh(self, allow_disable=True):
        epoch = self.epoch
        try:
            active = await detect(self.gpu, self.probe)
            if self.sleeping or epoch != self.epoch:
                return None
            # Delay disabling until the compositor has had time to bind/modeset.
            if active or allow_disable:
                if write_fragment(self.fragment, active):
                    LOG.info("Frame-completion workaround %s", "enabled" if active else "disabled")
                    self.pending_reload = True
                if self.pending_reload:
                    code, _, stderr = await command(self.niri, "msg", "action", "load-config-file")
                    if code:
                        raise RuntimeError(f"Niri reload failed ({code}): {stderr.strip()}")
                    self.pending_reload = False
            return active
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
                    break  # A new event restarts the settling window.
                except TimeoutError:
                    pass
                result = await self.refresh(allow_disable=i == len(SETTLE_DELAYS) - 1)
                if result is True:
                    break


def main():
    parser = argparse.ArgumentParser(description="Enable Niri's frame-completion workaround for active NVIDIA MST")
    parser.add_argument("action", choices=("init", "status", "update", "watch"))
    parser.add_argument("--gpu", type=Path, default=Path("/dev/dri/dgpu"))
    parser.add_argument("--fragment", type=Path, default=Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "niri/nvidia-mst.kdl")
    parser.add_argument("--probe", default=os.environ.get("NVKMS_PROBE", "nvidia-mst-probe"))
    parser.add_argument("--niri", default="niri")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    try:
        if args.action == "status":
            print("active" if asyncio.run(detect(args.gpu, args.probe)) else "inactive")
            return 0
        initialize(args.fragment)
        if args.action == "init":
            return 0
        with args.fragment.with_suffix(".lock").open("w") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            controller = Controller(args.gpu, args.probe, args.fragment, args.niri)
            if args.action == "update":
                return 0 if asyncio.run(controller.refresh()) is not None else 1
            asyncio.run(watch(controller))
    except (OSError, ValueError, RuntimeError, TimeoutError) as exc:
        LOG.error("%s", exc)
        return 1
    except KeyboardInterrupt:
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
