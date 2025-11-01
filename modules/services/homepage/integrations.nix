{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.services.homepage;
in
{

  config = lib.mkIf cfg.enable {

    programs.chromium.extraOpts = {
      HomepageIsNewTabPage = true;
      NewTabPageLocation = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";
    };

    home-manager.users.${config.custom.hm-admin}.programs.firefox.policies.Homepage = {
      URL = "localhost:${toString config.services.homepage-dashboard.listenPort}";
    };

  };

}
