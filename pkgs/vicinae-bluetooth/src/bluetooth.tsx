import { Action, ActionPanel, Color, Icon, Keyboard, List, Toast, showToast } from "@vicinae/api";
import { useCallback, useEffect, useRef, useState } from "react";
import { createBlueZ, type Device, type Snapshot } from "./bluez";

const bluez = createBlueZ();
const deviceIcons: Record<string, Icon> = {
  "audio-card": Icon.Speaker,
  "audio-headphones": Icon.Headphones,
  "audio-headset": Icon.Headphones,
  "input-gaming": Icon.GameController,
  "input-keyboard": Icon.Keyboard,
  "input-mouse": Icon.Mouse,
  phone: Icon.Phone,
};

export default function BluetoothPicker() {
  const [snapshot, setSnapshot] = useState<Snapshot>({ adapters: [], devices: [] });
  const [loading, setLoading] = useState(true);
  const [pending, setPending] = useState<{ path: string; connecting: boolean } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const mounted = useRef(false);
  const refreshing = useRef(false);
  const toggling = useRef(false);

  const refresh = useCallback(async () => {
    if (refreshing.current) return;
    refreshing.current = true;
    try {
      const next = await bluez.list();
      if (mounted.current) {
        setSnapshot(next);
        setError(null);
      }
    } catch (error) {
      if (mounted.current) {
        setSnapshot({ adapters: [], devices: [] });
        setError(error instanceof Error ? error.message : String(error));
      }
    } finally {
      refreshing.current = false;
      if (mounted.current) setLoading(false);
    }
  }, []);

  useEffect(() => {
    mounted.current = true;
    void refresh();
    const timer = setInterval(() => void refresh(), 3000);
    return () => {
      mounted.current = false;
      clearInterval(timer);
    };
  }, [refresh]);

  async function toggle(device: Device) {
    if (toggling.current) return;
    toggling.current = true;
    setPending({ path: device.path, connecting: !device.connected });
    try {
      const toast = await showToast({
        style: Toast.Style.Animated,
        title: device.connected ? "Disconnecting device..." : "Connecting device...",
        message: device.name,
      });
      try {
        const connected = await bluez.toggle(device.path);
        toast.style = Toast.Style.Success;
        toast.title = connected ? "Device connected" : "Device disconnected";
      } catch (error) {
        toast.style = Toast.Style.Failure;
        toast.title = "Bluetooth operation failed";
        toast.message = error instanceof Error ? error.message : String(error);
      }
    } finally {
      toggling.current = false;
      if (mounted.current) {
        setPending(null);
        void refresh();
      }
    }
  }

  const refreshAction = (
    <Action
      title="Refresh"
      icon={Icon.ArrowClockwise}
      shortcut={Keyboard.Shortcut.Common.Refresh}
      onAction={() => void refresh()}
    />
  );

  return (
    <List
      isLoading={loading || pending !== null}
      searchBarPlaceholder="Search paired Bluetooth devices..."
      actions={<ActionPanel>{refreshAction}</ActionPanel>}
    >
      <List.EmptyView
        icon={error ? Icon.Warning : Icon.Bluetooth}
        title={error ? "Cannot load Bluetooth devices" : loading ? "Loading Bluetooth devices..."
          : snapshot.adapters.length === 0 ? "No Bluetooth adapter" : "No paired devices"}
        description={error ?? "Pair devices in system Bluetooth settings first. This picker reconnects existing devices."}
      />
      {snapshot.devices.map((device) => {
        const adapter = snapshot.adapters.find((adapter) => adapter.path === device.adapter);
        const status = pending?.path === device.path
          ? pending.connecting ? "Connecting..." : "Disconnecting..."
          : device.connected ? "Connected" : device.blocked ? "Blocked"
            : adapter?.powered ? "Disconnected" : "Bluetooth off";
        const accessories: List.Item.Accessory[] = [{ text: status }];
        if (device.battery !== undefined) accessories.push({ text: `${device.battery}%`, icon: Icon.Battery });
        if (snapshot.adapters.length > 1 && adapter) accessories.push({ text: adapter.name });
        return (
          <List.Item
            key={device.path}
            id={device.path}
            title={device.name}
            subtitle={device.address}
            icon={{ source: deviceIcons[device.icon] ?? Icon.Bluetooth,
              tintColor: device.connected ? Color.Green : Color.SecondaryText }}
            accessories={accessories}
            actions={
              <ActionPanel>
                {!pending && (
                  <Action
                    title={device.connected ? "Disconnect" : "Connect"}
                    icon={device.connected ? Icon.XMarkCircle : Icon.Plug}
                    onAction={() => void toggle(device)}
                  />
                )}
                {refreshAction}
              </ActionPanel>
            }
          />
        );
      })}
    </List>
  );
}
