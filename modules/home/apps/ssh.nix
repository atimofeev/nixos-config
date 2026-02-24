{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.ssh;
in
{

  options.custom-hm.applications.ssh = {
    enable = lib.mkEnableOption "ssh bundle";
    package = lib.mkPackageOption pkgs "openssh" { };
    agent = lib.mkEnableOption "Wether to enable ssh-agent";
    ssh-add-on-boot = lib.mkEnableOption "Wether to enable ssh-add service on boot";
  };

  config = lib.mkIf cfg.enable {

    programs.ssh = {
      enable = true;
      inherit (cfg) package;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
        serverAliveInterval = 3;
      };
    };

    services.ssh-agent.enable = true;

    systemd.user.services.ssh-add = {
      Unit = {
        Description = "Add SSH keys to the agent";
        After = "ssh-agent.service";
        PartOf = "graphical-session.target";
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe' pkgs.openssh "ssh-add";
        RemainAfterExit = false;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

  };

}
