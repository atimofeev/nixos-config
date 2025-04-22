{ inputs, ... }: {

  nixpkgs.overlays = [
    (import ./neovim-unwrapped.nix)
    (import ./terraformer.nix)
    (import ./unstable.nix { inherit inputs; })
    (import ./xone.nix)
    (import ./xow_dongle-firmware-045e_02e6.nix)
  ];

}
