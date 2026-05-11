{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.pi-coding-agent;
  system_prompt = ''
    Terse like caveman. Technical substance exact. Only fluff die.
    Drop: articles, filler (just/really/basically), pleasantries, hedging.
    Fragments OK. Short synonyms. Code unchanged.
    Pattern: [thing] [action] [reason]. [next step].
    ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
    Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".

    Git commands only on request.

    Call subagents when makes sense.

    You're on nixos host. You can use `nix run nixpkgs#app -- <args>` to run any app, if it's missing in current shell
  '';
in
{

  options.custom-hm.applications.pi-coding-agent = {
    enable = lib.mkEnableOption "pi-coding-agent bundle";
    package = lib.mkPackageOption pkgs "pi-coding-agent" { };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];
      file = {
        ".pi/agent/SYSTEM.md".text = system_prompt;
      };
    };
  };

}
