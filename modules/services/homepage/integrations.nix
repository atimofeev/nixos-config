{
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.custom.services.homepage;
in
{

  config = lib.mkIf cfg.enable {

    programs.chromium.extraOpts = {
      HomepageIsNewTabPage = true;
      # FIX:
      NewTabPageLocation = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";
    };

    home-manager.users.${vars.username}.programs.firefox.policies.Homepage = {
      URL = "localhost:${toString config.services.homepage-dashboard.listenPort}";
    };

  };

}
