import asyncio
from contextlib import suppress
from pathlib import Path
import tempfile
import unittest
from unittest.mock import AsyncMock, Mock, patch

import watcher


class FragmentTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.fragment = Path(self.tmp.name) / "niri" / "mst.kdl"

    def test_initialize_creates_enabled_default_and_preserves_existing(self):
        watcher.initialize(self.fragment)
        self.assertEqual(self.fragment.read_text(), watcher.ENABLED)
        self.fragment.write_text("custom content\n")
        watcher.initialize(self.fragment)
        self.assertEqual(self.fragment.read_text(), "custom content\n")

    def test_atomic_write_only_replaces_changed_content(self):
        watcher.initialize(self.fragment)
        with patch.object(watcher.os, "replace", wraps=watcher.os.replace) as replace:
            self.assertFalse(watcher.write_fragment(self.fragment, True))
            replace.assert_not_called()
            self.assertTrue(watcher.write_fragment(self.fragment, False))
            replace.assert_called_once()
            source, destination = replace.call_args.args
            self.assertEqual(Path(source).parent, self.fragment.parent)
            self.assertEqual(destination, self.fragment)
            self.assertEqual(self.fragment.read_text(), watcher.DISABLED)
            self.assertFalse(watcher.write_fragment(self.fragment, False))
            self.assertEqual(replace.call_count, 1)
        self.assertEqual(list(self.fragment.parent.iterdir()), [self.fragment])


class GpuTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        root = Path(self.tmp.name)
        self.drm = root / "drm"
        card = self.drm / "card1"
        card.mkdir(parents=True)
        self.device = root / "0000:01:00.0"
        self.device.mkdir()
        (self.device / "vendor").write_text("0x10de\n")
        (card / "device").symlink_to(self.device)
        self.gpu = root / "dgpu"
        self.gpu.symlink_to(card)

    def connector(self, name, status):
        connector = self.drm / ("card1-" + name)
        connector.mkdir()
        if status is not None:
            (connector / "status").write_text(status + "\n")

    def test_connected_external_returns_pci_address(self):
        self.connector("DP-1", "connected")
        self.assertEqual(watcher.gpu_address(self.gpu, self.drm), "0000:01:00.0")

    def test_disconnected_and_internal_only_are_inactive(self):
        self.connector("DP-1", "disconnected")
        self.connector("eDP-1", "connected")
        self.connector("LVDS-1", "connected")
        self.assertIsNone(watcher.gpu_address(self.gpu, self.drm))

    def test_non_nvidia_is_rejected(self):
        (self.device / "vendor").write_text("0x8086\n")
        with self.assertRaisesRegex(ValueError, "not an NVIDIA"):
            watcher.gpu_address(self.gpu, self.drm)

    def test_unknown_status_is_rejected(self):
        self.connector("DP-1", "unknown")
        with self.assertRaisesRegex(ValueError, "incomplete"):
            watcher.gpu_address(self.gpu, self.drm)

    def test_missing_status_is_rejected(self):
        self.connector("DP-1", None)
        with self.assertRaises(FileNotFoundError):
            watcher.gpu_address(self.gpu, self.drm)

    def test_missing_connectors_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "No connectors"):
            watcher.gpu_address(self.gpu, self.drm)


class DetectTests(unittest.IsolatedAsyncioTestCase):
    async def test_disconnected_skips_probe(self):
        with patch.object(watcher, "gpu_address", return_value=None), patch.object(
            watcher, "command", new_callable=AsyncMock
        ) as command:
            self.assertIs(await watcher.detect("gpu", "probe"), False)
            command.assert_not_awaited()

    async def test_probe_return_code_and_output_contract(self):
        cases = [(0, "active\n", True), (1, "inactive\n", False),
                 (0, "inactive", None), (1, "active", None),
                 (2, "active", None), (0, "", None)]
        for code, output, expected in cases:
            with self.subTest(code=code, output=output), patch.object(
                watcher, "gpu_address", return_value="0000:01:00.0"
            ), patch.object(watcher, "command", new_callable=AsyncMock) as command:
                command.return_value = (code, output, "diagnostic")
                if expected is None:
                    with self.assertRaisesRegex(RuntimeError, "diagnostic"):
                        await watcher.detect("gpu", "probe")
                else:
                    self.assertIs(await watcher.detect("gpu", "probe"), expected)
                command.assert_awaited_once_with("probe", "0000:01:00.0")

    async def test_command_timeout_kills_and_reaps_process(self):
        proc = Mock(returncode=None)
        proc.communicate = AsyncMock()
        proc.wait = AsyncMock(return_value=-9)

        async def timeout(awaitable, timeout):
            await awaitable
            raise TimeoutError

        with patch.object(watcher.asyncio, "create_subprocess_exec", AsyncMock(return_value=proc)), patch.object(
            watcher.asyncio, "wait_for", side_effect=timeout
        ):
            with self.assertRaises(TimeoutError):
                await watcher.command("probe", "pci")
        proc.kill.assert_called_once_with()
        proc.wait.assert_awaited_once_with()


