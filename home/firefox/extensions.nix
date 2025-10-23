{ inputs, pkgs, ... }:
{

  programs.firefox.profiles.default.extensions = {
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

}
