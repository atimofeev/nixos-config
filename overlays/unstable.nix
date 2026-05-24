{ inputs, ... }:
final: _prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (final.stdenv.hostPlatform) system;
    config.allowUnfree = true;
    overlays = [
      (import ./niri.nix { inherit inputs; })
    ];
  };
}
