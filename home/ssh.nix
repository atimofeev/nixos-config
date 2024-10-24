{ config, ... }: {

  sops.secrets."work/ssh-config".path =
    "${config.home.homeDirectory}/.ssh/work_config";

  programs.ssh = {
    enable = true;
    includes = [ config.sops.secrets."work/ssh-config".path ];
  };
}
