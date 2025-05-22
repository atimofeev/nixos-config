{ pkgs, config, ... }:
let
  gitSyncObsidian = pkgs.writeShellScriptBin "git-sync-obsidian" ''
    git add .
    git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" || true
    git pull --rebase origin main || true
    git push origin main
  '';
in
{

  home.packages = with pkgs; [ obsidian ];

  systemd.user = {

    services.git-sync-obsidian = {
      Unit.Description = "obsidian-vault sync with GitHub";
      Service = {
        Type = "simple";
        ExecStart = "${gitSyncObsidian}/bin/git-sync-obsidian";
        WorkingDirectory = "${config.home.homeDirectory}/repos/obsidian-vault";
      };
    };

    timers.git-sync-obsidian = {
      Unit.Description = "obsidian-vault sync with GitHub";
      Timer.OnCalendar = "hourly";
      Install.WantedBy = [ "timers.target" ];
    };

  };
}
