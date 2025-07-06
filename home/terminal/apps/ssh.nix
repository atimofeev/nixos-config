{ config, ... }:
{

  sops.secrets."work/ssh-config".path = "${config.home.homeDirectory}/.ssh/work_config";

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    serverAliveInterval = 10;
    includes = [ config.sops.secrets."work/ssh-config".path ];
  };

  services.ssh-agent.enable = true;

}
