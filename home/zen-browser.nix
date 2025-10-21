{
  inputs,
  pkgs,
  config,
  ...
}:
{

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    inherit (config.programs.firefox) policies;
    profiles.default = {
      isDefault = true;
      inherit (config.programs.firefox.profiles.default) userContent;
      settings = config.programs.firefox.profiles.default.settings // {
        # "zen.workspaces.natural-scroll" = true;
        # "zen.view.compact.hide-tabbar" = true;
        # "zen.view.compact.animate-sidebar" = false;
        "zen.tabs.show-newtab-vertical" = false;
        "zen.theme.accent-color" = "#8aadf4";
        "zen.urlbar.behavior" = "float";
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.toolbar-flash-popup" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.view.window.scheme" = 0;
        "zen.welcome-screen.seen" = true;
        "zen.workspaces.continue-where-left-off" = true;
      };
      search = {
        force = true;
        default = "google";
        inherit (config.programs.firefox.profiles.default.search) engines;
      };
    };
  };

}
