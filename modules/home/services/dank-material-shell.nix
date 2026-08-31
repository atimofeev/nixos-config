{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dank-material-shell;
  dmsPackage = inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.python3 ];
    postPatch = (old.postPatch or "") + ''
      python3 -c ${lib.escapeShellArg ''
        from pathlib import Path

        path = Path("internal/server/network/backend_networkmanager_gp_saml.go")
        text = path.read_text()
        text = text.replace(
            'log.Infof("[GP-SAML] Got prelogin-cookie from gp-saml-gui, converting to openconnect cookie via --authenticate")',
            'log.Infof("[GP-SAML] Got GlobalProtect SAML secret from gp-saml-gui, converting to openconnect cookie via --authenticate")',
        )
        text = text.replace(
            "\n\t// Convert prelogin-cookie to full openconnect cookie format\n\tocResult, err := convertGPPreloginCookie(ctx, gateway, result.Cookie, result.User)",
            "\n\tocResult, err := convertGPAuthSecret(ctx, gateway, result.Host, result.Cookie, result.User)",
        )
        text = text.replace(
            'return nil, fmt.Errorf("GP SAML auth: failed to convert prelogin-cookie: %w", err)',
            'return nil, fmt.Errorf("GP SAML auth: failed to convert SAML secret: %w", err)',
        )
        text = text.replace(
            "func convertGPPreloginCookie(ctx context.Context, gateway, preloginCookie, user string) (*openConnectAuthResult, error) {\n\treturn runOpenConnectAuthenticate(ctx, []string{\n\t\t\"--protocol=gp\",\n\t\t\"--usergroup=gateway:prelogin-cookie\",\n\t\t\"--user=\" + user,\n\t\t\"--passwd-on-stdin\",\n\t\t\"--allow-insecure-crypto\",\n\t\t\"--authenticate\",\n\t\tgateway,\n\t}, preloginCookie)",
            "func convertGPAuthSecret(ctx context.Context, gateway, hostHint, secret, user string) (*openConnectAuthResult, error) {\n\tusergroup := gpSamlUsergroupFromHost(hostHint)\n\treturn runOpenConnectAuthenticate(ctx, []string{\n\t\t\"--protocol=gp\",\n\t\t\"--usergroup=\" + usergroup,\n\t\t\"--user=\" + user,\n\t\t\"--passwd-on-stdin\",\n\t\t\"--allow-insecure-crypto\",\n\t\t\"--authenticate\",\n\t\tgateway,\n\t}, secret)",
        )
        text = text.replace(
            "\nfunc unshellQuote(s string) string {",
            """\nfunc gpSamlUsergroupFromHost(hostHint string) string {
        \tconst defaultUsergroup = "gateway:prelogin-cookie"

        \tif hostHint == "" {
        \t\treturn defaultUsergroup
        \t}

        \tparts := strings.Split(hostHint, "/")
        \tlast := parts[len(parts)-1]
        \tif last == "gateway:token" || last == "portal:token" || last == "gateway:prelogin-cookie" || last == "portal:prelogin-cookie" || last == "portal:portal-userauthcookie" {
        \t\treturn last
        \t}

        \treturn defaultUsergroup
        }

        func unshellQuote(s string) string {""",
        )
        path.write_text(text)
      ''}
    '';
  });
  wall = config.custom-hm.user.wallpaper;
in
{

  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
  ];

  options.custom-hm.services.dank-material-shell = {
    enable = lib.mkEnableOption "dank-material-shell bundle";
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

    # HACK: https://github.com/AvengeMedia/DankMaterialShell/issues/1073
    # fix for autostart apps tray functionality
    systemd.user.services.dms = {
      Service.ExecStartPost = "${pkgs.coreutils}/bin/sleep 5";
      Unit.Before = [
        "xdg-desktop-autostart.target"
      ];
    };

    programs.dank-material-shell = {
      enable = true;
      package = dmsPackage;

      quickshell.package = pkgs.unstable.quickshell;

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
            fontScale = 1.3000000000000007;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = -1;
            leftWidgets = [
              {
                enabled = true;
                id = "workspaceSwitcher";
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
        controlCenterWidgets = [
          {
            enabled = true;
            id = "volumeSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "brightnessSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "wifi";
            width = 50;
          }
          {
            enabled = true;
            id = "bluetooth";
            width = 50;
          }
          {
            enabled = true;
            id = "audioOutput";
            width = 50;
          }
          {
            enabled = true;
            id = "audioInput";
            width = 50;
          }
          {
            enabled = true;
            id = "nightMode";
            width = 50;
          }
          {
            enabled = true;
            id = "doNotDisturb";
            width = 50;
          }
          {
            enabled = true;
            id = "idleInhibitor";
            width = 50;
          }
          {
            enabled = true;
            id = "colorPicker";
            width = 50;
          }
          {
            enabled = true;
            id = "builtin_vpn";
            width = 100;
          }
        ];
        cornerRadius = 12;
        currentThemeCategory = "dynamic";
        currentThemeName = "dynamic";
        fadeToDpmsGracePeriod = 15;
        fadeToLockGracePeriod = 15;
        lockBeforeSuspend = true;
        lockScreenNotificationMode = 2;
        lowerDisplayRefreshRateOnBattery = true;
        matugenTemplateNeovim = true;
        maxFprintTries = 3;
        maxWorkspaceIcons = 6;
        monoFontFamily = "FiraCode Nerd Font";
        networkPreference = "wifi";
        notificationOverlayEnabled = true;
        osdMediaPlaybackEnabled = true;
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
        runningAppsCurrentWorkspace = false;
        screenPreferences = {
          lockScreen = [ "eDP-1" ];
        };
        scrollTitleEnabled = false;
        showOnLastDisplay = {
          dock = true;
          notifications = true;
          osd = true;
        };
        showOccupiedWorkspacesOnly = true;
        showWorkspaceApps = true;
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
