{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.custom-hm.services.dankmaterialshell;
in
{

  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
  ];

  options.custom-hm.services.dankmaterialshell = {
    enable = lib.mkEnableOption "dankmaterialshell bundle";
    target = lib.mkOption {
      default = "graphical-session.target";
      type = lib.types.str;
    };
    launcher-cmd = lib.mkOption {
      default = "dms ipc spotlight toggle";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.dms = {
      Install = {
        WantedBy = lib.mkForce [ cfg.target ];
      };
      Service.Restart = lib.mkForce "always";
      Unit = {
        After = lib.mkForce [ cfg.target ];
        PartOf = lib.mkForce [ cfg.target ];
      };
    };

    programs.dankMaterialShell = {
      enable = true;

      systemd.enable = true;

      enableVPN = false;

      default = {

        settings = {
          "acLockTimeout" = 300;
          "acMonitorTimeout" = 600;
          "acProfileName" = "2";
          "acSuspendBehavior" = 0;
          "acSuspendTimeout" = 1800;
          "animationSpeed" = 1;
          "appLauncherGridColumns" = 4;
          "appLauncherViewMode" = "list";
          "audioInputDevicePins" = { };
          "audioOutputDevicePins" = { };
          "audioVisualizerEnabled" = true;
          "barConfigs" = [
            {
              "id" = "default";
              "name" = "Main Bar";
              "enabled" = true;
              "position" = 0;
              "screenPreferences" = [
                {
                  "name" = "eDP-1";
                  "model" = "ATNA60DL01-0 ";
                }
              ];
              "showOnLastDisplay" = true;
              "leftWidgets" = [
                {
                  "id" = "workspaceSwitcher";
                  "enabled" = true;
                }
                {
                  "id" = "weather";
                  "enabled" = true;
                }
              ];
              "centerWidgets" = [
                {
                  "id" = "clock";
                  "enabled" = true;
                }
                {
                  "id" = "music";
                  "enabled" = true;
                }
              ];
              "rightWidgets" = [
                {
                  "id" = "systemTray";
                  "enabled" = true;
                }
                {
                  "id" = "controlCenterButton";
                  "enabled" = true;
                }
                {
                  "id" = "battery";
                  "enabled" = true;
                }
                {
                  "id" = "notificationButton";
                  "enabled" = true;
                }
              ];
              "spacing" = 0;
              "innerPadding" = -1;
              "bottomGap" = -4;
              "transparency" = 0;
              "widgetTransparency" = 0.65;
              "squareCorners" = false;
              "noBackground" = false;
              "gothCornersEnabled" = false;
              "gothCornerRadiusOverride" = false;
              "gothCornerRadiusValue" = 12;
              "borderEnabled" = false;
              "borderColor" = "surfaceText";
              "borderOpacity" = 1;
              "borderThickness" = 1;
              "widgetOutlineEnabled" = true;
              "widgetOutlineColor" = "surfaceText";
              "widgetOutlineOpacity" = 0.19;
              "widgetOutlineThickness" = 1;
              "fontScale" = 1.3000000000000007;
              "autoHide" = false;
              "autoHideDelay" = 250;
              "openOnOverview" = false;
              "visible" = true;
              "popupGapsAuto" = true;
              "popupGapsManual" = 34;
            }
          ];
          "batteryLockTimeout" = 180;
          "batteryMonitorTimeout" = 180;
          "batteryProfileName" = "0";
          "batterySuspendBehavior" = 0;
          "batterySuspendTimeout" = 600;
          "bluetoothDevicePins" = { };
          "blurWallpaperOnOverview" = false;
          "blurredWallpaperLayer" = false;
          "brightnessDevicePins" = { };
          "centeringMode" = "index";
          "clockCompactMode" = false;
          "clockDateFormat" = "";
          "configVersion" = 2;
          "controlCenterShowAudioIcon" = true;
          "controlCenterShowBatteryIcon" = false;
          "controlCenterShowBluetoothIcon" = true;
          "controlCenterShowBrightnessIcon" = false;
          "controlCenterShowMicIcon" = false;
          "controlCenterShowNetworkIcon" = true;
          "controlCenterShowPrinterIcon" = false;
          "controlCenterShowVpnIcon" = false;
          "controlCenterWidgets" = [
            {
              "id" = "volumeSlider";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "brightnessSlider";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "wifi";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "bluetooth";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "audioOutput";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "audioInput";
              "enabled" = true;
              "width" = 50;
            }
            {
              "id" = "nightMode";
              "enabled" = true;
              "width" = 25;
            }
            {
              "id" = "doNotDisturb";
              "enabled" = true;
              "width" = 25;
            }
            {
              "id" = "idleInhibitor";
              "enabled" = true;
              "width" = 25;
            }
            {
              "id" = "colorPicker";
              "enabled" = true;
              "width" = 25;
            }
          ];
          "cornerRadius" = 12;
          "currentThemeName" = "dynamic";
          "customAnimationDuration" = 500;
          "customPowerActionHibernate" = "";
          "customPowerActionLock" = "";
          "customPowerActionLogout" = "";
          "customPowerActionPowerOff" = "";
          "customPowerActionReboot" = "";
          "customPowerActionSuspend" = "";
          "customThemeFile" = "";
          "displayNameMode" = "system";
          "dockAutoHide" = false;
          "dockBorderColor" = "surfaceText";
          "dockBorderEnabled" = false;
          "dockBorderOpacity" = 1;
          "dockBorderThickness" = 1;
          "dockBottomGap" = 0;
          "dockGroupByApp" = false;
          "dockIconSize" = 40;
          "dockIndicatorStyle" = "circle";
          "dockMargin" = 0;
          "dockOpenOnOverview" = false;
          "dockPosition" = 1;
          "dockSpacing" = 4;
          "dockTransparency" = 1;
          "dwlShowAllTags" = false;
          "enableFprint" = false;
          "enabledGpuPciIds" = [ ];
          "fadeToLockEnabled" = true;
          "fadeToLockGracePeriod" = 15;
          "focusedWindowCompactMode" = false;
          "fontFamily" = "Inter Variable";
          "fontScale" = 1;
          "fontWeight" = 400;
          "gtkThemingEnabled" = false;
          "hideBrightnessSlider" = false;
          "iconTheme" = "System Default";
          "keyboardLayoutNameCompactMode" = false;
          "launchPrefix" = "";
          "launcherLogoBrightness" = 0.5;
          "launcherLogoColorInvertOnMode" = false;
          "launcherLogoColorOverride" = "";
          "launcherLogoContrast" = 1;
          "launcherLogoCustomPath" = "";
          "launcherLogoMode" = "apps";
          "launcherLogoSizeOffset" = 0;
          "lockBeforeSuspend" = true;
          "lockDateFormat" = "";
          "lockScreenActiveMonitor" = "eDP-1";
          "lockScreenInactiveColor" = "#000000";
          "lockScreenShowDate" = true;
          "lockScreenShowPasswordField" = true;
          "lockScreenShowPowerActions" = true;
          "lockScreenShowProfileImage" = true;
          "lockScreenShowSystemIcons" = true;
          "lockScreenShowTime" = true;
          "loginctlLockIntegration" = true;
          "matugenScheme" = "scheme-tonal-spot";
          "matugenTargetMonitor" = "";
          "matugenTemplateAlacritty" = true;
          "matugenTemplateDgop" = true;
          "matugenTemplateFirefox" = true;
          "matugenTemplateFoot" = true;
          "matugenTemplateGhostty" = true;
          "matugenTemplateGtk" = true;
          "matugenTemplateKcolorscheme" = true;
          "matugenTemplateKitty" = true;
          "matugenTemplateNiri" = true;
          "matugenTemplatePywalfox" = true;
          "matugenTemplateQt5ct" = true;
          "matugenTemplateQt6ct" = true;
          "matugenTemplateVesktop" = true;
          "matugenTemplateVscode" = true;
          "matugenTemplateWezterm" = true;
          "maxFprintTries" = 3;
          "maxWorkspaceIcons" = 3;
          "mediaSize" = 1;
          "modalDarkenBackground" = true;
          "monoFontFamily" = "FiraCode Nerd Font";
          "networkPreference" = "wifi";
          "nightModeEnabled" = false;
          "niriOverviewOverlayEnabled" = true;
          "notepadFontFamily" = "";
          "notepadFontSize" = 14;
          "notepadLastCustomTransparency" = 0.7;
          "notepadShowLineNumbers" = false;
          "notepadTransparencyOverride" = -1;
          "notepadUseMonospace" = true;
          "notificationOverlayEnabled" = true;
          "notificationPopupPosition" = 0;
          "notificationTimeoutCritical" = 0;
          "notificationTimeoutLow" = 5000;
          "notificationTimeoutNormal" = 5000;
          "osdAlwaysShowValue" = false;
          "osdAudioOutputEnabled" = true;
          "osdBrightnessEnabled" = true;
          "osdCapsLockEnabled" = true;
          "osdIdleInhibitorEnabled" = true;
          "osdMediaVolumeEnabled" = true;
          "osdMicMuteEnabled" = true;
          "osdPosition" = 5;
          "osdPowerProfileEnabled" = false;
          "osdVolumeEnabled" = true;
          "popupTransparency" = 1;
          "powerActionConfirm" = true;
          "powerActionHoldDuration" = 0.5;
          "powerMenuActions" = [
            "reboot"
            "logout"
            "poweroff"
            "lock"
            "suspend"
            "restart"
            "hibernate"
          ];
          "powerMenuDefaultAction" = "logout";
          "powerMenuGridLayout" = false;
          # "preventIdleForMedia" = false;
          "privacyShowCameraIcon" = false;
          "privacyShowMicIcon" = false;
          "privacyShowScreenShareIcon" = false;
          "qtThemingEnabled" = false;
          "runDmsMatugenTemplates" = true;
          "runUserMatugenTemplates" = true;
          "runningAppsCompactMode" = true;
          "runningAppsCurrentWorkspace" = false;
          "runningAppsGroupByApp" = false;
          "screenPreferences" = {
            "dock" = [ "all" ];
            "notifications" = [ "all" ];
            "osd" = [ "all" ];
            "wallpaper" = [ "all" ];
          };
          "scrollTitleEnabled" = false;
          "selectedGpuIndex" = 0;
          "showBattery" = true;
          "showCapsLockIndicator" = true;
          "showClipboard" = true;
          "showClock" = true;
          "showControlCenterButton" = true;
          "showCpuTemp" = true;
          "showCpuUsage" = true;
          "showDock" = false;
          "showFocusedWindow" = true;
          "showGpuTemp" = true;
          "showLauncherButton" = true;
          "showMemUsage" = true;
          "showMusic" = true;
          "showNotificationButton" = true;
          "showOccupiedWorkspacesOnly" = true;
          "showOnLastDisplay" = {
            dock = true;
            notifications = true;
            osd = true;
          };
          "showPrivacyButton" = true;
          "showSeconds" = false;
          "showSystemTray" = true;
          "showWeather" = true;
          "showWorkspaceApps" = true;
          "showWorkspaceIndex" = false;
          "showWorkspacePadding" = false;
          "showWorkspaceSwitcher" = true;
          "sortAppsAlphabetically" = false;
          "soundNewNotification" = false;
          "soundPluggedIn" = true;
          "soundVolumeChanged" = true;
          "soundsEnabled" = true;
          "spotlightCloseNiriOverview" = true;
          "spotlightModalViewMode" = "list";
          "syncModeWithPortal" = true;
          "terminalsAlwaysDark" = false;
          "updaterCustomCommand" = "";
          "updaterTerminalAdditionalParams" = "";
          "updaterUseCustomCommand" = false;
          "use24HourClock" = true;
          "useAutoLocation" = false;
          "useFahrenheit" = false;
          "useSystemSoundTheme" = false;
          "vpnLastConnected" = "";
          "wallpaperFillMode" = "Fill";
          "waveProgressEnabled" = true;
          "weatherCoordinates" = "42.2885656,18.8419505";
          "weatherEnabled" = true;
          "weatherLocation" = "Budva, Opština Budva";
          "widgetBackgroundColor" = "s";
          "widgetColorMode" = "default";
          "wifiNetworkPins" = { };
          "workspaceNameIcons" = { };
          "workspaceScrolling" = false;
          "workspacesPerMonitor" = true;
        };

        session = {
          "brightnessExponentValues" = { };
          "brightnessExponentialDevices" = { };
          "brightnessUserSetValues" = { };
          "configVersion" = 1;
          "doNotDisturb" = false;
          "enabledGpuPciIds" = [ ];
          "hiddenTrayIds" = [ ];
          "includedTransitions" = [
            "fade"
            "wipe"
            "disc"
            "stripes"
            "iris bloom"
            "pixelate"
            "portal"
          ];
          "isLightMode" = false;
          "lastBrightnessDevice" = "";
          "latitude" = 0;
          "launchPrefix" = "";
          "longitude" = 0;
          "monitorCyclingSettings" = { };
          "monitorWallpapers" = { };
          "monitorWallpapersDark" = { };
          "monitorWallpapersLight" = { };
          "nightModeAutoEnabled" = true;
          "nightModeAutoMode" = "time";
          "nightModeEnabled" = false;
          "nightModeEndHour" = 8;
          "nightModeEndMinute" = 0;
          "nightModeHighTemperature" = 6500;
          "nightModeLocationProvider" = "";
          "nightModeStartHour" = 22;
          "nightModeStartMinute" = 0;
          "nightModeTemperature" = 5000;
          "nightModeUseIPLocation" = false;
          "nonNvidiaGpuTempEnabled" = false;
          "nvidiaGpuTempEnabled" = false;
          "perModeWallpaper" = false;
          "perMonitorWallpaper" = false;
          "pinnedApps" = [ ];
          "recentColors" = [
            "#000000"
            "#00000000"
            "#9e9e9e"
            "#8ccff0"
          ];
          "selectedGpuIndex" = 0;
          "showThirdPartyPlugins" = true;
          "wallpaperCyclingEnabled" = true;
          "wallpaperCyclingInterval" = 300;
          "wallpaperCyclingMode" = "interval";
          "wallpaperCyclingTime" = "06:00";
          "wallpaperPath" = inputs.walls + "/dark-shore.png";
          "wallpaperPathDark" = inputs.walls + "/dark-shore.png";
          "wallpaperPathLight" = inputs.walls + "/dark-shore.png";
          "wallpaperTransition" = "fade";
          "weatherHourlyDetailed" = true;
          "wifiDeviceOverride" = "";
        };

      };

    };
  };

}
