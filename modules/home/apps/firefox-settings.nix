{
  config,
  lib,
  ...
}:
let
  firefoxCfg = config.custom-hm.applications.firefox;
  cfg = firefoxCfg.settings;
in
{

  options.custom-hm.applications.firefox.settings = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = firefoxCfg.enable;
      description = "firefox settings";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.firefox.profiles.default.settings = {
      "browser.aboutConfig.showWarning" = false;
      "browser.aboutwelcome.enabled" = false;
      "browser.tabs.unloadOnLowMemory" = true;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
      "cookiebanners.service.mode" = 1;
      "cookiebanners.service.mode.privateBrowsing" = 1;
      "extensions.autoDisableScopes" = 0;
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "findbar.highlightAll" = true;

      # smoother scrolling
      "mousewheel.min_line_scroll_amount" = 25;
      "general.smoothScroll.mouseWheel.durationMinMS" = 400;
      "general.smoothScroll.mouseWheel.durationMaxMS" = 500;

      "font.name.monospace.x-western" = "DejaVuSansM Nerd Font Mono";
      "font.name.sans-serif.x-western" = "DejaVuSansM Nerd Font";
      "font.name.serif.x-western" = "DejaVuSansM Nerd Font";

      # diable fullscreen notification
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "full-screen-api.warning.delay" = -1;
      "full-screen-api.warning.timeout" = 0;

      "media.videocontrols.picture-in-picture.enabled" = true;
      "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = true;
      "permissions.default.desktop-notification" = 2;
      "privacy.donottrackheader.enabled" = true;
      "security.insecure_connection_text.enabled" = true;
      "security.insecure_connection_text.pbmode.enabled" = true;
      "security.osclientcerts.autoload" = true;

      # translation
      "browser.translations.alwaysTranslateLanguages" = "bs,de,lv,sr,uk";
      "browser.translations.neverTranslateLanguages" = "en,ru";
    };

  };

}
