{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.gnome;
in
{

  options.custom.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop bundle";
    terminal = lib.mkOption {
      default = "kitty";
      description = "Terminal used by nautilus-open-any-terminal.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dconf-editor
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.gamemode-shell-extension
      gnomeExtensions.pip-on-top
      gnomeExtensions.pop-shell
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      inherit (cfg) terminal;
    };

    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };

}
