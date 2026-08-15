{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.rog-control-center;
  rogControlCenterConfig = ''
    (
        run_in_background: true,
        startup_in_background: true,
        enable_tray_icon: true,
        ac_command: "",
        bat_command: "",
        dark_mode: true,
        start_fullscreen: false,
        fullscreen_width: 1920,
        fullscreen_height: 1080,
        notifications: (
            enabled: false,
            receive_notify_gfx: true,
            receive_notify_gfx_status: true,
        ),
    )
  '';
in
{

  options.custom-hm.applications.rog-control-center = {
    enable = lib.mkEnableOption "rog-control-center bundle";
    package = lib.mkPackageOption pkgs "asusctl" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg = {
      autostart = {
        enable = true;
        entries = [ "${cfg.package}/share/applications/rog-control-center.desktop" ];
      };
      # configFile."rog/rog-control-center.cfg" = {
      #   force = true;
      #   text = rogControlCenterConfig;
      # };
    };
  };

}
