{
  inputs,
  ...
}:
{

  nixpkgs.overlays = [
    (import ./unstable.nix { inherit inputs; })
    (import ./vcv-rack.nix) # NOTE: https://github.com/NixOS/nixpkgs/issues/393113
  ];

}
