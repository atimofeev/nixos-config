{
  inputs,
  ...
}:
{

  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./vcv-rack.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/393113
    (import ./xow_dongle-firmware.nix) # BUG: https://github.com/NixOS/nixpkgs/issues/471331
  ];

}
