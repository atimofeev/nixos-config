{ inputs, ... }: {

  nixpkgs.overlays = [
    (import ./neovim-unwrapped.nix)
    (import ./terraformer.nix)
    (import ./unstable.nix { inherit inputs; })

    # NOTE: remove during upgrade to 25.05(?)
    (import ./xone.nix)
    (import ./xow_dongle-pr-400938.nix)

  ];

}
