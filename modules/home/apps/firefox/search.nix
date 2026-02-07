{
  config,
  lib,
  pkgs,
  ...
}:
let
  firefoxCfg = config.custom-hm.applications.firefox;
  cfg = firefoxCfg.search;
  updateInterval = 7 * 24 * 60 * 60 * 1000; # every week
in
{

  options.custom-hm.applications.firefox.search = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = firefoxCfg.enable;
      description = "firefox search";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.firefox.profiles.default.search = {
      force = true;
      default = "google";
      engines = {

        "google".metaData.alias = "g";

        "ddg".metaData.alias = "dg";

        "GitHub" = {
          definedAliases = [ "gh" ];
          urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
          icon = "https://github.githubassets.com/favicons/favicon-dark.png";
          inherit updateInterval;
        };

        "youtube" = {
          definedAliases = [ "yt" ];
          urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
          icon = "https://www.youtube.com/s/desktop/6b6081dd/img/favicon_32x32.png";
          inherit updateInterval;
        };

        "ArtifactHUB" = {
          definedAliases = [ "ah" ];
          urls = [
            {
              template = "https://artifacthub.io/packages/search?sort=relevance&page=1&ts_query_web={searchTerms}";
            }
          ];
          icon = "https://artifacthub.io/static/media/logo_v2.png";
          inherit updateInterval;
        };

        "Alpine Packages" = {
          definedAliases = [ "ap" ];
          urls = [ { template = "https://pkgs.alpinelinux.org/packages?name={searchTerms}"; } ];
          icon = "https://pkgs.alpinelinux.org/static/favicon.ico";
          inherit updateInterval;
        };

        "Debian Packages" = {
          definedAliases = [ "dp" ];
          urls = [ { template = "https://packages.debian.org/search?keywords={searchTerms}"; } ];
          icon = "https://packages.debian.org/favicon.ico";
          inherit updateInterval;
        };

        "My NixOS" = {
          definedAliases = [ "mn" ];
          urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
          icon = "https://mynixos.com/favicon.ico";
          inherit updateInterval;
        };

        "NixOS Packages" = {
          definedAliases = [ "np" ];
          urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };

        "NixOS Options" = {
          definedAliases = [ "no" ];
          urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };

        "home-manager Options" = {
          definedAliases = [ "hmo" ];
          urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
          icon = "https://home-manager-options.extranix.com/images/favicon.png";
          inherit updateInterval;
        };

        "NixOS Wiki" = {
          definedAliases = [ "nw" ];
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };

        "GitHub lang:nix" = {
          definedAliases = [ "ghln" ];
          urls = [ { template = "https://github.com/search?q=lang:nix {searchTerms}&type=code"; } ];
          icon = "https://github.githubassets.com/favicons/favicon-dark.png";
          inherit updateInterval;
        };

        "GitHub nixpkgs" = {
          definedAliases = [ "ghnp" ];
          urls = [
            { template = "https://github.com/search?q=repo%3ANixOS%2Fnixpkgs {searchTerms}&type=code"; }
          ];
          icon = "https://github.githubassets.com/favicons/favicon-dark.png";
          inherit updateInterval;
        };

        "GitHub home-manager" = {
          definedAliases = [ "ghhm" ];
          urls = [
            {
              template = "https://github.com/search?q=repo%3Anix-community%2Fhome-manager {searchTerms}&type=code";
            }
          ];
          icon = "https://github.githubassets.com/favicons/favicon-dark.png";
          inherit updateInterval;
        };

        "Freedium.cfd" = {
          definedAliases = [ "fd" ];
          urls = [ { template = "https://freedium.cfd/{searchTerms}"; } ];
          icon = "https://miro.medium.com/v2/5d8de952517e8160e40ef9841c781cdc14a5db313057fa3c3de41c6f5b494b19";
          inherit updateInterval;
        };

        "ProtonDB" = {
          definedAliases = [ "pd" ];
          urls = [ { template = "https://protondb.com/search?q={searchTerms}"; } ];
          icon = "https://protondb.com/sites/protondb/images/favicon.ico";
          inherit updateInterval;
        };

        "HowLongToBeat" = {
          definedAliases = [ "hltb" ];
          urls = [ { template = "https://howlongtobeat.com/?q={searchTerms}"; } ];
          icon = "https://howlongtobeat.com/img/icons/favicon-32x32.png";
          inherit updateInterval;
        };

      };
    };

  };

}
