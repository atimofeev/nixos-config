{ config, lib, ... }:
{

  xdg.desktopEntries = lib.optionals config.programs.firefox.enable {
    slack-kiosk = {
      name = "Slack Kiosk";
      exec = "firefox --new-window \"https://betby.slack.com\" --kiosk --class slack-kiosk";
      categories = [ "Network" ];
    };
  };

}
