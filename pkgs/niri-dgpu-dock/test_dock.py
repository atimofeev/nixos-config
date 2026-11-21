import asyncio
import contextlib
import io
from pathlib import Path
import tempfile
import unittest
from unittest.mock import AsyncMock, patch

import dock


class Files(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.power = self.root / "power_supply"
        self.power.mkdir()
        self.drm = self.root / "drm"
        self.drm.mkdir()
        self.card = self.drm / "card17"
        self.card.mkdir()
        self.gpu = self.root / "dgpu"
        self.gpu.symlink_to(self.card)
        self.fragment = self.root / "config/dock.kdl"

    def supply(self, name, **attributes):
        path = self.power / name
        path.mkdir()
        for key, value in attributes.items():
            if value is not None:
                (path / key).write_text(str(value) + "\n")

    def connector(self, name, status):
        path = self.drm / name
        path.mkdir(exist_ok=True)
        if status is not None:
            (path / "status").write_text(status)

    def test_power_truth_table(self):
        cases = [
            ({"type": "Mains", "online": "1"}, "Discharging", True, False),
            ({"type": "Mains", "online": "0"}, "Discharging", True, True),
            ({"type": "Mains", "online": "0"}, "Unknown", True, True),
            ({"type": "Mains", "online": "0"}, "Full", True, True),
            ({"type": "Mains", "online": "0"}, "Charging", True, False),
            (None, "Charging", True, False),
            (None, "Discharging", True, True),
            (None, "Unknown", True, ValueError),
            ({"type": "Mains"}, "Unknown", True, ValueError),
            (None, None, True, ValueError),
            ({"type": "Mains", "online": "unknown"}, "Discharging", True, ValueError),
            (None, "Unknown", False, False),
        ]
        for index, (source, status, present, expected) in enumerate(cases):
            with self.subTest(index=index), tempfile.TemporaryDirectory() as directory:
                old = self.power
                self.power = Path(directory)
                try:
                    self.supply("BAT0", type="Battery", status=status, present=int(present))
                    if source:
                        self.supply("AC", **source)
                    if expected is ValueError:
                        with self.assertRaises(ValueError):
                            dock.on_battery(self.power)
                    else:
                        self.assertIs(dock.on_battery(self.power), expected)
                finally:
                    self.power = old

    def test_no_battery_and_peripheral_supplies(self):
        self.assertFalse(dock.on_battery(self.power))
        self.supply("mouse", type="Battery", scope="Device", status=None)
        self.supply("usb", type="USB", scope="Device", online="unknown")
        self.assertFalse(dock.on_battery(self.power))
        self.supply("BAT0", type="Battery", status="Discharging")
        self.assertTrue(dock.on_battery(self.power))
        self.supply("ACAD", type="Mains", online="1")
        (self.power / "BAT0/status").write_text("Charging\n")
        self.assertFalse(dock.on_battery(self.power))

    def test_should_ignore_truth_table_and_ac_short_circuit(self):
        for battery, attached, expected in [(False, False, False), (False, True, False),
                                             (True, False, True), (True, True, False)]:
            with self.subTest(battery=battery, attached=attached), \
                    patch.object(dock, "on_battery", return_value=battery), \
                    patch.object(dock, "connected", return_value=attached) as detect:
                self.assertIs(dock.should_ignore(self.gpu), expected)
                if battery:
                    detect.assert_called_once_with(self.gpu)
                else:
                    detect.assert_not_called()

    def test_connected_selects_card_and_accepts_connected_over_unknown(self):
        self.connector("card0-HDMI-A-1", "connected\n")
        self.connector("card17-DP-3", "disconnected\n")
        self.assertFalse(dock.connected(self.gpu, self.drm))
        self.connector("card17-DP-9", "connected\n")
        (self.drm / "card17-DP-3/status").write_text("unknown\n")
        self.assertTrue(dock.connected(self.gpu, self.drm))

    def test_connected_fails_safely(self):
        with self.assertRaises(ValueError):
            dock.connected(self.gpu, self.drm)
        self.connector("card17-DP-1", "unknown\n")
        with self.assertRaises(ValueError):
            dock.connected(self.gpu, self.drm)
        (self.drm / "card17-DP-1/status").unlink()
        with self.assertRaises(FileNotFoundError):
            dock.connected(self.gpu, self.drm)
        self.gpu.unlink()
        with self.assertRaises(FileNotFoundError):
            dock.connected(self.gpu, self.drm)
        self.gpu.symlink_to(self.root)
        with self.assertRaises(ValueError):
            dock.connected(self.gpu, self.drm)

    def test_status_uses_policy_and_never_writes(self):
        self.fragment.parent.mkdir()
        mode = self.fragment.with_suffix(".mode")
        for ignore in (False, True):
            with self.subTest(ignore=ignore):
                self.fragment.write_text(dock.BOUND if ignore else dock.ignored(self.gpu))
                mode.write_text("off" if ignore else "on")
                before = {p.name: (p.read_bytes(), p.stat()) for p in self.fragment.parent.iterdir()}
                output = io.StringIO()
                with patch("sys.argv", ["dock", "status", "--fragment", str(self.fragment), "--gpu", str(self.gpu)]), \
                        patch.object(dock, "should_ignore", return_value=ignore) as policy, \
                        patch.object(dock, "initialize") as initialize, \
                        contextlib.redirect_stdout(output):
                    self.assertEqual(dock.main(), 0)
                policy.assert_called_once_with(self.gpu)
                initialize.assert_not_called()
                self.assertEqual(output.getvalue(), "active\n" if ignore else "inactive\n")
                self.assertEqual(set(before), {p.name for p in self.fragment.parent.iterdir()})
                for p in self.fragment.parent.iterdir():
                    content, stat = before[p.name]
                    self.assertEqual(p.read_bytes(), content)
                    self.assertEqual((p.stat().st_ino, p.stat().st_mtime_ns), (stat.st_ino, stat.st_mtime_ns))

    def test_legacy_actions_rejected(self):
        for action in ("auto", "on", "off", "toggle"):
            with self.subTest(action=action), patch("sys.argv", ["dock", action]), \
                    contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit) as error:
                dock.main()
            self.assertEqual(error.exception.code, 2)
        self.assertFalse(self.fragment.parent.exists())

    def test_initialize_retires_mode_preserves_fragment(self):
        self.fragment.parent.mkdir()
        self.fragment.write_text("existing\n")
        self.fragment.chmod(0o640)
        before = self.fragment.stat()
        mode = self.fragment.with_suffix(".mode")
        mode.write_text("off\n")
        with patch.object(dock, "should_ignore") as policy:
            dock.initialize(self.fragment, self.gpu)
        policy.assert_not_called()
        self.assertFalse(mode.exists())
        self.assertEqual(self.fragment.read_text(), "existing\n")
        self.assertEqual(self.fragment.stat(), before)

    def test_initialize_policy_and_unknown_first_start(self):
        for result in (True, False, ValueError("unknown"), FileNotFoundError("missing")):
            with self.subTest(result=result):
                self.fragment.unlink(missing_ok=True)
                with patch.object(dock, "should_ignore", return_value=result,
                                  side_effect=result if isinstance(result, Exception) else None):
                    dock.initialize(self.fragment, self.gpu)
                self.assertEqual(self.fragment.read_text(), dock.ignored(self.gpu) if result is True else dock.BOUND)


