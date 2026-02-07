{ inputs, ... }:
{

  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./ansible_2_17.nix) # NOTE: reached EOL
    (import ./curl-ws.nix) # NOTE: enables ws/wss support
    (import ./spotify-player.nix) # NOTE: required for wayland-pipewire-idle-inhibit
    (import ./vcv-rack.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/393113
    (import ./xow_dongle-firmware.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/471331
  ];

}
