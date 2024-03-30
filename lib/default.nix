{ pkgs, ... }:
builtins.mapAttrs (_name: path: import path { inherit pkgs; }) {
  formats = ./formats.nix;
}
