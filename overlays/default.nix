{ inputs, ... }: {

  nixpkgs = {
    overlays = [
      (import ./neovim-unwrapped.nix)
      (import ./terraformer.nix)
      (import ./unstable.nix { inherit inputs; })
      (import ./xone.nix)
      (import ./xow_dongle-firmware.nix)
    ];
  };

}
