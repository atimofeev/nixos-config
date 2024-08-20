{ inputs, ... }:
final: _prev: {
  master = import inputs.nixpkgs-master {
    inherit (final) system;
    config.allowUnfree = true;
  };
}
