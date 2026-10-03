# Default Nix flags
unfree_env := "NIXPKGS_ALLOW_UNFREE=1"

[private]
default:
    @just --list --unsorted

# Format & partition disks
[positional-arguments]
disko-init host:
    sudo nix run github:nix-community/disko -- --mode disko hosts/{{host}}/disko-config.nix

# Run nixos-rebuild. Actions: switch, boot, test, dry-build, dry-activate, build
[positional-arguments]
rebuild action host *extra='':
    sudo env {{unfree_env}} nixos-rebuild {{action}} --flake .#{{host}} {{extra}}

# Enroll Secure Boot keys, including Microsoft certificates
secure-boot-keys-enroll:
    sudo sbctl enroll-keys --microsoft

luks-list-devices:
    sudo systemd-cryptenroll --list-devices

# Enroll TPM2 unlock for a LUKS2 device
[positional-arguments]
luks-tpm-unlock-enroll device:
    sudo systemd-cryptenroll --tpm2-device=auto {{device}}
