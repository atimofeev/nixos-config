{ pkgs, config, vars, ... }: {
  environment.systemPackages = with pkgs; [
    # virt
    playonlinux

    # tools
    mangohud # mangohud %command%

    # games
    space-cadet-pinball
  ];

  programs = {
    gamemode = {
      enable = true; # gamemoderun %command% (?)
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true; # gamescope %command% (?)
    };
  };

  hardware.xone.enable = true;

  # TODO: overlays have no effect; pkgOverride fails with random error
  # kernel patch can't find destination file to apply itself
  # https://github.com/medusalix/xone/pull/35
  # https://nixos.wiki/wiki/Linux_kernel#Overriding_kernel_packages
  # https://search.nixos.org/options?channel=23.11&show=boot.kernelPatches&from=0&size=50&sort=relevance&type=packages&query=boot.kernelPatches
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     xone = prev.xone.overrideAttrs (oldAttrs: {
  #       src = pkgs.fetchFromGitHub {
  #         owner = "medusalix";
  #         repo = "xone";
  #         rev = "pull/35/head";
  #         sha256 = "";
  #       };
  #     });
  #   })
  # ];
  # nixpkgs.overlays = [
  #   (self: super: {
  #     linuxPackages = super.linuxPackages.extend (lpself: lpsuper: {
  #       xone = super.linuxPackages.xone.overrideAttrs (oldAttrs: {
  #         # xone = super.linuxPackages.xone.overrideDerivation (oldAttrs: {
  #         version = "0.0.0";
  #         src = pkgs.fetchFromGitHub {
  #           owner = "medusalix";
  #           repo = "xone";
  #           rev = "pull/35/head";
  #           sha256 = "";
  #         };
  #       });
  #     });
  #   })
  # ];
  # nixpkgs.config.packageOverrides = pkgs: rec {
  #   linuxPackages.xone = pkgs.linuxPackages.xone.overrideDerivation (attrs: {
  #     src = pkgs.fetchFromGitHub {
  #       owner = "medusalix";
  #       repo = "xone";
  #       rev = "pull/35/head";
  #       sha256 = "";
  #     };
  #   });
  # };
  # boot.kernelPatches = [rec {
  #   name = "xone";
  #   patch = pkgs.fetchpatch {
  #     name = name + ".patch";
  #     url =
  #       "https://github.com/medusalix/xone/commit/954fc823fbaa429ad6e1c1a06a4a006598ef35ae.patch";
  #     sha256 = "sha256-CS4vCSFciFJ8kH0YzNMvBwABR2wKBSzw5QIbPbAqHUs=";
  #   };
  # }];
}
