{ inputs, ... }:
{

  nixpkgs.overlays = [
    (import ./neovim-unwrapped.nix)
    (import ./rofi-wayland.nix)
    (import ./terraformer.nix)
    (import ./unstable.nix { inherit inputs; })

    # NOTE: remove after merged
    # https://github.com/NixOS/nixpkgs/pull/400938
    (import ./xone.nix)
    (import ./xow_dongle-pr-400938.nix)

  ];

}
