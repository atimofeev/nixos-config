{

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults pwfeedback
      Defaults insults
    '';
    extraRules = [
      {
        groups = [ "wheel" ];
        runAs = "root";
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

}
