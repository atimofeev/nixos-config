# NetworkManager VPN for Vicinae

List and toggle existing NetworkManager VPN and WireGuard profiles. Active
connections appear first. Press Enter to connect/disconnect; use the Refresh
action or wait up to three seconds for changes from other clients.

Authentication stays with NetworkManager and the existing session secret agent
(for example Dux Shell or nm-applet). This extension neither prompts for nor
stores credentials. A running agent is required when credentials are not saved;
GlobalProtect browser login requires an agent that supports its plugin.
An existing polkit agent/permission is also required when NetworkManager requests
authorization. No sudo or additional policy grants are used.

Build from the repository root:

```sh
nix build .#nixosConfigurations.milaptop.pkgs.vicinae-networkmanager-vpn
```

The Vicinae Home Manager module installs this package through
`programs.vicinae.extensions`. Apply the host configuration to make the command
available; building alone does not install it.

The package uses esbuild with Vicinae's standard external runtime modules
(React and `@vicinae/api`), so no npm dependency download is needed.
`nmcli` is pinned to the Nix package path. Package checks run mocked backend tests
and check the command bundle syntax; they never change live VPN connections.
