import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);
const busctl = "@busctl@";

export type Adapter = { path: string; name: string; powered: boolean };
export type Device = {
  path: string;
  adapter: string;
  address: string;
  name: string;
  icon: string;
  connected: boolean;
  blocked: boolean;
  battery?: number;
};
export type Snapshot = { adapters: Adapter[]; devices: Device[] };
export type Run = (args: string[], timeout: number) => Promise<string>;
type Properties = Record<string, { type: string; data: unknown }>;

const runBusctl: Run = async (args, timeout) => {
  try {
    const { stdout } = await execFileAsync(
      busctl,
      ["--system", "--json=short", `--timeout=${timeout}`, ...args],
      {
        env: { ...process.env, LC_ALL: "C" },
        timeout: (timeout + 5) * 1000,
        maxBuffer: 4 * 1024 * 1024,
      },
    );
    return stdout;
  } catch (error) {
    const failure = error as Error & { stderr?: string; killed?: boolean };
    throw new Error(
      failure.killed
        ? "Bluetooth operation timed out. Refresh to check the current connection."
        : failure.stderr?.trim() || failure.message,
    );
  }
};

function text(properties: Properties, key: string): string {
  const value = properties[key]?.data;
  return typeof value === "string" ? value : "";
}

export function parseSnapshot(output: string): Snapshot {
  const reply = JSON.parse(output);
  const objects = reply?.data?.[0];
  if (
    reply?.type !== "a{oa{sa{sv}}}" ||
    !objects || typeof objects !== "object" || Array.isArray(objects)
  ) {
    throw new Error("Unexpected BlueZ object response.");
  }

  const adapters: Adapter[] = [];
  const devices: Device[] = [];
  for (const [path, interfaces] of Object.entries(objects) as [string, Record<string, Properties>][]) {
    const adapter = interfaces["org.bluez.Adapter1"];
    if (adapter) {
      adapters.push({
        path,
        name: text(adapter, "Alias") || text(adapter, "Name") || path,
        powered: adapter.Powered?.data === true,
      });
    }
    const device = interfaces["org.bluez.Device1"];
    if (!device || device.Paired?.data !== true) continue;
    const battery = interfaces["org.bluez.Battery1"]?.Percentage?.data;
    devices.push({
      path,
      adapter: text(device, "Adapter"),
      address: text(device, "Address"),
      name: text(device, "Alias") || text(device, "Name") || text(device, "Address") || path,
      icon: text(device, "Icon"),
      connected: device.Connected?.data === true,
      blocked: device.Blocked?.data === true,
      battery: typeof battery === "number" && Number.isInteger(battery) && battery >= 0 && battery <= 100
        ? battery : undefined,
    });
  }
  devices.sort((a, b) => Number(b.connected) - Number(a.connected) || a.name.localeCompare(b.name));
  return { adapters, devices };
}

export function createBlueZ(run: Run = runBusctl) {
  const list = async () => parseSnapshot(await run([
    "call", "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", "GetManagedObjects",
  ], 10));

  const toggle = async (path: string) => {
    // Another Bluetooth client may have changed the connection since the last refresh.
    const snapshot = await list();
    const device = snapshot.devices.find((device) => device.path === path);
    if (!device) throw new Error("Paired device no longer exists.");
    if (!device.connected) {
      if (device.blocked) throw new Error("Device is blocked. Unblock it in Bluetooth settings first.");
      if (!snapshot.adapters.some((adapter) => adapter.path === device.adapter && adapter.powered)) {
        throw new Error("Bluetooth adapter is off or unavailable. Enable it in system settings first.");
      }
    }
    await run([
      "call", "org.bluez", device.path, "org.bluez.Device1", device.connected ? "Disconnect" : "Connect",
    ], 60);
    return !device.connected;
  };

  return { list, toggle };
}
