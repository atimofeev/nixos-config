{ inputs, ... }:
final: _prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (final.stdenv.hostPlatform) system;
    inherit (final) config;
    overlays = [
      (import ./nvidia-objtool-fix.nix)
    ];
  };
}
