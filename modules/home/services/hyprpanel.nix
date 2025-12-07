{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom-hm.services.hyprpanel;

  blueman-manager = lib.getExe' pkgs.blueman "blueman-manager";
  kitty = lib.getExe pkgs.kitty;
  nm-connection-editor = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  yazi = lib.getExe pkgs.yazi;

in
{

  options.custom-hm.services.hyprpanel = {
    enable = lib.mkEnableOption "hyprpanel bundle";
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."personal/weather-api" = { };

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, B, exec, ${systemctl} --user restart hyprpanel"
    ];

    systemd.user.services.hyprpanel = {
      Install = {
        WantedBy = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      };
      Service.Restart = lib.mkForce "always";
      Unit = {
        After = lib.mkForce [ "wayland-wm@Hyprland.service" ];
        PartOf = lib.mkForce [ "wayland-wm@Hyprland.service" ];
      };
    };

    programs.hyprpanel = {

      enable = true;
      systemd.enable = true;

      settings = {

        bar = {
          # autoHide = "single-window";
          bluetooth = {
            label = true;
            rightClick = blueman-manager;
          };
          clock.format = "%a %b %d %H:%M";
          launcher.autoDetectIcon = true;
          layouts = {
            "0" = {
              left = [
                "dashboard"
                "workspaces"
                "windowtitle"
              ];
              middle = [ "media" ];
              right = [
                "volume"
                "network"
                "bluetooth"
                "battery"
                "systray"
                "clock"
                "kbinput"
                "notifications"
              ];
            };
            "1" = {
              left = [ ];
              middle = [ ];
              right = [ ];
            };
            "2" = {
              left = [ ];
              middle = [ ];
              right = [ ];
            };
          };
          network = {
            rightClick = nm-connection-editor;
            showWifiInfo = true;
          };
          notifications.show_total = false;
          windowtitle.custom_title = true;
          workspaces = {
            ignored = "-\\d+"; # hide special workspaces
            monitorSpecific = true;
            show_icons = true;
            show_numbered = false;
            workspaceMask = false;
          };
        };

        menus = {
          clock = {
            time.military = true;
            weather = {
              key = config.sops.secrets."personal/weather-api".path;
              location = "Budva";
              unit = "metric";
            };
          };
          dashboard = {
            powermenu.avatar.image = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
            directories = {
              left = {
                directory1 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}/Downloads";
                  label = "󰉍 Downloads";
                };
                directory2 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}/Videos";
                  label = "󰉏 Videos";
                };
                directory3 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}/repos";
                  label = "󰚝 Projects";
                };
              };
              right = {
                directory1 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}/Documents";
                  label = "󱧶 Documents";
                };
                directory2 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}/Pictures";
                  label = "󰉏 Pictures";
                };
                directory3 = {
                  command = "${kitty} -e ${yazi} ${config.home.homeDirectory}";
                  label = "󱂵 Home";
                };
              };
            };
          };
          power = {
            lowBatteryNotification = true;
            lowBatteryNotificationText = "Battery is running low - $POWER_LEVEL %";
            lowBatteryThreshold = 15;
          };
        };

        scalingPriority = "hyprland";

        theme = {
          bar = {
            buttons = {
              dashboard.icon = "#99c1f1";
              modules.kbLayout.enableBorder = false;
              workspaces.enableBorder = false;
            };
            floating = false;
            menus.menu = {
              clock.scaling = 85;
              dashboard.scaling = 80;
              notifications.scaling = 90;
            };
            scaling = 75;
          };
          notification.enableShadow = false;
          osd = {
            active_monitor = true;
            duration = 1000;
            location = "bottom";
            margins = "0px 0px 35px 0px";
            muted_zero = true;
            orientation = "horizontal";
          };
        };

      };

    };
  };
}
