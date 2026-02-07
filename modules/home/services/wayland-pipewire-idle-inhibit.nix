{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom-hm.services.wayland-pipewire-idle-inhibit;
in
{

  imports = [ inputs.wayland-pipewire-idle-inhibit.homeModules.default ];

  options.custom-hm.services.wayland-pipewire-idle-inhibit = {
    enable = lib.mkEnableOption "wayland-pipewire-idle-inhibit bundle";
  };

  config = lib.mkIf cfg.enable {

    services.wayland-pipewire-idle-inhibit = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = {
        # verbosity = "INFO";
        media_minimum_duration = 5;
        idle_inhibitor = "wayland";
        node_blacklist = [ { name = "[Ff]irefox"; } ];
      };
    };

  };
}
