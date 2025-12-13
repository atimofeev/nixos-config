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
  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.dms = {
      Install = {
        WantedBy = lib.mkForce [ cfg.target ];
      };
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
          "currentThemeName" = "dynamic";
          "customThemeFile" = "";
          "matugenScheme" = "scheme-tonal-spot";
          "runUserMatugenTemplates" = true;
          "matugenTargetMonitor" = "";
          "popupTransparency" = 1;
          "dockTransparency" = 1;
          "widgetBackgroundColor" = "s";
          "widgetColorMode" = "default";
          "cornerRadius" = 12;
          "use24HourClock" = true;
          "showSeconds" = false;
          "useFahrenheit" = false;
          "nightModeEnabled" = true;
          "animationSpeed" = 1;
          "customAnimationDuration" = 500;
          "wallpaperFillMode" = "Fill";
          "blurredWallpaperLayer" = false;
          "blurWallpaperOnOverview" = false;
          "showLauncherButton" = true;
          "showWorkspaceSwitcher" = true;
          "showFocusedWindow" = true;
          "showWeather" = true;
          "showMusic" = true;
          "showClipboard" = true;
          "showCpuUsage" = true;
          "showMemUsage" = true;
          "showCpuTemp" = true;
          "showGpuTemp" = true;
          "selectedGpuIndex" = 0;
          "enabledGpuPciIds" = [ ];
          "showSystemTray" = true;
          "showClock" = true;
          "showNotificationButton" = true;
          "showBattery" = true;
          "showControlCenterButton" = true;
          "showCapsLockIndicator" = true;
          "controlCenterShowNetworkIcon" = true;
          "controlCenterShowBluetoothIcon" = true;
          "controlCenterShowAudioIcon" = true;
          "controlCenterShowVpnIcon" = false;
          "controlCenterShowBrightnessIcon" = false;
          "controlCenterShowMicIcon" = false;
          "controlCenterShowBatteryIcon" = false;
          "controlCenterShowPrinterIcon" = false;
          "showPrivacyButton" = true;
          "privacyShowMicIcon" = false;
          "privacyShowCameraIcon" = false;
          "privacyShowScreenShareIcon" = false;
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
          "showWorkspaceIndex" = false;
          "showWorkspacePadding" = false;
          "workspaceScrolling" = false;
          "showWorkspaceApps" = true;
          "maxWorkspaceIcons" = 3;
          "workspacesPerMonitor" = true;
          "showOccupiedWorkspacesOnly" = true;
          "dwlShowAllTags" = false;
          "workspaceNameIcons" = { };
          "waveProgressEnabled" = false;
          "clockCompactMode" = false;
          "focusedWindowCompactMode" = false;
          "runningAppsCompactMode" = true;
          "keyboardLayoutNameCompactMode" = false;
          "runningAppsCurrentWorkspace" = false;
          "runningAppsGroupByApp" = false;
          "clockDateFormat" = "";
          "lockDateFormat" = "";
          "mediaSize" = 1;
          "appLauncherViewMode" = "list";
          "spotlightModalViewMode" = "list";
          "sortAppsAlphabetically" = false;
          "appLauncherGridColumns" = 4;
          "spotlightCloseNiriOverview" = true;
          "weatherLocation" = "Budva, Opština Budva";
          "weatherCoordinates" = "42.2885656,18.8419505";
          "useAutoLocation" = false;
          "weatherEnabled" = true;
          "networkPreference" = "auto";
          "vpnLastConnected" = "";
          "iconTheme" = "System Default";
          "launcherLogoMode" = "apps";
          "launcherLogoCustomPath" = "";
          "launcherLogoColorOverride" = "";
          "launcherLogoColorInvertOnMode" = false;
          "launcherLogoBrightness" = 0.5;
          "launcherLogoContrast" = 1;
          "launcherLogoSizeOffset" = 0;
          "fontFamily" = "Inter Variable";
          "monoFontFamily" = "Fira Code";
          "fontWeight" = 400;
          "fontScale" = 1;
          "notepadUseMonospace" = true;
          "notepadFontFamily" = "";
          "notepadFontSize" = 14;
          "notepadShowLineNumbers" = false;
          "notepadTransparencyOverride" = -1;
          "notepadLastCustomTransparency" = 0.7;
          "soundsEnabled" = true;
          "useSystemSoundTheme" = false;
          "soundNewNotification" = false;
          "soundVolumeChanged" = true;
          "soundPluggedIn" = true;
          "acMonitorTimeout" = 600;
          "acLockTimeout" = 600;
          "acSuspendTimeout" = 900;
          "acSuspendBehavior" = 0;
          "batteryMonitorTimeout" = 300;
          "batteryLockTimeout" = 300;
          "batterySuspendTimeout" = 600;
          "batterySuspendBehavior" = 0;
          "lockBeforeSuspend" = true;
          "preventIdleForMedia" = false;
          "loginctlLockIntegration" = true;
          "fadeToLockEnabled" = false;
          "fadeToLockGracePeriod" = 5;
          "launchPrefix" = "";
          "brightnessDevicePins" = { };
          "wifiNetworkPins" = { };
          "bluetoothDevicePins" = { };
          "audioInputDevicePins" = { };
          "audioOutputDevicePins" = { };
          "gtkThemingEnabled" = false;
          "qtThemingEnabled" = false;
          "syncModeWithPortal" = true;
          "terminalsAlwaysDark" = false;
          "showDock" = false;
          "dockAutoHide" = false;
          "dockGroupByApp" = false;
          "dockOpenOnOverview" = false;
          "dockPosition" = 1;
          "dockSpacing" = 4;
          "dockBottomGap" = 0;
          "dockMargin" = 0;
          "dockIconSize" = 40;
          "dockIndicatorStyle" = "circle";
          "notificationOverlayEnabled" = true;
          "modalDarkenBackground" = true;
          "lockScreenShowPowerActions" = true;
          "enableFprint" = false;
          "maxFprintTries" = 3;
          "hideBrightnessSlider" = false;
          "notificationTimeoutLow" = 5000;
          "notificationTimeoutNormal" = 5000;
          "notificationTimeoutCritical" = 0;
          "notificationPopupPosition" = 0;
          "osdAlwaysShowValue" = false;
          "osdPosition" = 5;
          "osdVolumeEnabled" = true;
          "osdMediaVolumeEnabled" = true;
          "osdBrightnessEnabled" = true;
          "osdIdleInhibitorEnabled" = true;
          "osdMicMuteEnabled" = true;
          "osdCapsLockEnabled" = true;
          "osdPowerProfileEnabled" = false;
          "powerActionConfirm" = true;
          "powerActionHoldDuration" = 0.5;
          "powerMenuActions" = [
            "reboot"
            "logout"
            "poweroff"
            "lock"
            "suspend"
            "restart"
          ];
          "powerMenuDefaultAction" = "logout";
          "powerMenuGridLayout" = false;
          "customPowerActionLock" = "";
          "customPowerActionLogout" = "";
          "customPowerActionSuspend" = "";
          "customPowerActionHibernate" = "";
          "customPowerActionReboot" = "";
          "customPowerActionPowerOff" = "";
          "updaterUseCustomCommand" = false;
          "updaterCustomCommand" = "";
          "updaterTerminalAdditionalParams" = "";
          "displayNameMode" = "system";
          "screenPreferences" = {
            "wallpaper" = [
              "all"
            ];
          };
          "showOnLastDisplay" = { };
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
                  "id" = "focusedWindow";
                  "enabled" = true;
                }
              ];
              "centerWidgets" = [
                {
                  "id" = "weather";
                  "enabled" = true;
                }
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
                  "id" = "battery";
                  "enabled" = true;
                }
                {
                  "id" = "controlCenterButton";
                  "enabled" = true;
                }
                {
                  "id" = "notificationButton";
                  "enabled" = true;
                }
              ];
              "spacing" = 0;
              "innerPadding" = -2;
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
              "widgetOutlineEnabled" = false;
              "widgetOutlineColor" = "primary";
              "widgetOutlineOpacity" = 1;
              "widgetOutlineThickness" = 1;
              "fontScale" = 1.3000000000000007;
              "autoHide" = false;
              "autoHideDelay" = 250;
              "openOnOverview" = false;
              "visible" = true;
              "popupGapsAuto" = true;
              "popupGapsManual" = 4;
            }
          ];
        };

        session = {
          "isLightMode" = false;
          "wallpaperPath" = inputs.walls + "/dark-shore.png";
          "perMonitorWallpaper" = false;
          "monitorWallpapers" = { };
          "perModeWallpaper" = false;
          "wallpaperPathLight" = "";
          "wallpaperPathDark" = "";
          "monitorWallpapersLight" = { };
          "monitorWallpapersDark" = { };
          "brightnessExponentialDevices" = { };
          "brightnessUserSetValues" = { };
          "brightnessExponentValues" = { };
          "doNotDisturb" = false;
          "nightModeEnabled" = true;
          "nightModeTemperature" = 5000;
          "nightModeHighTemperature" = 6500;
          "nightModeAutoEnabled" = true;
          "nightModeAutoMode" = "time";
          "nightModeStartHour" = 22;
          "nightModeStartMinute" = 0;
          "nightModeEndHour" = 8;
          "nightModeEndMinute" = 0;
          "latitude" = 0;
          "longitude" = 0;
          "nightModeUseIPLocation" = false;
          "nightModeLocationProvider" = "";
          "pinnedApps" = [ ];
          "hiddenTrayIds" = [ ];
          "selectedGpuIndex" = 0;
          "nvidiaGpuTempEnabled" = false;
          "nonNvidiaGpuTempEnabled" = false;
          "enabledGpuPciIds" = [ ];
          "wifiDeviceOverride" = "";
          "wallpaperCyclingEnabled" = true;
          "wallpaperCyclingMode" = "interval";
          "wallpaperCyclingInterval" = 900;
          "wallpaperCyclingTime" = "06:00";
          "monitorCyclingSettings" = { };
          "lastBrightnessDevice" = "";
          "launchPrefix" = "";
          "wallpaperTransition" = "fade";
          "includedTransitions" = [
            "fade"
            "wipe"
            "disc"
            "stripes"
            "iris bloom"
            "pixelate"
            "portal"
          ];
          "recentColors" = [
            "#8ccff0"
          ];
          "showThirdPartyPlugins" = true;
        };

      };

    };
  };

}
