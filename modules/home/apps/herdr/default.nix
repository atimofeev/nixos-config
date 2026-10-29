{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.herdr;
  settingsFormat = pkgs.formats.toml { };
in
{

  options.custom-hm.applications.herdr = {
    enable = lib.mkEnableOption "herdr bundle";
    package = lib.mkPackageOption pkgs "herdr" { };
    settings = lib.mkOption {
      default = {
        keys = {
          command = [
            {
              command = "python3 ${config.xdg.configHome}/herdr/new-workspace.py";
              description = "New workspace from zoxide (neojj + pi-agent)";
              height = "60%";
              key = "prefix+shift+n";
              type = "popup";
              width = "80%";
            }
          ];
          goto = "ctrl+space";
          navigate_pane_down = "ctrl+j";
          navigate_pane_up = "ctrl+k";
          navigate_workspace_down = [
            "down"
            "j"
          ];
          navigate_workspace_up = [
            "up"
            "k"
          ];
          new_workspace = "";
          switch_tab = [
            "prefix+1..9"
            "ctrl+1..9"
          ];
        };
        onboarding = false;
        ui = {
          hide_tab_bar_when_single_tab = true;
          pane_gaps = false;
          pane_outer_borders = false;
          pane_scrollbars = false;
          sidebar_collapsed_mode = "hidden";
          sidebar_start_collapsed = true;
          sound.enabled = false;
          toast.delivery = "herdr";
        };
      };
      description = "Herdr configuration written to {file}`$XDG_CONFIG_HOME/herdr/config.toml`.";
      type = settingsFormat.type;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "herdr/config.toml" = lib.mkIf (cfg.settings != { }) {
        source = settingsFormat.generate "herdr-config.toml" cfg.settings;
      };
      "herdr/new-workspace.py".source = ./new-workspace.py;
    };
  };

}
