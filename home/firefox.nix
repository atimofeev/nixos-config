# FIX: non-idempotent: firefox updates config, breaking home-manager
# FIX: search.engines: aliases not working
{ pkgs, vars, ... }: {
  programs.firefox = {
    enable = true;
    profiles.${vars.username} = {
      search.engines = {
        "Google" = { metaData.alias = [ "g" ]; };
        "GitHub" = {
          definedAliases = [ "gh" ];
          urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
        };
        "YouTube" = {
          definedAliases = [ "yt" ];
          urls = [{
            template =
              "https://www.youtube.com/results?search_query={searchTerms}";
          }];
        };
        "Nix Packages" = {
          definedAliases = [ "np" ];
          urls = [{
            template =
              "https://search.nixos.org/packages?type=packages&query={searchTerms}";
          }];
          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };
        "NixOS Wiki" = {
          definedAliases = [ "nw" ];
          urls = [{
            template = "https://nixos.wiki/index.php?search={searchTerms}";
          }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
        };
        search.default = "DuckDuckGo";
      };
    };
  };
}
