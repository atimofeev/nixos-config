{
  inputs,
  osConfig,
  pkgs,
  ...
}:
let

  # NOTE: https://github.com/fiffeek/hyprdynamicmonitors/issues/82
  # temporary fix for missing hardcoded udev device on milatop
  upower_path =
    if osConfig.networking.hostName == "milaptop" then
      "/org/freedesktop/UPower/devices/line_power_ADP0"
    else
      "/org/freedesktop/UPower/devices/line_power_ACAD";

  monitors = rec {
    work-left = {
      desc = "Dell Inc. DELL P2422H 8WRR0V3";
      conf = "preferred,-1920x0,1";
    };
    zefir = {
      desc = "Samsung Display Corp. ATNA60DL01-0";
      conf = "2560x1600@240,0x0,1.33";
    };
    zefir-60 = {
      inherit (zefir) desc;
      conf = "2560x1600@60,0x0,1.33";
    };
    milaptop = {
      desc = "BOE 0x0747";
      conf = "preferred,0x0,1";
    };
    portable = {
      desc = "Lenovo Group Limited M14t V309WMZ3";
      conf = "preferred,auto,1.2";
    };
    work-right = {
      desc = "Dell Inc. DELL P2422H 4X6V7N3";
      conf = "preferred,auto,1";
    };
  };

  workspaces-left = m: ''
    monitor=desc:${m.desc},${m.conf}
    workspace=1, monitor:desc:${m.desc}, default:yes
    workspace=2, monitor:desc:${m.desc}
    workspace=3, monitor:desc:${m.desc}
    workspace=4, monitor:desc:${m.desc}
  '';

  workspaces-center = m: ''
    monitor=desc:${m.desc},${m.conf}
    workspace=5, monitor:desc:${m.desc}, default:yes
    workspace=6, monitor:desc:${m.desc}
    workspace=7, monitor:desc:${m.desc}
    workspace=8, monitor:desc:${m.desc}
    workspace=9, monitor:desc:${m.desc}
  '';

  workspaces-right = m: ''
    monitor=desc:${m.desc},${m.conf}
    workspace=10, monitor:desc:${m.desc}, default:yes
    workspace=11, monitor:desc:${m.desc}
    workspace=12, monitor:desc:${m.desc}
    workspace=13, monitor:desc:${m.desc}
    workspace=14, monitor:desc:${m.desc}
  '';

  zefir-bat-conf = pkgs.writeText "zefir-bat" ''
    ${workspaces-left monitors.work-left}
    ${workspaces-center monitors.zefir-60}
    ${workspaces-right monitors.portable}
  '';
  zefir-home-conf = pkgs.writeText "zefir-home-conf" ''
    ${workspaces-left monitors.work-left}
    ${workspaces-center monitors.zefir}
    ${workspaces-right monitors.portable}
  '';
  zefir-work-conf = pkgs.writeText "zefir-work-conf" ''
    ${workspaces-left monitors.work-left}
    ${workspaces-center monitors.zefir}
    ${workspaces-right monitors.work-right}
  '';
  milaptop-home-conf = pkgs.writeText "milaptop-home-conf" ''
    ${workspaces-left monitors.work-left}
    ${workspaces-center monitors.milaptop}
    ${workspaces-right monitors.portable}
  '';
  milaptop-work-conf = pkgs.writeText "milaptop-work-conf" ''
    ${workspaces-left monitors.work-left}
    ${workspaces-center monitors.milaptop}
    ${workspaces-right monitors.work-right}
  '';

in
{

  imports = [ inputs.hyprdynamicmonitors.homeManagerModules.default ];

  wayland.windowManager.hyprland.settings.source = "~/.config/hypr/monitors.conf";

  home.hyprdynamicmonitors = {
    enable = true;
    config = # toml
      ''
        [power_events.dbus_query_object]
        path = "${upower_path}"

        [[power_events.dbus_signal_match_rules]]
        object_path = "${upower_path}"

        [profiles.zefir-bat]
        config_file = "${zefir-bat-conf}"
        config_file_type = "static"
        [profiles.zefir-bat.conditions]
        power_state = "BAT"
        [[profiles.zefir-bat.conditions.required_monitors]]
        description = "${monitors.zefir.desc}"

        [profiles.zefir-home]
        config_file = "${zefir-home-conf}"
        config_file_type = "static"
        [profiles.zefir-home.conditions]
        [[profiles.zefir-home.conditions.required_monitors]]
        description = "${monitors.zefir.desc}"

        [profiles.zefir-work]
        config_file = "${zefir-work-conf}"
        config_file_type = "static"
        [profiles.zefir-work.conditions]
        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${monitors.zefir.desc}"
        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${monitors.work-left.desc}"
        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${monitors.work-right.desc}"

        [profiles.milaptop-home]
        config_file = "${milaptop-home-conf}"
        config_file_type = "static"
        [profiles.milaptop-home.conditions]
        [[profiles.milaptop-home.conditions.required_monitors]]
        description = "${monitors.milaptop.desc}"

        [profiles.milaptop-work]
        config_file = "${milaptop-work-conf}"
        config_file_type = "static"
        [profiles.milaptop-work.conditions]
        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${monitors.milaptop.desc}"
        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${monitors.work-left.desc}"
        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${monitors.work-right.desc}"
      '';
  };

}
