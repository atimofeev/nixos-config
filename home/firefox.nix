{ pkgs, osConfig, ... }: {
  programs.firefox = {
    enable = true;

    policies = {
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
        SponsoredTopSites = false;
        TopSites = false;
      };
      Homepage = {
        URL = "localhost:${
            toString osConfig.services.homepage-dashboard.listenPort
          }";
        Locked = true;
        StartPage = "previous-session";
      };
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      ShowHomeButton = true;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
    };

    profiles.default = {
      isDefault = true;

      settings = {

        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.tabs.unloadOnLowMemory" = true;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
        "cookiebanners.service.mode" = 1;
        "cookiebanners.service.mode.privateBrowsing" = 1;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "findbar.highlightAll" = true;

        # diable fullscreen notification
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;
        "full-screen-api.warning.timeout" = 0;

        # gpu-accelerated stuff
        "gfx.webrender.all" = false;
        "gfx.webrender.compositor.force-enabled" = false;
        "gfx.x11-egl.force-enabled" = false;
        "media.av1.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = false;
        "media.hardware-video-decoding.force-enabled" = false;
        "media.hls.enabled" = false;

        "media.videocontrols.picture-in-picture.enabled" = true;
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" =
          true;
        "permissions.default.desktop-notification" = 2;
        "privacy.donottrackheader.enabled" = true;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "security.osclientcerts.autoload" = true;

        # translation
        "browser.translations.alwaysTranslateLanguages" = "bs,de,lv,sr,uk";
        "browser.translations.neverTranslateLanguages" = "en,ru";
      };

      search = {
        force = true;
        default = "Google";
        engines = {

          "Google".metaData.alias = "g";

          "DuckDuckGo".metaData.alias = "ddg";

          "GitHub" = {
            definedAliases = [ "gh" ];
            urls =
              [{ template = "https://github.com/search?q={searchTerms}"; }];
            iconUpdateURL =
              "https://github.githubassets.com/favicons/favicon-dark.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "YouTube" = {
            definedAliases = [ "yt" ];
            urls = [{
              template =
                "https://www.youtube.com/results?search_query={searchTerms}";
            }];
            iconUpdateURL =
              "https://www.youtube.com/s/desktop/6b6081dd/img/favicon_32x32.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "My NixOS" = {
            definedAliases = [ "mn" ];
            urls =
              [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://mynixos.com/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "NixOS Packages" = {
            definedAliases = [ "np" ];
            urls = [{
              template =
                "https://search.nixos.org/packages?query={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          "NixOS Options" = {
            definedAliases = [ "no" ];
            urls = [{
              template = "https://search.nixos.org/options?query={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          "NixOS Wiki" = {
            definedAliases = [ "nw" ];
            urls = [{
              template =
                "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };

          "GitHub nixpkgs" = {
            definedAliases = [ "ghnp" ];
            urls = [{
              template =
                "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs {searchTerms}&type=code";
            }];
            iconUpdateURL =
              "https://github.githubassets.com/favicons/favicon-dark.png";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "Freedium.cfd" = {
            definedAliases = [ "fd" ];
            urls = [{ template = "https://freedium.cfd/{searchTerms}"; }];
            iconUpdateURL =
              "https://miro.medium.com/v2/5d8de952517e8160e40ef9841c781cdc14a5db313057fa3c3de41c6f5b494b19";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

          "ProtonDB" = {
            definedAliases = [ "pd" ];
            urls =
              [{ template = "https://protondb.com/search?q={searchTerms}"; }];
            iconUpdateURL =
              "https://protondb.com/sites/protondb/images/favicon.ico";
            updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
          };

        };
      };

    };
  };
}
