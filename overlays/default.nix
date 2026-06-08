{
  config,
  inputs,
  pkgs,
  ...
}:
{

  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./ansible_2_17.nix) # NOTE: reached EOL
    (import ./cato-client.nix) # NOTE: bump to `5.6.0.4138`
    (import ./curl-ws.nix) # NOTE: enables ws/wss support
    (import ./firefoxpwa.nix) # NOTE: pin 2.18.0, 2.18.2 build bug
    (import ./kitty.nix) # NOTE: fixes kitty-open being used as a terminal app
    (import ./networkmanager-openconnect.nix) # NOTE: GP HIP/usergroup wrapper for nmcli native flow
    (import ./spotify-player.nix) # NOTE: required for wayland-pipewire-idle-inhibit
    (import ./vcv-rack.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/393113
    (import ./xow_dongle-firmware.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/471331
  ];

}
