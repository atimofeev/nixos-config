{
  config,
  lib,
  pkgs,
  ...
}:
{

  sops.secrets."work/ssh-config" = { };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ config.sops.secrets."work/ssh-config".path ];
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

}
