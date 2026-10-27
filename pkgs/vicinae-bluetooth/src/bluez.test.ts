import assert from "node:assert/strict";
import { test } from "node:test";
import { createBlueZ, parseSnapshot, type Run } from "./bluez";

const adapterPath = "/org/bluez/hci0";
const devicePath = `${adapterPath}/dev_00_11_22_33_44_55`;
const variant = (type: string, data: unknown) => ({ type, data });

function deviceProperties(overrides: Record<string, unknown> = {}) {
  return {
    Adapter: variant("o", adapterPath),
    Address: variant("s", "00:11:22:33:44:55"),
    Alias: variant("s", "Headphones"),
    Name: variant("s", "Original name"),
    Icon: variant("s", "audio-headset"),
    Paired: variant("b", true),
    Connected: variant("b", false),
    Blocked: variant("b", false),
    ...overrides,
  };
}

function reply(objects: Record<string, unknown>) {
  return JSON.stringify({ type: "a{oa{sa{sv}}}", data: [objects] });
}

function snapshot(overrides: Record<string, unknown> = {}, powered = true) {
  return reply({
    [adapterPath]: { "org.bluez.Adapter1": { Alias: variant("s", "Adapter"), Powered: variant("b", powered) } },
    [devicePath]: { "org.bluez.Device1": deviceProperties(overrides) },
  });
}

function fakeBlueZ(output: string, failOperation = false) {
  const calls: { args: string[]; timeout: number }[] = [];
  const run: Run = async (args, timeout) => {
    calls.push({ args, timeout });
    if (args.includes("GetManagedObjects")) return output;
    if (failOperation) throw new Error("Call failed: org.bluez.Error.NotReady");
    return "";
  };
  return { ...createBlueZ(run), calls };
}

test("reads typed BlueZ properties and uses alias as display name", () => {
  const result = parseSnapshot(snapshot());
  assert.deepEqual(result.adapters, [{ path: adapterPath, name: "Adapter", powered: true }]);
  assert.equal(result.devices[0].name, "Headphones");
  assert.equal(result.devices[0].address, "00:11:22:33:44:55");
  assert.equal(result.devices[0].connected, false);
});

test("omits unpaired discovered devices", () => {
  assert.deepEqual(parseSnapshot(snapshot({ Paired: variant("b", false) })).devices, []);
});

test("sorts connected devices first, then by name", () => {
  const result = parseSnapshot(reply({
    one: { "org.bluez.Device1": deviceProperties({ Alias: variant("s", "Zulu") }) },
    two: { "org.bluez.Device1": deviceProperties({ Alias: variant("s", "Alpha") }) },
    three: { "org.bluez.Device1": deviceProperties({ Alias: variant("s", "Connected"), Connected: variant("b", true) }) },
  }));
  assert.deepEqual(result.devices.map(({ name }) => name), ["Connected", "Alpha", "Zulu"]);
});

test("retains device paths so identical addresses on different adapters stay distinct", () => {
  const result = parseSnapshot(reply({
    [devicePath]: { "org.bluez.Device1": deviceProperties() },
    "/org/bluez/hci1/dev_00_11_22_33_44_55": { "org.bluez.Device1": deviceProperties({ Adapter: variant("o", "/org/bluez/hci1") }) },
  }));
  assert.equal(new Set(result.devices.map(({ path }) => path)).size, 2);
});

test("missing Alias and Name fall back to address", () => {
  assert.equal(parseSnapshot(snapshot({ Alias: undefined, Name: undefined })).devices[0].name, "00:11:22:33:44:55");
});

test("battery is optional, including valid zero percent", () => {
  assert.equal(parseSnapshot(snapshot()).devices[0].battery, undefined);
  for (const battery of [0, 78, 100]) {
    const result = parseSnapshot(reply({
      [devicePath]: { "org.bluez.Device1": deviceProperties(), "org.bluez.Battery1": { Percentage: variant("y", battery) } },
    }));
    assert.equal(result.devices[0].battery, battery);
  }
});

test("ignores invalid battery values", () => {
  for (const battery of [-1, 101, "80", 1.5]) {
    assert.equal(parseSnapshot(reply({
      [devicePath]: { "org.bluez.Device1": deviceProperties(), "org.bluez.Battery1": { Percentage: variant("y", battery) } },
    })).devices[0].battery, undefined);
  }
});

test("empty BlueZ object tree means no adapters or devices", () => {
  assert.deepEqual(parseSnapshot(reply({})), { adapters: [], devices: [] });
});

test("rejects malformed D-Bus reply", () => {
  for (const output of ["{}", "null", JSON.stringify({ type: "wrong", data: [{}] }), JSON.stringify({ type: "a{oa{sa{sv}}}", data: [[]] })]) {
    assert.throws(() => parseSnapshot(output), /Unexpected BlueZ/);
  }
});

test("list uses one GetManagedObjects call", async () => {
  const bluez = fakeBlueZ(snapshot());
  await bluez.list();
  assert.deepEqual(bluez.calls, [{ args: ["call", "org.bluez", "/", "org.freedesktop.DBus.ObjectManager", "GetManagedObjects"], timeout: 10 }]);
});

test("connect invokes Device1.Connect using object path, not device name", async () => {
  const bluez = fakeBlueZ(snapshot({ Alias: variant("s", "Name ; $(touch nope)") }));
  assert.equal(await bluez.toggle(devicePath), true);
  assert.deepEqual(bluez.calls[1], { args: ["call", "org.bluez", devicePath, "org.bluez.Device1", "Connect"], timeout: 60 });
});

test("fresh connected state selects Disconnect", async () => {
  const bluez = fakeBlueZ(snapshot({ Connected: variant("b", true) }));
  assert.equal(await bluez.toggle(devicePath), false);
  assert.deepEqual(bluez.calls[1].args, ["call", "org.bluez", devicePath, "org.bluez.Device1", "Disconnect"]);
});

test("removed or unpaired device never triggers a mutation", async () => {
  for (const output of [reply({}), snapshot({ Paired: variant("b", false) })]) {
    const bluez = fakeBlueZ(output);
    await assert.rejects(bluez.toggle(devicePath), /no longer exists/);
    assert.equal(bluez.calls.length, 1);
  }
});

test("blocked device is not silently unblocked or connected", async () => {
  const bluez = fakeBlueZ(snapshot({ Blocked: variant("b", true) }));
  await assert.rejects(bluez.toggle(devicePath), /Device is blocked/);
  assert.equal(bluez.calls.length, 1);
});

test("powered-off adapter is not silently enabled", async () => {
  const bluez = fakeBlueZ(snapshot({}, false));
  await assert.rejects(bluez.toggle(devicePath), /adapter is off or unavailable/);
  assert.equal(bluez.calls.length, 1);
});

test("connection errors reach caller", async () => {
  const bluez = fakeBlueZ(snapshot(), true);
  await assert.rejects(bluez.toggle(devicePath), /org.bluez.Error.NotReady/);
});
