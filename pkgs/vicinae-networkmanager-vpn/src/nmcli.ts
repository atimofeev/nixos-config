import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);
const nmcli = "@nmcli@";

export type Profile = {
  uuid: string;
  name: string;
  type: string;
  state: string;
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
        ? "NetworkManager operation timed out. Refresh to check its current state."
        : failure.stderr?.trim() || failure.message,
    );
  }
};

// nmcli escapes colons and backslashes even in terse output.
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

export function parseProfiles(output: string): Profile[] {
  return output
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [uuid, name, type, state] = splitFields(line);
      if (!uuid || !name || !type || state === undefined) {
        throw new Error("Unexpected NetworkManager connection output.");
      }
      return { uuid, name, type, state };
    })
    .filter(({ type }) => type === "vpn" || type === "wireguard")
    .sort((a, b) => Number(isActive(b)) - Number(isActive(a)) || a.name.localeCompare(b.name));
}

export function isActive(profile: Profile): boolean {
  return profile.state === "activated";
}

export function isTransitioning(profile: Profile): boolean {
  return profile.state === "activating" || profile.state === "deactivating";
}

export function createNetworkManager(run: Run = runNmcli) {
  const list = async () => parseProfiles(await run([
    "--terse", "--escape", "yes", "--fields", "UUID,NAME,TYPE,STATE", "connection", "show",
  ], 10));

  const toggle = async (uuid: string) => {
    // Re-read before toggling: another client may have changed this connection.
    const profile = (await list()).find((profile) => profile.uuid === uuid);
    if (!profile) throw new Error("VPN profile no longer exists.");
    if (isTransitioning(profile)) throw new Error("VPN is already changing state. Try again shortly.");
    const active = isActive(profile);
    await run(["connection", active ? "down" : "up", "uuid", uuid], active ? 30 : 300);
    return !active;
  };

  return { list, toggle };
}
