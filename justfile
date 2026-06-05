# Default Nix flags
unfree_env := "NIXPKGS_ALLOW_UNFREE=1"

# show available recipes
default:
    @just --list --unsorted

# Run nixos-rebuild. Actions: switch, boot, test, dry-build, dry-activate, build
[positional-arguments]
rebuild action host *extra='':
    sudo env {{unfree_env}} nixos-rebuild {{action}} --flake .#{{host}} {{extra}}
