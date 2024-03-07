{ pkgs, ... }: {
  # TODO: https://github.com/catppuccin/spotify-player
  home.packages = with pkgs; [ spotify-player ];

  # FIX: bump spotify-player version
  # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
  # nixpkgs.config = {
  #   packageOverrides = pkgs: {
  #     spotify-player = pkgs.spotify-player.overrideAttrs (oldAttrs: {
  #       version = "0.17.0";
  #       cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "aome510";
  #         repo = "spotify-player";
  #         rev = "v0.17.0";
  #         sha256 = "sha256-fGDIlkTaRg+J6YcP9iBcJFuYm9F0UOA+v/26hhdg9/o=";
  #       };
  #     });
  #   };
  # };
}
