{ inputs, ... }: {

  nixpkgs = {
    overlays = [
      inputs.hyprpanel.overlay
      (import ./unstable.nix { inherit inputs; })
      (import ./terraformer.nix)
      (import ./neovim-unwrapped.nix)
      (import ./manix.nix)

      # (import ../overlays/xone.nix { inherit pkgs; })

      # (self: super: {
      #   hyprlauncher = import ../pkgs/hyprlauncher.nix {
      #     inherit (super)
      #       lib fetchFromGitHub rustPlatform pkg-config glib pango gtk4
      #       wrapGAppsHook4;
      #   };
      # })

      # (self: super: {
      #   hyprlauncher = import ../pkgs/monokle.nix {
      #     inherit (super)
      #       lib buildNpmPackage fetchFromGitHub electron nix-update-script
      #       makeBinaryWrapper;
      #   };
      # })

    ];
  };

}
