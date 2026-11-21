import argparse
import asyncio
import fcntl
import json
import logging
import os
from pathlib import Path
import signal
import tempfile

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
    content = ENABLED if active else DISABLED
    if fragment.read_text() == content:
        return False
    name = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", dir=fragment.parent, delete=False) as f:
            name = f.name
            f.write(content)
            f.flush()
            os.fsync(f.fileno())
        os.replace(name, fragment)
    finally:
        if name and os.path.exists(name):
            os.unlink(name)
    return True


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


async def command(*args):
    proc = await asyncio.create_subprocess_exec(
        *args, stdin=asyncio.subprocess.DEVNULL,
        stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE,
    )
    try:
        stdout, stderr = await asyncio.wait_for(proc.communicate(), timeout=10)
        return proc.returncode, stdout.decode(), stderr.decode()
    finally:
        if proc.returncode is None:
            proc.kill()
            await proc.wait()


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


async def watch_niri(controller):
    socket = os.environ.get("NIRI_SOCKET")
    if not socket:
        raise RuntimeError("NIRI_SOCKET is not set")
    reader, writer = await asyncio.wait_for(
        asyncio.open_unix_connection(socket, limit=4 * 1024 * 1024), timeout=10
    )
    try:
        writer.write(b'"EventStream"\n')
        await writer.drain()
        reply = json.loads(await asyncio.wait_for(reader.readline(), timeout=10))
        if reply != {"Ok": "Handled"}:
            raise RuntimeError(f"Niri event subscription failed: {reply}")
        outputs = None
        while line := await reader.readline():
            event = json.loads(line)
            if "WorkspacesChanged" in event:
                current = frozenset(
                    w["output"] for w in event["WorkspacesChanged"]["workspaces"] if w.get("output")
                )
                # Workspace churn is common; query the GPU only if outputs changed.
                if current != outputs:
                    outputs = current
                    controller.trigger()
        raise RuntimeError("Niri event stream disconnected")
    finally:
        writer.close()
        await writer.wait_closed()


async def watch(controller):
    import pyudev
    from dbus_next import BusType, Message, MessageType
    from dbus_next.aio import MessageBus

    loop = asyncio.get_running_loop()
    monitor = pyudev.Monitor.from_netlink(pyudev.Context())
    monitor.filter_by(subsystem="drm")
    monitor.start()
    errors = loop.create_future()

    def drm_events():
        try:
            while monitor.poll(timeout=0) is not None:
                controller.trigger()
        except OSError as exc:
            if not errors.done():
                errors.set_exception(exc)
            loop.remove_reader(monitor.fileno())

    loop.add_reader(monitor.fileno(), drm_events)
    loop.add_signal_handler(signal.SIGUSR1, controller.trigger)
    bus = None
    tasks = []
    try:
        bus = await asyncio.wait_for(MessageBus(bus_type=BusType.SYSTEM).connect(), timeout=10)

        def sleep_signal(msg):
            if (msg.message_type == MessageType.SIGNAL and
                    msg.path == "/org/freedesktop/login1" and
                    msg.interface == "org.freedesktop.login1.Manager" and
                    msg.member == "PrepareForSleep" and msg.signature == "b"):
                controller.sleep_changed(msg.body[0])

        bus.add_message_handler(sleep_signal)
        match = "type='signal',sender='org.freedesktop.login1',path='/org/freedesktop/login1',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'"
        reply = await asyncio.wait_for(bus.call(Message(
            destination="org.freedesktop.DBus", path="/org/freedesktop/DBus",
            interface="org.freedesktop.DBus", member="AddMatch", signature="s", body=[match],
        )), timeout=10)
        if reply.message_type != MessageType.METHOD_RETURN:
            raise RuntimeError(f"Cannot subscribe to resume events: {reply.body}")
        controller.trigger()
        tasks = [
            asyncio.create_task(controller.run()),
            asyncio.create_task(bus.wait_for_disconnect()),
            asyncio.create_task(watch_niri(controller)),
        ]
        done, _ = await asyncio.wait([*tasks, errors], return_when=asyncio.FIRST_COMPLETED)
        for task in done:
            task.result()
        raise RuntimeError("Event source disconnected")
    finally:
        loop.remove_reader(monitor.fileno())
        loop.remove_signal_handler(signal.SIGUSR1)
        for task in tasks:
            task.cancel()
        await asyncio.gather(*tasks, return_exceptions=True)
        errors.cancel()
        if bus:
            bus.disconnect()


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
