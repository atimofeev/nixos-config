{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dank-material-shell;
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
    launcher-cmd = lib.mkOption {
      default = "dms ipc spotlight toggle";
      type = lib.types.str;
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

      dgop.package = pkgs.unstable.dgop;

      systemd = {
        enable = true;
        inherit (cfg) target;
      };

      enableVPN = false;

      settings = {
        currentThemeName = "dynamic";
        currentThemeCategory = "dynamic";
        customThemeFile = "";
        registryThemeVariants = { };
        matugenScheme = "scheme-tonal-spot";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 1;
        dockTransparency = 1;
        widgetBackgroundColor = "s";
        widgetColorMode = "default";
        controlCenterTileColorMode = "primary";
        buttonColorMode = "primary";
        cornerRadius = 12;
        niriLayoutGapsOverride = -1;
        niriLayoutRadiusOverride = -1;
        niriLayoutBorderSize = -1;
        hyprlandLayoutGapsOverride = -1;
        hyprlandLayoutRadiusOverride = -1;
        hyprlandLayoutBorderSize = -1;
        mangoLayoutGapsOverride = -1;
        mangoLayoutRadiusOverride = -1;
        mangoLayoutBorderSize = -1;
        use24HourClock = true;
        showSeconds = false;
        padHours12Hour = false;
        useFahrenheit = false;
        windSpeedUnit = "kmh";
        nightModeEnabled = false;
        animationSpeed = 1;
        customAnimationDuration = 500;
        syncComponentAnimationSpeeds = true;
        popoutAnimationSpeed = 1;
        popoutCustomAnimationDuration = 150;
        modalAnimationSpeed = 1;
        modalCustomAnimationDuration = 150;
        enableRippleEffects = true;
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = false;
        blurWallpaperOnOverview = false;
        showLauncherButton = true;
        showWorkspaceSwitcher = true;
        showFocusedWindow = true;
        showWeather = true;
        showMusic = true;
        showClipboard = true;
        showCpuUsage = true;
        showMemUsage = true;
        showCpuTemp = true;
        showGpuTemp = true;
        selectedGpuIndex = 0;
        enabledGpuPciIds = [ ];
        showSystemTray = true;
        showClock = true;
        showNotificationButton = true;
        showBattery = true;
        showControlCenterButton = true;
        showCapsLockIndicator = true;
        controlCenterShowNetworkIcon = true;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowAudioIcon = true;
        controlCenterShowAudioPercent = false;
        controlCenterShowVpnIcon = false;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowBrightnessPercent = false;
        controlCenterShowMicIcon = false;
        controlCenterShowMicPercent = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        controlCenterShowScreenSharingIcon = true;
        showPrivacyButton = true;
        privacyShowMicIcon = false;
        privacyShowCameraIcon = false;
        privacyShowScreenShareIcon = false;
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
        ];
        showWorkspaceIndex = false;
        showWorkspaceName = false;
        showWorkspacePadding = false;
        workspaceScrolling = false;
        showWorkspaceApps = true;
        workspaceDragReorder = true;
        maxWorkspaceIcons = 3;
        workspaceAppIconSizeOffset = 0;
        groupWorkspaceApps = true;
        workspaceFollowFocus = false;
        showOccupiedWorkspacesOnly = true;
        reverseScrolling = false;
        dwlShowAllTags = false;
        workspaceColorMode = "default";
        workspaceOccupiedColorMode = "none";
        workspaceUnfocusedColorMode = "default";
        workspaceUrgentColorMode = "default";
        workspaceFocusedBorderEnabled = false;
        workspaceFocusedBorderColor = "primary";
        workspaceFocusedBorderThickness = 2;
        workspaceNameIcons = { };
        waveProgressEnabled = true;
        scrollTitleEnabled = false;
        audioVisualizerEnabled = true;
        audioScrollMode = "volume";
        audioWheelScrollAmount = 5;
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        barMaxVisibleApps = 0;
        barMaxVisibleRunningApps = 0;
        barShowOverflowBadge = true;
        appsDockHideIndicators = false;
        appsDockColorizeActive = false;
        appsDockActiveColorMode = "primary";
        appsDockEnlargeOnHover = false;
        appsDockEnlargePercentage = 125;
        appsDockIconSizePercentage = 100;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = false;
        runningAppsGroupByApp = false;
        runningAppsCurrentMonitor = false;
        appIdSubstitutions = [
          {
            pattern = "Spotify";
            replacement = "spotify";
            type = "exact";
          }
          {
            pattern = "beepertexts";
            replacement = "beeper";
            type = "exact";
          }
          {
            pattern = "home assistant desktop";
            replacement = "homeassistant-desktop";
            type = "exact";
          }
          {
            pattern = "com.transmissionbt.transmission";
            replacement = "transmission-gtk";
            type = "contains";
          }
          {
            pattern = "^steam_app_(\\d+)$";
            replacement = "steam_icon_$1";
            type = "regex";
          }
        ];
        centeringMode = "index";
        clockDateFormat = "";
        lockDateFormat = "";
        mediaSize = 1;
        appLauncherViewMode = "list";
        spotlightModalViewMode = "list";
        browserPickerViewMode = "grid";
        browserUsageHistory = { };
        appPickerViewMode = "grid";
        filePickerUsageHistory = { };
        sortAppsAlphabetically = false;
        appLauncherGridColumns = 4;
        spotlightCloseNiriOverview = true;
        spotlightSectionViewModes = { };
        appDrawerSectionViewModes = { };
        niriOverviewOverlayEnabled = true;
        dankLauncherV2Size = "compact";
        dankLauncherV2BorderEnabled = false;
        dankLauncherV2BorderThickness = 2;
        dankLauncherV2BorderColor = "primary";
        dankLauncherV2ShowFooter = true;
        dankLauncherV2UnloadOnClose = false;
        useAutoLocation = false;
        weatherEnabled = true;
        networkPreference = "wifi";
        iconTheme = "System Default";
        cursorSettings = {
          theme = "System Default";
          size = 24;
          niri = {
            hideWhenTyping = false;
            hideAfterInactiveMs = 0;
          };
          hyprland = {
            hideOnKeyPress = false;
            hideOnTouch = false;
            inactiveTimeout = 0;
          };
          dwl = {
            cursorHideTimeout = 0;
          };
        };
        launcherLogoMode = "apps";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "";
        launcherLogoColorInvertOnMode = false;
        launcherLogoBrightness = 0.5;
        launcherLogoContrast = 1;
        launcherLogoSizeOffset = 0;
        fontFamily = "Inter Variable";
        monoFontFamily = "FiraCode Nerd Font";
        fontWeight = 400;
        fontScale = 1;
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = 0.7;
        soundsEnabled = true;
        useSystemSoundTheme = false;
        soundNewNotification = false;
        soundVolumeChanged = true;
        soundPluggedIn = true;
        acMonitorTimeout = 600;
        acLockTimeout = 300;
        acSuspendTimeout = 1800;
        acSuspendBehavior = 0;
        acProfileName = "2";
        batteryMonitorTimeout = 180;
        batteryLockTimeout = 180;
        batterySuspendTimeout = 600;
        batterySuspendBehavior = 0;
        batteryProfileName = "0";
        batteryChargeLimit = 100;
        lockBeforeSuspend = true;
        loginctlLockIntegration = true;
        fadeToLockEnabled = true;
        fadeToLockGracePeriod = 15;
        fadeToDpmsEnabled = true;
        fadeToDpmsGracePeriod = 15;
        launchPrefix = "";
        brightnessDevicePins = { };
        wifiNetworkPins = { };
        bluetoothDevicePins = { };
        audioInputDevicePins = { };
        audioOutputDevicePins = { };
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
        terminalsAlwaysDark = false;
        runDmsMatugenTemplates = true;
        matugenTemplateGtk = true;
        matugenTemplateNiri = true;
        matugenTemplateHyprland = true;
        matugenTemplateMangowc = true;
        matugenTemplateQt5ct = true;
        matugenTemplateQt6ct = true;
        matugenTemplateFirefox = true;
        matugenTemplatePywalfox = true;
        matugenTemplateZenBrowser = true;
        matugenTemplateVesktop = true;
        matugenTemplateEquibop = true;
        matugenTemplateGhostty = true;
        matugenTemplateKitty = true;
        matugenTemplateFoot = true;
        matugenTemplateAlacritty = true;
        matugenTemplateNeovim = true;
        matugenTemplateWezterm = true;
        matugenTemplateDgop = true;
        matugenTemplateKcolorscheme = true;
        matugenTemplateVscode = true;
        matugenTemplateEmacs = true;
        showDock = false;
        dockAutoHide = false;
        dockSmartAutoHide = false;
        dockGroupByApp = false;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockSpacing = 4;
        dockBottomGap = 0;
        dockMargin = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        dockBorderEnabled = false;
        dockBorderColor = "surfaceText";
        dockBorderOpacity = 1;
        dockBorderThickness = 1;
        dockIsolateDisplays = false;
        dockLauncherEnabled = false;
        dockLauncherLogoMode = "apps";
        dockLauncherLogoCustomPath = "";
        dockLauncherLogoColorOverride = "";
        dockLauncherLogoSizeOffset = 0;
        dockLauncherLogoBrightness = 0.5;
        dockLauncherLogoContrast = 1;
        dockMaxVisibleApps = 0;
        dockMaxVisibleRunningApps = 0;
        dockShowOverflowBadge = true;
        notificationOverlayEnabled = true;
        notificationPopupShadowEnabled = true;
        notificationPopupPrivacyMode = false;
        modalDarkenBackground = true;
        lockScreenShowPowerActions = true;
        lockScreenShowSystemIcons = true;
        lockScreenShowTime = true;
        lockScreenShowDate = true;
        lockScreenShowProfileImage = true;
        lockScreenShowPasswordField = true;
        lockScreenShowMediaPlayer = true;
        lockScreenPowerOffMonitorsOnLock = false;
        lockAtStartup = false;
        enableFprint = false;
        maxFprintTries = 3;
        lockScreenActiveMonitor = "eDP-1";
        lockScreenInactiveColor = "#000000";
        lockScreenNotificationMode = 2;
        hideBrightnessSlider = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationCompactMode = false;
        notificationPopupPosition = 0;
        notificationAnimationSpeed = 1;
        notificationCustomAnimationDuration = 400;
        notificationHistoryEnabled = true;
        notificationHistoryMaxCount = 50;
        notificationHistoryMaxAgeDays = 7;
        notificationHistorySaveLow = true;
        notificationHistorySaveNormal = true;
        notificationHistorySaveCritical = true;
        notificationRules = [ ];
        osdAlwaysShowValue = false;
        osdPosition = 5;
        osdVolumeEnabled = true;
        osdMediaVolumeEnabled = true;
        osdMediaPlaybackEnabled = true;
        osdBrightnessEnabled = true;
        osdIdleInhibitorEnabled = true;
        osdMicMuteEnabled = true;
        osdCapsLockEnabled = true;
        osdPowerProfileEnabled = false;
        osdAudioOutputEnabled = true;
        powerActionConfirm = true;
        powerActionHoldDuration = 0.5;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
          "hibernate"
        ];
        powerMenuDefaultAction = "logout";
        powerMenuGridLayout = false;
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionSuspend = "";
        customPowerActionHibernate = "";
        customPowerActionReboot = "";
        customPowerActionPowerOff = "";
        updaterHideWidget = false;
        updaterUseCustomCommand = false;
        updaterCustomCommand = "";
        updaterTerminalAdditionalParams = "";
        displayNameMode = "system";
        screenPreferences = {
          dock = [ "all" ];
          notifications = [ "all" ];
          osd = [ "all" ];
          wallpaper = [ "all" ];
        };
        showOnLastDisplay = {
          dock = true;
          notifications = true;
          osd = true;
        };
        niriOutputSettings = { };
        hyprlandOutputSettings = { };
        displayProfiles = { };
        activeDisplayProfile = { };
        displayProfileAutoSelect = false;
        displayShowDisconnected = false;
        displaySnapToEdge = true;
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
        desktopClockEnabled = false;
        desktopClockStyle = "analog";
        desktopClockTransparency = 0.8;
        desktopClockColorMode = "primary";
        desktopClockCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        desktopClockShowDate = true;
        desktopClockShowAnalogNumbers = false;
        desktopClockShowAnalogSeconds = true;
        desktopClockX = -1;
        desktopClockY = -1;
        desktopClockWidth = 280;
        desktopClockHeight = 180;
        desktopClockDisplayPreferences = [ "all" ];
        systemMonitorEnabled = false;
        systemMonitorShowHeader = true;
        systemMonitorTransparency = 0.8;
        systemMonitorColorMode = "primary";
        systemMonitorCustomColor = {
          r = 1;
          g = 1;
          b = 1;
          a = 1;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          hslHue = -1;
          hslSaturation = 0;
          hslLightness = 1;
          valid = true;
        };
        systemMonitorShowCpu = true;
        systemMonitorShowCpuGraph = true;
        systemMonitorShowCpuTemp = true;
        systemMonitorShowGpuTemp = false;
        systemMonitorGpuPciId = "";
        systemMonitorShowMemory = true;
        systemMonitorShowMemoryGraph = true;
        systemMonitorShowNetwork = true;
        systemMonitorShowNetworkGraph = true;
        systemMonitorShowDisk = true;
        systemMonitorShowTopProcesses = false;
        systemMonitorTopProcessCount = 3;
        systemMonitorTopProcessSortBy = "cpu";
        systemMonitorGraphInterval = 60;
        systemMonitorLayoutMode = "auto";
        systemMonitorX = -1;
        systemMonitorY = -1;
        systemMonitorWidth = 320;
        systemMonitorHeight = 480;
        systemMonitorDisplayPreferences = [ "all" ];
        systemMonitorVariants = [ ];
        desktopWidgetPositions = { };
        desktopWidgetGridSettings = { };
        desktopWidgetInstances = [ ];
        desktopWidgetGroups = [ ];
        builtInPluginSettings = { };
        clipboardEnterToPaste = false;
        launcherPluginVisibility = { };
        launcherPluginOrder = [ ];
        configVersion = 5;
      };

      session = {
        isLightMode = false;
        doNotDisturb = false;
        wallpaperPath = wall.dest + "/dark-shore.png";
        perMonitorWallpaper = false;
        monitorWallpapers = { };
        perModeWallpaper = false;
        wallpaperPathLight = wall.dest + "/dark-shore.png";
        wallpaperPathDark = wall.dest + "/dark-shore.png";
        monitorWallpapersLight = { };
        monitorWallpapersDark = { };
        monitorWallpaperFillModes = { };
        wallpaperTransition = "fade";
        includedTransitions = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "iris bloom"
          "pixelate"
          "portal"
        ];
        wallpaperCyclingEnabled = true;
        wallpaperCyclingMode = "interval";
        wallpaperCyclingInterval = 900;
        wallpaperCyclingTime = "06:00";
        monitorCyclingSettings = { };
        nightModeEnabled = false;
        nightModeTemperature = 5000;
        nightModeHighTemperature = 6500;
        nightModeAutoEnabled = true;
        nightModeAutoMode = "time";
        nightModeStartHour = 22;
        nightModeStartMinute = 0;
        nightModeEndHour = 8;
        nightModeEndMinute = 0;
        latitude = 0;
        longitude = 0;
        nightModeUseIPLocation = false;
        nightModeLocationProvider = "";
        themeModeAutoEnabled = false;
        themeModeAutoMode = "time";
        themeModeStartHour = 18;
        themeModeStartMinute = 0;
        themeModeEndHour = 6;
        themeModeEndMinute = 0;
        themeModeShareGammaSettings = true;
        weatherLocation = "Budva, Opština Budva";
        weatherCoordinates = "42.2885656,18.8419505";
        pinnedApps = [ ];
        barPinnedApps = [ ];
        dockLauncherPosition = 0;
        hiddenTrayIds = [ ];
        trayItemOrder = [ ];
        recentColors = [
          "#000000"
          "#00000000"
          "#9e9e9e"
          "#8ccff0"
        ];
        showThirdPartyPlugins = true;
        launchPrefix = "";
        lastBrightnessDevice = "";
        brightnessExponentialDevices = { };
        brightnessUserSetValues = { };
        brightnessExponentValues = { };
        selectedGpuIndex = 0;
        nvidiaGpuTempEnabled = false;
        nonNvidiaGpuTempEnabled = false;
        enabledGpuPciIds = [ ];
        wifiDeviceOverride = "";
        weatherHourlyDetailed = true;
        hiddenApps = [ ];
        appOverrides = { };
        searchAppActions = true;
        vpnLastConnected = "";
        deviceMaxVolumes = { };
        hiddenOutputDeviceNames = [ ];
        hiddenInputDeviceNames = [ ];
        configVersion = 3;
      };

    };
  };

}
