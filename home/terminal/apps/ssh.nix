{ pkgs, config, ... }:
{

  sops.secrets."work/ssh-config".path = "${config.home.homeDirectory}/.ssh/work_config";

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    serverAliveInterval = 10;
    includes = [ config.sops.secrets."work/ssh-config".path ];
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
      ExecStart = "${pkgs.openssh}/bin/ssh-add";
      RemainAfterExit = false;
    };
  };

}
