# Wi-Fi Picker for Vicinae

Search nearby Wi-Fi networks and press Enter to connect/disconnect. Connected
networks appear first, then strongest signal. Shows security, signal percentage,
and interface name. Multiple access points for the same network are grouped per
interface and security type; the connected or strongest access point is used.

Cached network results refresh every three seconds without triggering scans.
Use **Rescan Networks** (the Refresh shortcut) to request a fresh scan.
Wi-Fi must already be enabled; the picker never enables radios automatically.
Hidden networks are omitted while their SSID is unknown.

Uses a Nix-pinned `nmcli` with argument arrays, not shell commands. NetworkManager
reuses matching profiles or creates one when supported. Existing secret agents
(such as Dux Shell or nm-applet) handle missing credentials. The extension does
not prompt for, handle, or store passwords. New enterprise/unsupported-security
networks require a profile configured in system settings first. Normal
NetworkManager and polkit permissions apply; no sudo or extra grants are used.

Switching networks or disconnecting can interrupt internet access and VPNs.
Disconnect affects only the selected Wi-Fi interface and inhibits its automatic
reconnection until manually reconnected; it does not turn off the radio.

Build from the repository root:

```sh
nix build .#nixosConfigurations.milaptop.pkgs.vicinae-wifi
```

The Vicinae Home Manager module installs this package through
`programs.vicinae.extensions`. Apply the host configuration, then search for
**Wi-Fi Picker**, or open directly:

```sh
vicinae 'vicinae://launch/@atimofeev/wifi-picker/wifi'
```

No npm dependencies are downloaded during the package build. Package checks use
mocked nmcli output and validate the command bundle syntax; they never scan or
change live Wi-Fi connections.
