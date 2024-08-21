{ vars, ... }: {

  imports = [ ./bookmarks.nix ./widgets.nix ];

  services.homepage-dashboard = {
    enable = true;
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
}
