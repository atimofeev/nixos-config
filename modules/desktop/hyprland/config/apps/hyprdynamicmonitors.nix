{
  inputs,
  pkgs,
  ...
}:
let

  zefir-monitor = "Samsung Display Corp. ATNA60DL01-0";
  milaptop-monitor = "BOE 0x0747";
  portable-monitor = "Lenovo Group Limited M14t V309WMZ3";
  work-monitor-left = "Dell Inc. DELL P2422H 8WRR0V3";
  work-monitor-right = "Dell Inc. DELL P2422H 6FZG7N3";

  zefir-bat-conf = pkgs.writeText "zefir-bat" ''monitor=desc:Samsung Display Corp. ATNA60DL01-0,2560x1600@60,0x0,1.33'';
  zefir-ac-conf = pkgs.writeText "zefir-ac" ''monitor=desc:Samsung Display Corp. ATNA60DL01-0,2560x1600@240,0x0,1.33'';

  zefir-home-conf = pkgs.writeText "zefir-home-conf" ''
    monitor=desc:Samsung Display Corp. ATNA60DL01-0,2560x1600@240,0x0,1.33
    workspace=1, monitor:desc:${work-monitor-left}, default:yes
    workspace=2, monitor:desc:${work-monitor-left}
    workspace=3, monitor:desc:${work-monitor-left}
    workspace=4, monitor:desc:${work-monitor-left}
    workspace=5, monitor:desc:${zefir-monitor}, default:yes
    workspace=6, monitor:desc:${zefir-monitor}
    workspace=7, monitor:desc:${zefir-monitor}
    workspace=8, monitor:desc:${zefir-monitor}
    workspace=9, monitor:desc:${zefir-monitor}
    workspace=10, monitor:desc:${portable-monitor}, default:yes
    workspace=11, monitor:desc:${portable-monitor}
    workspace=12, monitor:desc:${portable-monitor}
    workspace=13, monitor:desc:${portable-monitor}
    workspace=14, monitor:desc:${portable-monitor}
  '';

  zefir-work-conf = pkgs.writeText "zefir-work-conf" ''
    monitor=desc:Samsung Display Corp. ATNA60DL01-0,2560x1600@240,0x0,1.33
    workspace=1, monitor:desc:${work-monitor-left}, default:yes
    workspace=2, monitor:desc:${work-monitor-left}
    workspace=3, monitor:desc:${work-monitor-left}
    workspace=4, monitor:desc:${work-monitor-left}
    workspace=5, monitor:desc:${zefir-monitor}, default:yes
    workspace=6, monitor:desc:${zefir-monitor}
    workspace=7, monitor:desc:${zefir-monitor}
    workspace=8, monitor:desc:${zefir-monitor}
    workspace=9, monitor:desc:${zefir-monitor}
    workspace=10, monitor:desc:${work-monitor-right}, default:yes
    workspace=11, monitor:desc:${work-monitor-right}
    workspace=12, monitor:desc:${work-monitor-right}
    workspace=13, monitor:desc:${work-monitor-right}
    workspace=14, monitor:desc:${work-monitor-right}
  '';

  milaptop-home-conf = pkgs.writeText "milaptop-home-conf" ''
    workspace=1, monitor:desc:${work-monitor-left}, default:yes
    workspace=2, monitor:desc:${work-monitor-left}
    workspace=3, monitor:desc:${work-monitor-left}
    workspace=4, monitor:desc:${work-monitor-left}
    workspace=5, monitor:desc:${milaptop-monitor}, default:yes
    workspace=6, monitor:desc:${milaptop-monitor}
    workspace=7, monitor:desc:${milaptop-monitor}
    workspace=8, monitor:desc:${milaptop-monitor}
    workspace=9, monitor:desc:${milaptop-monitor}
    workspace=10, monitor:desc:${portable-monitor}, default:yes
    workspace=11, monitor:desc:${portable-monitor}
    workspace=12, monitor:desc:${portable-monitor}
    workspace=13, monitor:desc:${portable-monitor}
    workspace=14, monitor:desc:${portable-monitor}
  '';

  milaptop-work-conf = pkgs.writeText "milaptop-work-conf" ''
    workspace=1, monitor:desc:${work-monitor-left}, default:yes
    workspace=2, monitor:desc:${work-monitor-left}
    workspace=3, monitor:desc:${work-monitor-left}
    workspace=4, monitor:desc:${work-monitor-left}
    workspace=5, monitor:desc:${milaptop-monitor}, default:yes
    workspace=6, monitor:desc:${milaptop-monitor}
    workspace=7, monitor:desc:${milaptop-monitor}
    workspace=8, monitor:desc:${milaptop-monitor}
    workspace=9, monitor:desc:${milaptop-monitor}
    workspace=10, monitor:desc:${work-monitor-right}, default:yes
    workspace=11, monitor:desc:${work-monitor-right}
    workspace=12, monitor:desc:${work-monitor-right}
    workspace=13, monitor:desc:${work-monitor-right}
    workspace=14, monitor:desc:${work-monitor-right}
  '';

in
{

  imports = [ inputs.hyprdynamicmonitors.homeManagerModules.default ];

  wayland.windowManager.hyprland.settings.source = "~/.config/hypr/monitors.conf";

  home.hyprdynamicmonitors = {
    enable = true;
    config = # toml
      ''
        [profiles.zefir-bat]
        config_file = "${zefir-bat-conf}"
        config_file_type = "static"

        [profiles.zefir-bat.conditions]
        power_state = "BAT"

        [[profiles.zefir-bat.conditions.required_monitors]]
        description = "${zefir-monitor}"

        [profiles.zefir-ac]
        config_file = "${zefir-ac-conf}"
        config_file_type = "static"

        [profiles.zefir-ac.conditions]
        power_state = "AC"

        [[profiles.zefir-ac.conditions.required_monitors]]
        description = "${portable-monitor}"

        [profiles.zefir-home]
        config_file = "${zefir-home-conf}"
        config_file_type = "static"

        [profiles.zefir-home.conditions]

        [[profiles.zefir-home.conditions.required_monitors]]
        description = "${zefir-monitor}"

        [[profiles.zefir-home.conditions.required_monitors]]
        description = "${portable-monitor}"

        [profiles.zefir-work]
        config_file = "${zefir-work-conf}"
        config_file_type = "static"

        [profiles.zefir-work.conditions]

        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${zefir-monitor}"

        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${work-monitor-left}"

        [[profiles.zefir-work.conditions.required_monitors]]
        description = "${work-monitor-right}"

        [profiles.milaptop-home]
        config_file = "${milaptop-home-conf}"
        config_file_type = "static"

        [profiles.milaptop-home.conditions]

        [[profiles.milaptop-home.conditions.required_monitors]]
        description = "${milaptop-monitor}"

        [[profiles.milaptop-home.conditions.required_monitors]]
        description = "${portable-monitor}"

        [profiles.milaptop-work]
        config_file = "${milaptop-work-conf}"
        config_file_type = "static"

        [profiles.milaptop-work.conditions]

        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${milaptop-monitor}"

        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${work-monitor-left}"

        [[profiles.milaptop-work.conditions.required_monitors]]
        description = "${work-monitor-right}"
      '';
  };

}
