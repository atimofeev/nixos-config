{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.opencode;
in
{

  options.custom-hm.applications.opencode = {
    enable = lib.mkEnableOption "opencode plugin";
    package = lib.mkPackageOption pkgs "opencode" { };
    enableMcpIntegration = lib.mkOption {
      default = config.custom-hm.applications.mcp.enable;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      inherit (cfg) package;
      inherit (cfg) enableMcpIntegration;
      rules = ''
        Terse like caveman. Technical substance exact. Only fluff die.
        Drop: articles, filler (just/really/basically), pleasantries, hedging.
        Fragments OK. Short synonyms. Code unchanged.
        Pattern: [thing] [action] [reason]. [next step].
        ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
        Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".

        Only use git commands when explicitly requested
      '';
    };
  };

}
