{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dux-shell;
  wall = config.custom-hm.user.wallpaper;
in
{

  imports = [
    inputs.dux-shell.homeModules.default
  ];

  options.custom-hm.services.dux-shell = {
    enable = lib.mkEnableOption "Dux Shell bundle";
    package = lib.mkPackageOption pkgs "dms-shell" { };
    target = lib.mkOption {
      default = "graphical-session.target";
      type = lib.types.str;
    };
    command = lib.mkOption {
      default = "dms ipc spotlight toggle";
      type = lib.types.str;
    };
    clipboard-cmd = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
    web-search-cmd = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    # HACK: https://github.com/duxlabs-dev/dux-shell/issues/1073
    # fix for autostart apps tray functionality
    systemd.user.services.dms = {
      Service.ExecStartPost = "${pkgs.coreutils}/bin/sleep 5";
      Unit.Before = [
        "xdg-desktop-autostart.target"
      ];
    };

    # Upstream retains the pre-rebrand module namespace and dms runtime names.
    programs.dank-material-shell = {
      enable = true;
      inherit (cfg) package;

      quickshell.package =
        inputs.dux-shell.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.quickshell;

      systemd = {
        enable = true;
        inherit (cfg) target;
      };

      enableVPN = false;

      settings = {
        acLockTimeout = 300;
        acMonitorTimeout = 600;
        acProfileName = "2";
        acSuspendTimeout = 1800;
        barElevationEnabled = false;
        barConfigs = [
          {
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = -4;
            centerWidgets = [
              {
                enabled = true;
                id = "clock";
              }
              {
                enabled = true;
                id = "music";
                mediaSize = 2;
              }
            ];
            enabled = true;
            followInterfaceStyle = false;
            fontScale = 1.3000000000000007;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 0;
            leftWidgets = [
              {
                enabled = true;
                groupWorkspaceApps = false;
                id = "workspaceSwitcher";
                maxWorkspaceIcons = 6;
                showOccupiedWorkspacesOnly = true;
                showWorkspaceApps = true;
                workspaceUrgentColorMode = "secondaryContainer";
              }
              {
                enabled = true;
                id = "weather";
              }
            ];
            name = "Main Bar";
            noBackground = false;
            openOnOverview = false;
            popupGapsAuto = true;
            popupGapsManual = 34;
            position = 0;
            rightWidgets = [
              {
                enabled = true;
                id = "systemTray";
              }
              {
                enabled = true;
                id = "controlCenterButton";
              }
              {
                enabled = true;
                id = "battery";
              }
              {
                enabled = true;
                id = "notificationButton";
              }
            ];
            screenPreferences = [
              {
                model = "ATNA60DL01-0 ";
                name = "eDP-1";
              }
            ];
            showOnLastDisplay = true;
            spacing = 0;
            squareCorners = false;
            transparency = 0;
            visible = true;
            widgetFollowInterfaceStyle = false;
            widgetOutlineColor = "surfaceText";
            widgetOutlineEnabled = true;
            widgetOutlineOpacity = 0.19;
            widgetOutlineThickness = 1;
            widgetTransparency = 0.65;
          }
        ];
        batteryLockTimeout = 180;
        batteryMonitorTimeout = 180;
        batteryProfileName = "0";
        batterySuspendTimeout = 600;
        calendarBackend = "dankcal";
        clockFormat = "24h";
        controlCenterColumns = 8;
        controlCenterWidgets = [
          {
            enabled = true;
            h = 1;
            id = "user";
            w = 5;
          }
          {
            enabled = true;
            h = 1;
            id = "settings";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "lock";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "power";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "volumeSlider";
            small = true;
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "brightnessSlider";
            small = true;
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "wifi";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "bluetooth";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "audioOutput";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "audioInput";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "nightMode";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "doNotDisturb";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "idleInhibitor";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "colorPicker";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "builtin_vpn";
            w = 8;
          }
          {
            enabled = true;
            h = 1;
            id = "edit";
            small = true;
            w = 1;
          }
        ];
        currentThemeCategory = "dynamic";
        currentThemeName = "dynamic";
        fadeToDpmsGracePeriod = 15;
        fadeToLockGracePeriod = 15;
        fixedRadius = 12;
        lockBeforeSuspend = true;
        lockScreenBlurInactiveBackground = true;
        lowerDisplayRefreshRateOnBattery = true;
        matugenTemplateNeovim = true;
        maxFprintTries = 3;
        monoFontFamily = "FiraCode Nerd Font";
        networkPreference = "wifi";
        notificationOverlayEnabled = true;
        osdMediaPlaybackEnabled = false;
        osdPowerProfileEnabled = true;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
          "hibernate"
        ];
        radiusMode = "fixed";
        screenPreferences = {
          lockScreen = [ "eDP-1" ];
        };
        scrollTitleEnabled = false;
        showOnLastDisplay = {
          notifications = true;
          osd = true;
        };
        soundNewNotification = false;
        widgetBackgroundColor = "s";
      };

      session = {
        configVersion = 3;
        nightModeAutoEnabled = true;
        nightModeEnabled = true;
        nightModeEndHour = 8;
        nightModeStartHour = 23;
        nightModeTemperature = 5000;
        recentColors = [
          "#000000"
          "#00000000"
          "#9e9e9e"
          "#8ccff0"
        ];
        showThirdPartyPlugins = true;
        wallpaperCyclingEnabled = true;
        wallpaperCyclingInterval = 900;
        wallpaperCyclingRandom = true;
        wallpaperPath = wall.dest + "/dark-shore.png";
        wallpaperPathDark = wall.dest + "/dark-shore.png";
        wallpaperPathLight = wall.dest + "/dark-shore.png";
        weatherCoordinates = "42.2885656,18.8419505";
        weatherLocation = "Budva, Opština Budva";
      };

    };
  };

}
