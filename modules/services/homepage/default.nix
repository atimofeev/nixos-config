{ config, vars, ... }: {

  imports = [ ./bookmarks.nix ./widgets.nix ];

  sops.secrets."work/homepage-env" = {
    owner = vars.username;
    restartUnits = [ "homepage-dashboard.service" ];
  };

  services.homepage-dashboard = {
    enable = true;
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

      target = "_self";

      hideVersion = true;
    };
  };

}