class ControllerTests(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.fragment = Path(temp.name) / "dock.kdl"
        self.fragment.write_text(dock.BOUND)
        self.gpu = Path(temp.name) / "dgpu"
        self.reload = AsyncMock(return_value=(0, "", ""))
        self.real_policy = dock.should_ignore
        self.policy = self.enterContext(patch.object(dock, "should_ignore", return_value=False))
        self.enterContext(patch.object(dock, "command", self.reload))
        self.controller = dock.Controller(self.gpu, self.fragment, "fake-niri")

    async def test_startup_reload_and_no_redundant_writes(self):
        before = self.fragment.stat()
        self.assertTrue(await self.controller.refresh())
        self.reload.assert_awaited_once_with("fake-niri", "msg", "action", "load-config-file")
        self.assertTrue(await self.controller.refresh())
        self.assertEqual(self.fragment.stat(), before)
        self.assertEqual(self.reload.await_count, 1)
        self.policy.return_value = True
        self.assertFalse(await self.controller.refresh())
        changed = self.fragment.stat()
        self.assertFalse(await self.controller.refresh())
        self.assertEqual(self.fragment.stat(), changed)
        self.assertEqual(self.reload.await_count, 2)

    async def test_ignore_delayed_but_available_immediate(self):
        self.policy.return_value = True
        self.assertFalse(await self.controller.refresh(allow_disable=False))
        self.assertEqual(self.fragment.read_text(), dock.BOUND)
        self.reload.assert_not_awaited()
        self.assertFalse(await self.controller.refresh(allow_disable=True))
        self.assertEqual(self.fragment.read_text(), dock.ignored(self.gpu))
        with patch.object(dock, "on_battery", return_value=False), \
                patch.object(dock, "connected", side_effect=AssertionError("AC must short circuit")):
            self.policy.side_effect = self.real_policy
            self.assertTrue(await self.controller.refresh(allow_disable=False))
        self.assertEqual(self.fragment.read_text(), dock.BOUND)

    async def test_unplugging_ac_with_display_attached_does_not_ignore_or_reload(self):
        self.policy.side_effect = self.real_policy
        with patch.object(dock, "on_battery", return_value=False) as battery, \
                patch.object(dock, "connected", return_value=True):
            self.assertTrue(await self.controller.refresh())
            before = self.fragment.stat()
            battery.return_value = True
            self.assertTrue(await self.controller.refresh())
        self.assertEqual(self.fragment.read_text(), dock.BOUND)
        self.assertEqual(self.fragment.stat(), before)
        self.reload.assert_awaited_once()  # Initial startup only, not the AC transition.

    async def test_detection_failure_preserves_both_states(self):
        for content in (dock.BOUND, dock.ignored(self.gpu)):
            for error in (ValueError("unknown"), FileNotFoundError("missing"), TimeoutError()):
                with self.subTest(content=content, error=error):
                    self.fragment.write_text(content)
                    before = self.fragment.stat()
                    self.policy.side_effect = error
                    self.assertIsNone(await self.controller.refresh())
                    self.assertEqual(self.fragment.read_text(), content)
                    self.assertEqual(self.fragment.stat(), before)
        self.reload.assert_not_awaited()

    async def test_reload_failure_retries_without_rewrite(self):
        self.policy.return_value = True
        self.reload.side_effect = [(1, "", "failed"), (0, "", "")]
        self.assertIsNone(await self.controller.refresh())
        self.assertTrue(self.controller.pending_reload)
        self.assertEqual(self.fragment.read_text(), dock.ignored(self.gpu))
        before = self.fragment.stat()
        self.assertFalse(await self.controller.refresh())
        self.assertFalse(self.controller.pending_reload)
        self.assertEqual(self.fragment.stat(), before)
        self.assertEqual(self.reload.await_count, 2)

    async def wait_calls(self, mock, count):
        async def wait():
            while mock.await_count < count:
                await asyncio.sleep(0.001)
        await asyncio.wait_for(wait(), 1)

    async def stop(self, task):
        task.cancel()
        with contextlib.suppress(asyncio.CancelledError):
            await task

    async def test_event_retry_policy_and_no_idle_polling(self):
        for result, expected in ((None, [False, False, True]),
                                 (False, [False, False, True]), (True, [False])):
            with self.subTest(result=result), patch.object(dock, "SETTLE_DELAYS", (0.001,) * 3):
                controller = dock.Controller(self.gpu, self.fragment, "fake-niri")
                controller.refresh = AsyncMock(return_value=result)
                task = asyncio.create_task(controller.run())
                try:
                    await asyncio.sleep(0.01)
                    controller.refresh.assert_not_awaited()
                    for cycle in (1, 2):
                        controller.trigger()
                        await self.wait_calls(controller.refresh, cycle * len(expected))
                        await asyncio.sleep(0.02)
                        self.assertEqual([c.kwargs["allow_disable"] for c in controller.refresh.await_args_list], expected * cycle)
                finally:
                    await self.stop(task)

    async def test_new_event_restarts_settling_window(self):
        with patch.object(dock, "SETTLE_DELAYS", (0.05,) * 3):
            self.controller.refresh = AsyncMock(return_value=False)
            task = asyncio.create_task(self.controller.run())
            try:
                self.controller.trigger()
                await self.wait_calls(self.controller.refresh, 1)
                self.controller.trigger()
                await self.wait_calls(self.controller.refresh, 2)
                self.assertEqual([c.kwargs["allow_disable"] for c in self.controller.refresh.await_args_list], [False, False])
            finally:
                await self.stop(task)

    async def test_suspend_preserves_resume_triggers(self):
        self.controller.sleep_changed(True)
        before = self.fragment.stat()
        self.assertIsNone(await self.controller.refresh())
        self.policy.assert_not_called()
        self.reload.assert_not_awaited()
        self.assertEqual(self.fragment.stat(), before)
        with patch.object(dock, "SETTLE_DELAYS", (0.001,) * 3):
            task = asyncio.create_task(self.controller.run())
            try:
                await asyncio.sleep(0.01)
                self.reload.assert_not_awaited()
                self.controller.sleep_changed(False)
                await self.wait_calls(self.reload, 1)
                self.assertFalse(self.controller.sleeping)
                self.assertFalse(self.controller.pending_reload)
            finally:
                await self.stop(task)


if __name__ == "__main__":
    unittest.main()
