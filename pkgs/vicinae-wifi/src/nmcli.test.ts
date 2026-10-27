import assert from "node:assert/strict";
import { test } from "node:test";
import { createWiFi, parseDeviceState, parseNetworks, splitFields, type Run } from "./nmcli";

const bssid = "00:11:22:33:44:55";
const secondBssid = "00:11:22:33:44:66";
const escape = (value: string) => value.replace(/\\/g, "\\\\").replace(/:/g, "\\:");
function row(options: {
  ssid?: string; bssid?: string; device?: string; security?: string; signal?: number; connected?: boolean;
} = {}) {
  return [options.connected ? "*" : "", options.ssid ?? "Test network", options.bssid ?? bssid,
    String(options.signal ?? 75), options.security ?? "WPA2", options.device ?? "wlan0"]
    .map(escape).join(":");
}

function fakeWiFi(output = row(), state = "30 (disconnected)", failOperation = false) {
  const calls: { args: string[]; wait: number }[] = [];
  const run: Run = async (args, wait) => {
    calls.push({ args, wait });
    if (args.includes("list")) return output;
    if (args.includes("GENERAL.STATE")) return state;
    if (failOperation) throw new Error("No agents were available for this request.");
    return "";
  };
  return { ...createWiFi(run), calls };
}

const id = (options = {}) => parseNetworks(row(options))[0].id;

test("terse parser preserves escaped BSSIDs, SSID colons, backslashes and spaces", () => {
  const [network] = parseNetworks(row({ ssid: "  Lab: west\\wifi " }));
  assert.equal(network.ssid, "  Lab: west\\wifi ");
  assert.equal(network.bssid, bssid);
  assert.deepEqual(splitFields(String.raw`one\:two:three\\four:`), ["one:two", "three\\four", ""]);
});

test("keeps connected access point instead of stronger duplicate", () => {
  const [network] = parseNetworks([
    row({ signal: 90 }), row({ bssid: secondBssid, signal: 40, connected: true }),
  ].join("\n"));
  assert.equal(network.bssid, secondBssid);
  assert.equal(network.connected, true);
});

test("groups duplicate SSIDs using strongest AP when disconnected", () => {
  const networks = parseNetworks([row({ signal: 40 }), row({ bssid: secondBssid, signal: 90 })].join("\n"));
  assert.equal(networks.length, 1);
  assert.equal(networks[0].bssid, secondBssid);
});

test("identity stays stable when an access point changes", () => {
  assert.equal(id(), id({ bssid: secondBssid }));
});

test("different security and adapters never collapse into one network", () => {
  const networks = parseNetworks([row(), row({ security: "--" }), row({ device: "wlan1" })].join("\n"));
  assert.equal(new Set(networks.map(({ id }) => id)).size, 3);
});

test("sorts connected first, then strongest signal", () => {
  const networks = parseNetworks([
    row({ ssid: "Weak", signal: 10 }), row({ ssid: "Strong", signal: 90 }),
    row({ ssid: "Connected", signal: 30, connected: true }),
  ].join("\n"));
  assert.deepEqual(networks.map(({ ssid }) => ssid), ["Connected", "Strong", "Weak"]);
});

test("hidden SSIDs omitted without dropping a literal -- network name", () => {
  const networks = parseNetworks([row({ ssid: "" }), row({ ssid: "--" })].join("\n"));
  assert.deepEqual(networks.map(({ ssid }) => ssid), ["--"]);
});

test("normalizes open security and permits zero signal", () => {
  const [network] = parseNetworks(row({ security: "--", signal: 0 }));
  assert.equal(network.security, "");
  assert.equal(network.signal, 0);
});

test("empty output yields no networks", () => assert.deepEqual(parseNetworks(""), []));

test("rejects missing fields, invalid BSSID and out-of-range signal", () => {
  for (const output of ["bad", row({ bssid: "not-a-mac" }), row({ signal: 101 }), row({ signal: -1 })]) {
    assert.throws(() => parseNetworks(output), /Unexpected NetworkManager Wi-Fi/);
  }
});

test("parses numeric device state and rejects non-numeric output", () => {
  assert.equal(parseDeviceState("100 (connected)\n"), 100);
  assert.equal(parseDeviceState("30"), 30);
  assert.throws(() => parseDeviceState("connected"), /Unexpected NetworkManager device state/);
});

test("polling only reads cached scan results", async () => {
  const wifi = fakeWiFi();
  await wifi.list();
  assert.deepEqual(wifi.calls, [{ args: ["--terse", "--escape", "yes", "--fields",
    "IN-USE,SSID,BSSID,SIGNAL,SECURITY,DEVICE", "device", "wifi", "list", "--rescan", "no"], wait: 10 }]);
});

test("explicit rescan requests fresh results", async () => {
  const wifi = fakeWiFi();
  await wifi.list(true);
  assert.deepEqual(wifi.calls[0].args.slice(-2), ["--rescan", "yes"]);
  assert.equal(wifi.calls[0].wait, 30);
});

test("connect uses BSSID and interface, never SSID shell interpolation or password arguments", async () => {
  const options = { ssid: "Name ; $(touch nope)" };
  const wifi = fakeWiFi(row(options));
  assert.equal(await wifi.toggle(id(options)), true);
  assert.deepEqual(wifi.calls[2], { args: ["device", "wifi", "connect", bssid, "ifname", "wlan0"], wait: 120 });
});

test("fresh state selects disconnect only on the selected network interface", async () => {
  const options = { connected: true, device: "wlan1" };
  const wifi = fakeWiFi(row(options), "100 (connected)");
  assert.equal(await wifi.toggle(id(options)), false);
  assert.deepEqual(wifi.calls[2], { args: ["device", "disconnect", "wlan1"], wait: 30 });
});

test("roaming network connects through the freshly selected AP", async () => {
  const wifi = fakeWiFi(row({ bssid: secondBssid }));
  await wifi.toggle(id());
  assert.equal(wifi.calls[2].args[3], secondBssid);
});

test("disappeared networks never trigger connection changes", async () => {
  const wifi = fakeWiFi("");
  await assert.rejects(wifi.toggle(id()), /no longer visible/);
  assert.equal(wifi.calls.length, 1);
});

test("external activation, authentication and disconnect transitions are not interrupted", async () => {
  for (const state of [40, 50, 60, 70, 80, 90, 110]) {
    const wifi = fakeWiFi(row(), `${state} (transitioning)`);
    await assert.rejects(wifi.toggle(id()), /already changing state/);
    assert.equal(wifi.calls.length, 2);
  }
});

test("disabled or unavailable adapter is never automatically enabled", async () => {
  for (const state of [0, 10, 20]) {
    const wifi = fakeWiFi(row(), `${state} (unavailable)`);
    await assert.rejects(wifi.toggle(id()), /off or unavailable/);
    assert.equal(wifi.calls.length, 2);
  }
});

test("authentication failures propagate without storing passwords", async () => {
  const wifi = fakeWiFi(row(), "30 (disconnected)", true);
  await assert.rejects(wifi.toggle(id()), /No agents were available/);
});
