{ pkgs, ... }:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  swaylockPkg = pkgs.swaylock;
  swaylock = "${swaylockPkg}/bin/swaylock";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  pidof = "${pkgs.procps}/bin/pidof";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  lockCommand =
    # "${playerctl} -a pause || true && (${pidof} swaylock || ${swaylock})";
    "(${pidof} swaylock || ${swaylock})";
in {

  # TODO: implement diffent ac/battery timeouts based on `systemd-ac-power` command

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "idleinhibit focus, fullscreen:1"
      "idleinhibit always, fullscreen:1 class:firefox title:^(.*YouTube.*)$"
      "idleinhibit focus, class:firefox title:^(.*Miro.*)$"
      "idleinhibit always, class:Slack title:^(.*Huddle.*)$"
      "idleinhibit always, class:firefox title:^(Meet.*)$"
    ];

    misc = {
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
    };

  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    extraArgs = [ "-w" ];

    timeouts = [
      {
        timeout = 150; # 2.5min.
        command = "${brightnessctl} -s set 1000";
        resumeCommand = "${brightnessctl} -r";
      }

      {
        timeout = 300; # 5min
        command = lockCommand;
      }

      {
        timeout = 330; # 5.5min
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }

      {
        timeout = 1800; # 30min
        command = "${systemctl} suspend";
      }
    ];

    events = [
      {
        event = "lock";
        command = lockCommand;
      }

      {
        event = "before-sleep";
        command = lockCommand;
      }

      {
        event = "after-resume";
        command = "${hyprctl} dispatch dpms on";
      }
    ];
  };

}
