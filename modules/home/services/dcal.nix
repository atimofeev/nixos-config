{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.services.dcal;
in
{

  imports = [ inputs.dankcalendar.homeModules.dank-calendar ];

  options.custom-hm.services.dcal = {
    enable = lib.mkEnableOption "DankCalendar daemon for DMS calendar integration";
  };

  config = lib.mkIf cfg.enable {
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
