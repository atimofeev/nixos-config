{ pkgs, inputs, ... }:

let
  inherit (inputs.hyprlock.packages.${pkgs.system}) hypridle;
  hyprlock = "${inputs.hyprlock.packages.${pkgs.system}}/bin/hyprlock";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in {

  services.hypridle = {
    enable = true;
    package = hypridle;
    settings = {

      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd =
          "(kill $(pidof hypridle) || true) && (pidof hypridle || hypridle)";
      };

      listener = [

        {
          timeout = 150; # 2.5min.
          on-timeout = "${brightnessctl} -s set 1000";
          on-resume = "${brightnessctl} -r";
        }

        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend";
        }

      ];

    };
  };

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "idleinhibit always, fullscreen:1"
      "idleinhibit, class:^(Slack)$ title:^(.*Huddle.*)$"
      "idleinhibit, class:^(firefox)$ title:^(Meet.*)$"
      "idleinhibit, class:^(firefox)$ title:^(.*Miro.*)$"
      # "idleinhibit, class:^(firefox)$ title:^(.*YouTube.*)$"
    ];
  };

}
