{ pkgs, osConfig, ... }: {
  programs.firefox = {
    enable = true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = true;
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
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "findbar.highlightAll" = true;

        # diable fullscreen notification
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;
        "full-screen-api.warning.timeout" = 0;

        # gpu-accelerated stuff
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        "media.av1.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.hls.enabled" = true;

        "media.videocontrols.picture-in-picture.enabled" = true;
        "permissions.default.desktop-notification" = 2;
        "privacy.donottrackheader.enabled" = true;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "security.osclientcerts.autoload" = true;
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

        };
      };

    };
  };
}
