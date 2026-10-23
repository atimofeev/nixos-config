{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dux-calendar;
in
{

  imports = [ inputs.dux-calendar.homeModules.default ];

  options.custom-hm.services.dux-calendar = {
    enable = lib.mkEnableOption "Dux Calendar integration for Dux Shell";
  };

  config = lib.mkIf cfg.enable {
    # Upstream retains the pre-rebrand namespace and dcal runtime names.
    programs.dank-calendar = {
      enable = true;
      systemd.enable = true;
      quickshell.package = pkgs.unstable.quickshell;
      settings = {
        allDayReminderDaysBefore = 0;
        allDayReminderTime = "09:00";
        allDayReminders = true;
        closeBehavior = "minimize";
        colorSource = "auto";
        coreHoursEnabled = true;
        coreHoursEnd = 22;
        coreHoursStart = 8;
        customThemeFile = "";
        defaultEventDurationMinutes = 30;
        defaultReminderMinutes = 10;
        dismissedAccountNotices = [ ];
        firstDayOfWeek = -1;
        lastView = "agenda";
        monthEventTitleLines = 1;
        monthShowAllEvents = false;
        notificationSounds = false;
        presetTheme = "purple";
        reminderPersist = true;
        remindersEnabled = true;
        showTasks = true;
        showTrayIcon = false;
        showWeekNumbers = true;
        sidebarCollapsed = false;
        sidebarWidth = 240;
        snoozeMinutes = 5;
        syncIntervalMinutes = 15;
        themeMode = "auto";
        timeFormat = "auto";
        use24HourClock = true;
        weekEventTitleLines = 1;
      };
    };
  };

}
