{ vars, ... }: {

  services.logrotate = {
    enable = true;
    settings = {
      "/home/${vars.username}/.local/state/nvim/*log" = {
        size = "25M";
        rotate = 4;
        compress = true;
        missingok = true;
        notifempty = true;
        copytruncate = true;
      };
    };
  };

}
