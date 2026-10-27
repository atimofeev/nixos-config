# Bluetooth Picker for Vicinae

Search paired Bluetooth devices and press Enter to connect/disconnect.
Connected devices appear first. Status refreshes every three seconds; the Refresh
action also reloads devices. Shows battery percentage when BlueZ exposes it,
plus the adapter name when multiple adapters exist.

Uses the system BlueZ D-Bus API through a Nix-pinned `busctl`. No npm dependencies
are downloaded during the package build. Existing system Bluetooth agents handle
authorization requests. This picker does not register an agent, scan, pair, trust,
unblock devices, or automatically enable adapters. Pair devices and enable the
adapter in system Bluetooth settings first. Normal BlueZ D-Bus permissions apply;
no sudo or extra policy grants are used.

Build from the repository root:

```sh
nix build .#nixosConfigurations.milaptop.pkgs.vicinae-bluetooth
```

The Vicinae Home Manager module installs the package through
`programs.vicinae.extensions`. Apply the host configuration, then search for
**Bluetooth Picker**, or open it directly:

```sh
vicinae 'vicinae://launch/@atimofeev/bluetooth-picker/bluetooth'
```

Package checks run mocked BlueZ tests and validate command bundle syntax.
They do not change live device connections or radio state.
