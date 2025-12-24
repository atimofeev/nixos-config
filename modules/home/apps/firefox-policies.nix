{
  config,
  lib,
  ...
}:
let
  firefoxCfg = config.custom-hm.applications.firefox;
  cfg = firefoxCfg.policies;
in
{

  options.custom-hm.applications.firefox.policies = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = firefoxCfg.enable;
      description = "firefox policies";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.firefox.policies = {
      # NOTE: Can't be enabled outside US and some other countries
      # AutofillAddressEnabled = true;
      # AutofillCreditCardEnabled = true;
      DisableAppUpdate = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      FirefoxHome = {
        Highlights = false;
        Locked = true;
        Pocket = false;
        Search = true;
        Snippets = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        SponsoredTopSites = false;
        Stories = false;
        TopSites = false;
      };
      FirefoxSuggest = {
        SponsoredSuggestions = false;
        Locked = true;
      };
      HardwareAcceleration = true;
      Homepage = {
        Locked = true;
        StartPage = "previous-session";
      };
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      ShowHomeButton = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        FirefoxLabs = false;
        Locked = true;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
        WhatsNew = false;
      };
    };

  };

}