class ControllerTests(unittest.IsolatedAsyncioTestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.fragment = Path(self.tmp.name) / "mst.kdl"
        watcher.initialize(self.fragment)
        self.controller = watcher.Controller("gpu", "probe", self.fragment, "niri")
        self.controller.pending_reload = False
        self.detect = self.enterContext(patch.object(watcher, "detect", new_callable=AsyncMock))
        self.command = self.enterContext(patch.object(watcher, "command", new_callable=AsyncMock))
        self.command.return_value = (0, "", "")

    async def test_startup_reloads_an_existing_fragment_once(self):
        self.controller.pending_reload = True
        self.detect.return_value = True
        await self.controller.refresh()
        await self.controller.refresh()
        self.command.assert_awaited_once()
        self.assertFalse(self.controller.pending_reload)

    async def test_active_inactive_reload_only_on_changes(self):
        for active in (True, False, False, True, True):
            self.detect.return_value = active
            self.assertIs(await self.controller.refresh(), active)
            self.assertEqual(self.fragment.read_text(), watcher.ENABLED if active else watcher.DISABLED)
        self.assertEqual(self.command.await_count, 2)
        self.command.assert_awaited_with("niri", "msg", "action", "load-config-file")

    async def test_unknown_preserves_fragment(self):
        for error in (OSError("missing"), ValueError("unknown"), RuntimeError("probe"), TimeoutError()):
            with self.subTest(error=type(error).__name__):
                self.detect.side_effect = error
                with self.assertLogs(watcher.LOG, level="WARNING"):
                    self.assertIsNone(await self.controller.refresh())
                self.assertEqual(self.fragment.read_text(), watcher.ENABLED)
        self.command.assert_not_awaited()

    async def test_disable_delayed_until_allowed(self):
        self.detect.return_value = False
        self.assertIs(await self.controller.refresh(allow_disable=False), False)
        self.assertEqual(self.fragment.read_text(), watcher.ENABLED)
        self.command.assert_not_awaited()
        await self.controller.refresh(allow_disable=True)
        self.assertEqual(self.fragment.read_text(), watcher.DISABLED)
        self.command.assert_awaited_once()

    async def test_stale_epoch_or_suspend_discards_detection(self):
        for invalidate in (self.controller.trigger, lambda: self.controller.sleep_changed(True)):
            with self.subTest(invalidate=invalidate):
                self.controller.sleeping = False

                async def detect(*args):
                    invalidate()
                    return False

                self.detect.side_effect = detect
                self.assertIsNone(await self.controller.refresh())
                self.assertEqual(self.fragment.read_text(), watcher.ENABLED)
        self.command.assert_not_awaited()

    async def test_failed_reload_retried_with_unchanged_fragment(self):
        self.detect.return_value = False
        self.command.side_effect = [(1, "", "failed"), (0, "", "")]
        with self.assertLogs(watcher.LOG, level="WARNING"):
            self.assertIsNone(await self.controller.refresh())
        self.assertTrue(self.controller.pending_reload)
        self.assertEqual(self.fragment.read_text(), watcher.DISABLED)
        self.assertIs(await self.controller.refresh(), False)
        self.assertFalse(self.controller.pending_reload)
        await self.controller.refresh()
        self.assertEqual(self.command.await_count, 2)

    async def start_runner(self):
        self.enterContext(patch.object(watcher, "SETTLE_DELAYS", (0.01, 0.01, 0.01)))
        task = asyncio.create_task(self.controller.run())

        async def cleanup():
            task.cancel()
            with suppress(asyncio.CancelledError):
                await task

        self.addAsyncCleanup(cleanup)
        return task

    async def wait_calls(self, mock, count):
        async def reached():
            while mock.await_count < count:
                await asyncio.sleep(0.001)
        await asyncio.wait_for(reached(), timeout=1)

    async def test_run_bounded_retries_and_no_idle_polling(self):
        for result in (None, False):
            with self.subTest(result=result):
                refresh = AsyncMock(return_value=result)
                with patch.object(self.controller, "refresh", refresh):
                    task = await self.start_runner()
                    await asyncio.sleep(0.02)
                    refresh.assert_not_awaited()
                    self.controller.trigger()
                    await self.wait_calls(refresh, 3)
                    self.assertEqual([c.kwargs["allow_disable"] for c in refresh.await_args_list],
                                     [False, False, True])
                    await asyncio.sleep(0.05)
                    self.assertEqual(refresh.await_count, 3)
                    task.cancel()
                    with suppress(asyncio.CancelledError):
                        await task

    async def test_run_debounces_events_and_stops_on_active(self):
        with patch.object(self.controller, "refresh", AsyncMock(return_value=True)) as refresh:
            await self.start_runner()
            self.controller.trigger()
            await asyncio.sleep(0)
            for _ in range(3):
                self.controller.trigger()
                await asyncio.sleep(0.002)
            refresh.assert_not_awaited()
            await self.wait_calls(refresh, 1)
            await asyncio.sleep(0.05)
            self.assertEqual(refresh.await_count, 1)

    async def test_resume_triggers_detection_but_suspend_does_not(self):
        with patch.object(self.controller, "refresh", AsyncMock(return_value=True)) as refresh:
            await self.start_runner()
            self.controller.sleep_changed(True)
            await asyncio.sleep(0.05)
            refresh.assert_not_awaited()
            epoch = self.controller.epoch
            self.controller.sleep_changed(False)
            self.assertEqual(self.controller.epoch, epoch + 1)
            await self.wait_calls(refresh, 1)
            refresh.assert_awaited_once_with(allow_disable=False)


class NiriEventsTests(unittest.IsolatedAsyncioTestCase):
    async def test_output_changes_trigger_but_workspace_churn_does_not(self):
        reader = asyncio.StreamReader()
        reader.feed_data(b'{"Ok":"Handled"}\n')
        for outputs in (("eDP-1",), ("eDP-1", "eDP-1"), ("eDP-1", "DP-5"), ("eDP-1",)):
            event = {"WorkspacesChanged": {"workspaces": [{"output": o} for o in outputs]}}
            reader.feed_data((watcher.json.dumps(event) + "\n").encode())
        reader.feed_eof()
        writer = Mock(drain=AsyncMock(), wait_closed=AsyncMock())
        controller = Mock()
        with patch.dict(watcher.os.environ, {"NIRI_SOCKET": "/test/niri.sock"}), patch.object(
            watcher.asyncio, "open_unix_connection", AsyncMock(return_value=(reader, writer))
        ):
            with self.assertRaisesRegex(RuntimeError, "disconnected"):
                await watcher.watch_niri(controller)
        self.assertEqual(controller.trigger.call_count, 3)
        writer.write.assert_called_once_with(b'"EventStream"\n')
        writer.close.assert_called_once()

    async def test_subscription_error_is_not_silently_ignored(self):
        reader = asyncio.StreamReader()
        reader.feed_data(b'{"Err":"failed"}\n')
        writer = Mock(drain=AsyncMock(), wait_closed=AsyncMock())
        with patch.dict(watcher.os.environ, {"NIRI_SOCKET": "/test/niri.sock"}), patch.object(
            watcher.asyncio, "open_unix_connection", AsyncMock(return_value=(reader, writer))
        ):
            with self.assertRaisesRegex(RuntimeError, "subscription failed"):
                await watcher.watch_niri(Mock())
        writer.close.assert_called_once()


if __name__ == "__main__":
    unittest.main()
