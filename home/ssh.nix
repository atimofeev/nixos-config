{ config, vars, ... }: {

  sops.secrets."work/ssh-config".path =
    "/home/${vars.username}/.ssh/work_config";

  programs.ssh = {
    enable = true;
    includes = [ config.sops.secrets."work/ssh-config".path ];
  };
}
