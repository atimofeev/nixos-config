import { Action, ActionPanel, Color, Icon, Keyboard, List, Toast, showToast } from "@vicinae/api";
import { useCallback, useEffect, useRef, useState } from "react";
import { createNetworkManager, isActive, isTransitioning, type Profile } from "./nmcli";

const networkManager = createNetworkManager();

export default function VPNConnections() {
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);
  const [pending, setPending] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const mounted = useRef(false);
  const refreshing = useRef(false);
  const toggling = useRef(false);

  const refresh = useCallback(async () => {
    if (refreshing.current) return;
    refreshing.current = true;
    try {
      const next = await networkManager.list();
      if (mounted.current) {
        setProfiles(next);
        setError(null);
      }
    } catch (error) {
      if (mounted.current) {
        setProfiles([]);
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

  async function toggle(profile: Profile) {
    if (toggling.current || isTransitioning(profile)) return;
    toggling.current = true;
    setPending(profile.uuid);
    try {
      const toast = await showToast({
        style: Toast.Style.Animated,
        title: isActive(profile) ? "Disconnecting VPN..." : "Connecting VPN...",
        message: profile.name,
      });
      try {
        const connected = await networkManager.toggle(profile.uuid);
        toast.style = Toast.Style.Success;
        toast.title = connected ? "VPN connected" : "VPN disconnected";
      } catch (error) {
        toast.style = Toast.Style.Failure;
        toast.title = "VPN operation failed";
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
      searchBarPlaceholder="Search VPN connections..."
      actions={<ActionPanel>{refreshAction}</ActionPanel>}
    >
      <List.EmptyView
        icon={error ? Icon.Warning : Icon.Network}
        title={error ? "Cannot load VPN connections" : loading ? "Loading VPN connections..." : "No VPN connections"}
        description={error ?? "Create a VPN profile in NetworkManager first. Existing authentication agents handle login prompts."}
      />
      {profiles.map((profile) => {
        const active = isActive(profile);
        const busy = pending === profile.uuid || isTransitioning(profile);
        const status = busy
          ? profile.state === "deactivating" || (pending === profile.uuid && active) ? "Disconnecting..." : "Connecting..."
          : active ? "Connected" : "Disconnected";
        return (
          <List.Item
            key={profile.uuid}
            id={profile.uuid}
            title={profile.name}
            subtitle={profile.type === "wireguard" ? "WireGuard" : undefined}
            icon={{ source: Icon.Shield01, tintColor: active ? Color.Green : Color.SecondaryText }}
            accessories={[{ text: status }]}
            actions={
              <ActionPanel>
                {!pending && !isTransitioning(profile) && (
                  <Action
                    title={active ? "Disconnect" : "Connect"}
                    icon={active ? Icon.XMarkCircle : Icon.Plug}
                    onAction={() => void toggle(profile)}
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
