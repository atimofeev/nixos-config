_: {
  security.sudo = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      runAs = "root";
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
