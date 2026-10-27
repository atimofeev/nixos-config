import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);
const nmcli = "@nmcli@";

export type Network = {
  id: string;
  ssid: string;
  bssid: string;
  device: string;
  signal: number;
  security: string;
  connected: boolean;
};
export type Run = (args: string[], waitSeconds: number) => Promise<string>;

const runNmcli: Run = async (args, waitSeconds) => {
  try {
    const { stdout } = await execFileAsync(
      nmcli,
      ["--colors", "no", "--wait", String(waitSeconds), ...args],
      {
        env: { ...process.env, LC_ALL: "C" },
        timeout: (waitSeconds + 10) * 1000,
        maxBuffer: 1024 * 1024,
      },
    );
    return stdout;
  } catch (error) {
    const failure = error as Error & { stderr?: string; killed?: boolean };
    throw new Error(
      failure.killed
        ? "Wi-Fi operation timed out. Refresh to check the current connection."
        : failure.stderr?.trim() || failure.message,
    );
  }
};

// Terse nmcli output escapes colons (including those in MAC addresses) and backslashes.
export function splitFields(line: string): string[] {
  const fields = [""];
  let escaped = false;
  for (const character of line) {
    if (escaped) {
      fields[fields.length - 1] += character;
      escaped = false;
    } else if (character === "\\") {
      escaped = true;
    } else if (character === ":") {
      fields.push("");
    } else {
      fields[fields.length - 1] += character;
    }
  }
  if (escaped) fields[fields.length - 1] += "\\";
  return fields;
}

export function parseNetworks(output: string): Network[] {
  const networks = new Map<string, Network>();
  for (const line of output.split("\n").filter(Boolean)) {
    const fields = splitFields(line);
    const [inUse, ssid, bssid, strength, authentication, device] = fields;
    const signal = Number(strength);
    if (
      fields.length !== 6 || !device || !/^([\da-f]{2}:){5}[\da-f]{2}$/i.test(bssid) ||
      !/^\d+$/.test(strength) || signal < 0 || signal > 100
    ) {
      throw new Error("Unexpected NetworkManager Wi-Fi output.");
    }
    if (!ssid) continue;
    const security = authentication === "--" ? "" : authentication;
    const id = JSON.stringify([device, ssid, security]);
    const network = { id, ssid, bssid, device, signal, security, connected: inUse === "*" };
    const previous = networks.get(id);
    // Keep the connected access point, otherwise the strongest, for each network/adapter/security.
    if (!previous || (network.connected && !previous.connected) ||
      (network.connected === previous.connected && network.signal > previous.signal)) {
      networks.set(id, network);
    }
  }
  return [...networks.values()].sort((a, b) => Number(b.connected) - Number(a.connected) ||
    b.signal - a.signal || a.ssid.localeCompare(b.ssid));
}

export function parseDeviceState(output: string): number {
  const match = output.trim().match(/^(\d+)(?:\s|$)/);
  if (!match) throw new Error("Unexpected NetworkManager device state.");
  return Number(match[1]);
}

export function createWiFi(run: Run = runNmcli) {
  const list = async (rescan = false) => parseNetworks(await run([
    "--terse", "--escape", "yes", "--fields", "IN-USE,SSID,BSSID,SIGNAL,SECURITY,DEVICE",
    "device", "wifi", "list", "--rescan", rescan ? "yes" : "no",
  ], rescan ? 30 : 10));

  const toggle = async (id: string) => {
    const network = (await list()).find((network) => network.id === id);
    if (!network) throw new Error("Network is no longer visible. Rescan and try again.");
    const state = parseDeviceState(await run([
      "--get-values", "GENERAL.STATE", "device", "show", network.device,
    ], 10));
    if ((state >= 40 && state <= 90) || state === 110) {
      throw new Error("Wi-Fi adapter is already changing state. Try again shortly.");
    }
    if (state < 30) throw new Error("Wi-Fi adapter is off or unavailable. Enable Wi-Fi in system settings first.");
    if (network.connected) {
      await run(["device", "disconnect", network.device], 30);
    } else {
      await run(["device", "wifi", "connect", network.bssid, "ifname", network.device], 120);
    }
    return !network.connected;
  };

  return { list, toggle };
}
