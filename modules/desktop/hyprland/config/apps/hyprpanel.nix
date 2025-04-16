{ pkgs, inputs, config, ... }: {

  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  sops.secrets."personal/weather-api" = { };

  wayland.windowManager.hyprland.settings.bind =
    let systemctl = "${pkgs.systemd}/bin/systemctl";
    in [ "SUPER, B, exec, ${systemctl} --user restart hyprpanel" ];

  # NOTE: https://github.com/Jas-SinghFSU/HyprPanel/issues/892
  systemd.user.services.hyprpanel = {
    Unit = {
      Description = "hyprpanel";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
      Restart = "always";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  programs.hyprpanel = {

    enable = true;
    overwrite.enable = true;

    # NOTE: https://github.com/Jas-SinghFSU/HyprPanel/issues/886
    # override.theme.bar.buttons.dashboard.icon = "#99c1f1";

    settings = {

      bar = {
        bluetooth = {
          label = true;
          rightClick = "${pkgs.blueman}/bin/blueman-manager";
        };
        clock.format = "%a %b %d %H:%M";
        launcher.autoDetectIcon = true;
        network = {
          rightClick = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
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

      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "dashboard" "workspaces" "windowtitle" ];
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
        dashboard.directories = {
          left = {
            directory1 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/Downloads";
              label = "󰉍 Downloads";
            };
            directory2 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/Videos";
              label = "󰉏 Videos";
            };
            directory3 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/repos";
              label = "󰚝 Projects";
            };
          };
          right = {
            directory1 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/Documents";
              label = "󱧶 Documents";
            };
            directory2 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}/Pictures";
              label = "󰉏 Pictures";
            };
            directory3 = {
              command =
                "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi ${config.home.homeDirectory}";
              label = "󱂵 Home";
            };
          };
        };
      };

      theme = {
        name = "catppuccin_macchiato";
        bar = {
          buttons = {
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
}
