import assert from "node:assert/strict";
import { test } from "node:test";
import { createNetworkManager, isTransitioning, parseProfiles, splitFields, type Run } from "./nmcli";

const uuid = "fb9de162-a755-4279-858e-78ec73549801";

function fakeNetworkManager(output: string, failActivation = false) {
  const calls: { args: string[]; wait: number }[] = [];
  const run: Run = async (args, wait) => {
    calls.push({ args, wait });
    if (args.includes("show")) return output;
    if (failActivation) throw new Error("No agents were available for this request.");
    return "";
  };
  return { ...createNetworkManager(run), calls };
}

test("terse fields preserve escaped colons, backslashes, spaces and empty state", () => {
  assert.deepEqual(splitFields(String.raw`id:Work\: EU\\VPN:vpn:`), ["id", "Work: EU\\VPN", "vpn", ""]);
});

test("VPN and WireGuard profiles only, active first then alphabetical", () => {
  const profiles = parseProfiles([
    "wifi:Home:802-11-wireless:activated",
    "z:Zulu:vpn:",
    "a:Alpha:wireguard:",
    "c:Connected:vpn:activated",
    "tun:External:tun:activated",
    "",
  ].join("\n"));
  assert.deepEqual(profiles.map(({ uuid }) => uuid), ["c", "a", "z"]);
});

test("empty output yields no profiles", () => {
  assert.deepEqual(parseProfiles(""), []);
});

test("malformed output fails rather than constructing an unsafe action", () => {
  assert.throws(() => parseProfiles("uuid:Missing fields"), /Unexpected NetworkManager/);
});

test("list requests machine-readable escaped fields", async () => {
  const manager = fakeNetworkManager(`${uuid}:Work:vpn:\n`);
  await manager.list();
  assert.deepEqual(manager.calls, [{
    args: ["--terse", "--escape", "yes", "--fields", "UUID,NAME,TYPE,STATE", "connection", "show"],
    wait: 10,
  }]);
});

test("connect uses UUID arguments, never shell interpolation or --ask", async () => {
  const manager = fakeNetworkManager(`${uuid}:Work ; $(touch nope):vpn:\n`);
  assert.equal(await manager.toggle(uuid), true);
  assert.deepEqual(manager.calls[1], {
    args: ["connection", "up", "uuid", uuid],
    wait: 300,
  });
});

test("fresh state determines disconnect, not stale caller state", async () => {
  const manager = fakeNetworkManager(`${uuid}:Work:vpn:activated\n`);
  assert.equal(await manager.toggle(uuid), false);
  assert.deepEqual(manager.calls[1], {
    args: ["connection", "down", "uuid", uuid],
    wait: 30,
  });
});

test("WireGuard uses same activation path", async () => {
  const manager = fakeNetworkManager(`${uuid}:Tunnel:wireguard:\n`);
  assert.equal(await manager.toggle(uuid), true);
  assert.deepEqual(manager.calls[1].args, ["connection", "up", "uuid", uuid]);
});

test("missing profiles never trigger activation", async () => {
  const manager = fakeNetworkManager("");
  await assert.rejects(manager.toggle(uuid), /no longer exists/);
  assert.equal(manager.calls.length, 1);
});

for (const state of ["activating", "deactivating"]) {
  test(`prevents duplicate actions while ${state}`, async () => {
    const manager = fakeNetworkManager(`${uuid}:Work:vpn:${state}\n`);
    assert.equal(isTransitioning((await manager.list())[0]), true);
    await assert.rejects(manager.toggle(uuid), /already changing state/);
    assert.equal(manager.calls.filter(({ args }) => !args.includes("show")).length, 0);
  });
}

test("authentication errors propagate without changing stored credentials", async () => {
  const manager = fakeNetworkManager(`${uuid}:Work:vpn:\n`, true);
  await assert.rejects(manager.toggle(uuid), /No agents were available/);
  assert.equal(manager.calls.length, 2);
});
