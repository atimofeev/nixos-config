{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.obsidian;

  gitSyncObsidian = pkgs.writeShellScript "git-sync-obsidian" ''
    git add .
    git commit -m "$(date '+%Y-%m-%d %H:%M:%S')" || true
    git pull --rebase origin main || true
    git push origin main'';

in
{

  options.custom-hm.applications.obsidian = {
    enable = lib.mkEnableOption "obsidian bundle";
    package = lib.mkPackageOption pkgs "obsidian" { };
  };

  config = lib.mkIf cfg.enable {

    # TODO: configre
    # https://home-manager-options.extranix.com/?query=obsidian&release=release-25.11
    # https://github.com/RandomNEET/nixos/blob/b0f78c396d759e88f13dddead4a2e6d507cbe4a7/modules/programs/gui/obsidian/default.nix
    # https://github.com/RandomNEET/nixos/blob/b0f78c396d759e88f13dddead4a2e6d507cbe4a7/pkgs/obsidian-catppuccin/default.nix
    programs.obsidian = {
      enable = true;
      inherit (cfg) package;
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
