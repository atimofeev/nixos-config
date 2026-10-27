import { Action, ActionPanel, Color, Icon, Keyboard, List, Toast, showToast } from "@vicinae/api";
import { useCallback, useEffect, useRef, useState } from "react";
import { createWiFi, type Network } from "./nmcli";

const wifi = createWiFi();

export default function WiFiPicker() {
  const [networks, setNetworks] = useState<Network[]>([]);
  const [loading, setLoading] = useState(true);
  const [scanning, setScanning] = useState(false);
  const [pending, setPending] = useState<{ id: string; connecting: boolean } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const mounted = useRef(false);
  const refreshing = useRef<Promise<string | null> | null>(null);
  const busy = useRef(false);

  const refresh = useCallback((rescan = false): Promise<string | null> => {
    const previous = refreshing.current;
    if (previous && !rescan) return previous;
    const request = (async () => {
      // Explicit rescans wait for an in-flight cached read instead of being dropped.
      if (previous) await previous;
      try {
        const next = await wifi.list(rescan);
        if (mounted.current) {
          setNetworks(next);
          setError(null);
        }
        return null;
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        if (mounted.current) {
          setNetworks([]);
          setError(message);
        }
        return message;
      } finally {
        if (mounted.current) setLoading(false);
      }
    })();
    refreshing.current = request;
    void request.then(() => {
      if (refreshing.current === request) refreshing.current = null;
    });
    return request;
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

  async function toggle(network: Network) {
    if (busy.current) return;
    busy.current = true;
    setPending({ id: network.id, connecting: !network.connected });
    try {
      const toast = await showToast({
        style: Toast.Style.Animated,
        title: network.connected ? "Disconnecting Wi-Fi..." : "Connecting to Wi-Fi...",
        message: network.ssid,
      });
      try {
        const connected = await wifi.toggle(network.id);
        toast.style = Toast.Style.Success;
        toast.title = connected ? "Wi-Fi connected" : "Wi-Fi disconnected";
      } catch (error) {
        toast.style = Toast.Style.Failure;
        toast.title = "Wi-Fi operation failed";
        toast.message = error instanceof Error ? error.message : String(error);
      }
    } finally {
      busy.current = false;
      if (mounted.current) {
        setPending(null);
        void refresh();
      }
    }
  }

  async function rescan() {
    if (busy.current) return;
    busy.current = true;
    setScanning(true);
    try {
      const toast = await showToast({ style: Toast.Style.Animated, title: "Scanning for Wi-Fi networks..." });
      const error = await refresh(true);
      toast.style = error ? Toast.Style.Failure : Toast.Style.Success;
      toast.title = error ? "Wi-Fi scan failed" : "Wi-Fi networks refreshed";
      if (error) toast.message = error;
    } finally {
      busy.current = false;
      if (mounted.current) setScanning(false);
    }
  }

  const scanAction = !pending && !scanning ? (
    <Action
      title="Rescan Networks"
      icon={Icon.ArrowClockwise}
      shortcut={Keyboard.Shortcut.Common.Refresh}
      onAction={() => void rescan()}
    />
  ) : null;

  return (
    <List
      isLoading={loading || scanning || pending !== null}
      searchBarPlaceholder="Search Wi-Fi networks..."
      actions={<ActionPanel>{scanAction}</ActionPanel>}
    >
      <List.EmptyView
        icon={error ? Icon.Warning : Icon.Wifi}
        title={error ? "Cannot load Wi-Fi networks" : loading ? "Loading Wi-Fi networks..." : "No Wi-Fi networks"}
        description={error ?? "Enable Wi-Fi in system settings, then use Rescan Networks. Hidden networks require a profile in system settings."}
      />
      {networks.map((network) => {
        const status = pending?.id === network.id
          ? pending.connecting ? "Connecting..." : "Disconnecting..."
          : network.connected ? "Connected" : "";
        const accessories: List.Item.Accessory[] = [{ text: `${network.signal}%` }];
        if (status) accessories.unshift({ text: status });
        return (
          <List.Item
            key={network.id}
            id={network.id}
            title={network.ssid}
            subtitle={`${network.security || "Open"} | ${network.device}`}
            icon={{ source: Icon.Wifi, tintColor: network.connected ? Color.Green : Color.SecondaryText }}
            accessories={accessories}
            actions={
              <ActionPanel>
                {!pending && !scanning && (
                  <Action
                    title={network.connected ? "Disconnect" : "Connect"}
                    icon={network.connected ? Icon.XMarkCircle : Icon.Plug}
                    onAction={() => void toggle(network)}
                  />
                )}
                {scanAction}
              </ActionPanel>
            }
          />
        );
      })}
    </List>
  );
}
