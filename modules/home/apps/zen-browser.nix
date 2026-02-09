{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.zen-browser;
  firefoxCfg = config.programs.firefox.profiles.default;
  catppuccin-css = inputs.catppuccin-zen-browser;
in
{

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.custom-hm.applications.zen-browser = {
    enable = lib.mkEnableOption "zen-browser bundle";
  };

  config = lib.mkIf cfg.enable {

    custom-hm.applications.firefox.enable = true;

    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
      inherit (config.programs.firefox) policies;
      profiles.default = rec {
        isDefault = true;

        userChrome = firefoxCfg.userChrome + builtins.readFile "${catppuccin-css}/userChrome.css";
        userContent = firefoxCfg.userContent + builtins.readFile "${catppuccin-css}/userContent.css";

        inherit (firefoxCfg) extensions;

        settings = firefoxCfg.settings // {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enables css theming
          "zen.tabs.show-newtab-vertical" = false;
          "zen.theme.accent-color" = "#8aadf4";
          "zen.urlbar.behavior" = "float";
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = true;
          "zen.view.compact.toolbar-flash-popup" = true;
          "zen.view.experimental-no-window-controls" = true;
          "zen.view.show-newtab-button-top" = false;
          "zen.view.window.scheme" = 0;
          "zen.welcome-screen.seen" = true;
          "zen.window-sync.enabled" = false;
          "zen.workspaces.continue-where-left-off" = true;
          # "zen.view.compact.animate-sidebar" = false;
          # "zen.workspaces.natural-scroll" = true;
        };

        search = {
          force = true;
          default = "google";
          inherit (firefoxCfg.search) engines;
        };

        pinsForce = true;
        pins = {
          "Gmail" = {
            id = "1eabb6a3-911b-4fa9-9eaf-232a3703db19";
            workspace = spaces."Work".id;
            url = "https://mail.google.com/mail/u/0/#inbox";
            position = 102;
            isEssential = false;
            editedTitle = true;
          };
          "Gcalendar" = {
            id = "5065293b-1c04-40ee-ba1d-99a231873864";
            workspace = spaces."Work".id;
            url = "https://calendar.google.com/calendar/u/0/r";
            position = 103;
            isEssential = false;
            editedTitle = true;
          };
          "Miro" = {
            id = "e1aa0661-70a8-4ea7-a311-3d5a5c8ee218";
            workspace = spaces."Work".id;
            url = "https://miro.com";
            position = 104;
            isEssential = false;
            editedTitle = true;
          };
        };

        spacesForce = true;
        spaces = {
          "Work" = {
            id = "572910e1-4468-4832-a869-0b3a93e2f165";
            icon = "🏗";
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 12;
                  green = 13;
                  blue = 39;
                  algorithm = "floating";
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.1;
              texture = 0.25;
            };
          };
          "Research" = {
            id = "ec287d7f-d910-4860-b400-513f269dee77";
            icon = "🧪";
            position = 1001;
            inherit (spaces."Work") theme;
          };
        };

      };
    };
  };

}
