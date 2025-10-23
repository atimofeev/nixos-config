{ inputs, pkgs, ... }:
{

  programs.firefox = {

    policies.ExtensionSettings = {
      "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}".private_browsing = true; # surfingkeys
      "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-lavender-git/latest.xpi";
        installation_mode = "force_installed";
      };
      "addon@darkreader.org".private_browsing = true;
      "uBlock0@raymondhill.net".private_browsing = true;
    };

    profiles.default.extensions = {
      force = true;
      packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        darkreader
        dearrow
        istilldontcareaboutcookies
        sponsorblock
        surfingkeys
        translate-web-pages
        ublock-origin
        # TODO: allow unfree in firefox-addons.packages
        # OR setup with ExtensionSettings
        # https://gitlab.com/rycee/nur-expressions/-/issues/244
        # languagetool
        # scroll_anywhere
      ];
      settings = {
        "uBlock0@raymondhill.net" = {
          force = true;
          settings = {
            selectedFilterLists = [
              "easylist"
              "easylist-annoyances"
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "easyprivacy"
              "fanboy-cookiemonster"
              "plowe-0"
              "ublock-badware"
              "ublock-cookies-easylist"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "urlhaus-1"
              "user-filters"
              "RUS-0"
              "RUS-1"
            ];
          };
        };
      };
    };

  };

}
