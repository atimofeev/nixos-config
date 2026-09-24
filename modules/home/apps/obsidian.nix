{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.obsidian;

  gitSyncObsidian = pkgs.writeShellScript "git-sync-obsidian" ''
    set -euo pipefail

    cd "${config.home.homeDirectory}/repos/obsidian-vault"

    jj="${pkgs.jujutsu}/bin/jj"
    git="${pkgs.git}/bin/git"
    message="$(date '+%Y-%m-%d %H:%M:%S')"

    if [ -d .jj ]; then
      # jj owns working-copy state in native and colocated repositories.
      "$jj" git fetch --remote origin

      if ! "$jj" diff --quiet; then
        "$jj" commit -m "$message"
      fi

      # jj commit leaves a new empty working-copy commit; publish its parent.
      "$jj" bookmark set main --revision @-
      "$jj" git push --remote origin --bookmark main
    else
      "$git" add -A

      if ! "$git" diff --cached --quiet; then
        "$git" commit -m "$message"
      fi

      "$git" pull --rebase --autostash origin main
      "$git" push origin main
    fi'';

in
{

  options.custom-hm.applications.obsidian = {
    enable = lib.mkEnableOption "obsidian bundle";
    package = lib.mkPackageOption pkgs "obsidian" { };
  };

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    # TODO: configure
    # https://home-manager-options.extranix.com/?query=obsidian&release=release-25.11
    # https://github.com/RandomNEET/nixos/blob/b0f78c396d759e88f13dddead4a2e6d507cbe4a7/modules/programs/gui/obsidian/default.nix

    programs.obsidian = {
      enable = true;
      inherit (cfg) package;
      vaults = {
        main = {
          target = "repos/obsidian-vault";
        };
        # orgroam_to_obsidian = {
        #   target = "repos/orgroam_to_obsidian/output";
        # };
      };
    };

    systemd.user = {

      services.git-sync-obsidian = {
        Unit.Description = "obsidian-vault sync with GitHub";
        Service = {
          Type = "simple";
          ExecStart = gitSyncObsidian;
          WorkingDirectory = "${config.home.homeDirectory}/repos/obsidian-vault";
        };
      };

      timers.git-sync-obsidian = {
        Unit.Description = "obsidian-vault sync with GitHub";
        Timer.OnCalendar = "hourly";
        Install.WantedBy = [ "timers.target" ];
      };

    };

  };

}
