"""Shared event sources and file/process helpers for Niri GPU policies."""

import asyncio
import json
import os
import signal
import tempfile


def replace_text(fragment, content):
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


async def watch(controller, subsystems=("drm",)):
    import pyudev
    from dbus_next import BusType, Message, MessageType
    from dbus_next.aio import MessageBus

    loop = asyncio.get_running_loop()
    monitor = pyudev.Monitor.from_netlink(pyudev.Context())
    for subsystem in subsystems:
        monitor.filter_by(subsystem=subsystem)
    monitor.start()
    errors = loop.create_future()

    def device_events():
        try:
            while monitor.poll(timeout=0) is not None:
                controller.trigger()
        except OSError as exc:
            if not errors.done():
                errors.set_exception(exc)
            loop.remove_reader(monitor.fileno())

    loop.add_reader(monitor.fileno(), device_events)
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


