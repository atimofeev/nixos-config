{ pkgs, config, vars, ... }: {

  imports = [ ./bookmarks.nix ./widgets.nix ];

  sops.secrets."work/homepage-env" = {
    owner = vars.username;
    restartUnits = [ "homepage-dashboard.service" ];
  };

  services.homepage-dashboard = {
    enable = true;
    package = pkgs.unstable.homepage-dashboard;
    environmentFile = config.sops.secrets."work/homepage-env".path;
    listenPort = 8888;

    settings = {
      title = "${vars.username} dashboard";

      background = {
        image =
          "https://raw.githubusercontent.com/atimofeev/nixos-config/main/assets/dark-shore-comp.png";
        # blur = "sm";
        saturate = 50;
        brightness = 85;
        opacity = 50;
      };

      cardBlur = "sm";
      theme = "dark";
      color = "slate";

      target = "_blank"; # open links in new tabs

      hideVersion = true;
    };

  };

  # use instead of unstable options
  # fix cache issue
  # https://github.com/NixOS/nixpkgs/issues/328621
  # https://github.com/NixOS/nixpkgs/issues/297168
  systemd.services.homepage-dashboard = {
    environment = { HOMEPAGE_CACHE_DIR = "/var/cache/homepage-dashboard"; };

    serviceConfig = { CacheDirectory = "homepage-dashboard"; };
  };

}
