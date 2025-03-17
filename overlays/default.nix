{ inputs, ... }: {

  nixpkgs = {
    overlays = [
      (import ./unstable.nix { inherit inputs; })
      (import ./terraformer.nix)
      (import ./neovim-unwrapped.nix)

      # (import ../overlays/xone.nix { inherit pkgs; })

    ];
  };

}
