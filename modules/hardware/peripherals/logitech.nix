{ pkgs, ... }: {

  # NOTE: nixos module will be merged in 
  # https://github.com/NixOS/nixpkgs/pull/287399

  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    startLimitIntervalSec = 0;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      User = "root";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ pkgs.logiops ];
  };

  environment.etc."logid.cfg".text = # c
    ''
      devices: ({
        name: "Wireless Mouse MX Master 3S";

        smartshift: { on: true; threshold: 25; };

        hiresscroll: { hires: true; invert: false; target: false; };

        dpi: 1500;

        // buttons: (
        //
        //   // Make thumb button 10.
        //   { cid: 0x53; action = { type: "Keypress"; keys: ["KEY_FORWARD"]; }; },
        //
        //   // Make top button 11.
        //   { cid: 0x56; action = { type: "Keypress"; keys: ["KEY_BACK"];    }; }
        //
        // );
        
      });
    '';

}
