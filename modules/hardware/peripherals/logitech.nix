{ pkgs, ... }:
{

  # NOTE: nixos module will be merged in
  # https://github.com/NixOS/nixpkgs/pull/287399

  # FIX: causes SHIFT & SUPER KB keys to be always active
  # possible due to some conflict with xremap

  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    documentation = [ "https://github.com/PixlOne/logiops" ];
    wantedBy = [ "multi-user.target" ];
    startLimitIntervalSec = 0;
    after = [ "multi-user.target" ];
    wants = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "always";
      User = "root";
      RuntimeDirectory = "logiops";
      CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
      DeviceAllow = [
        "/dev/uinput rw"
        "char-hidraw rw"
      ];
      ProtectClock = true;
      PrivateNetwork = true;
      ProtectHome = true;
      ProtectHostname = true;
      PrivateUsers = true;
      PrivateMounts = true;
      PrivateTmp = true;
      RestrictNamespaces = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      LockPersonality = true;
      ProtectProc = "invisible";
      SystemCallFilter = [
        "nice"
        "@system-service"
        "~@privileged"
      ];
      RestrictAddressFamilies = [
        "AF_NETLINK"
        "AF_UNIX"
      ];
      RestrictSUIDSGID = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProcSubset = "pid";
      UMask = "0077";
    };
  };

  # Add a `udev` rule to restart `logiops` when the mouse is connected
  # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="input", ATTRS{id/vendor}=="046d", RUN{program}="${pkgs.systemd}/bin/systemctl --no-block try-restart logiops.service"
  '';

  # NOTE: arch wiki
  # https://wiki.archlinux.org/title/Logitech_MX_Master

  environment.etc."logid.cfg".text = # c
    ''
      devices: ({
        name: "Wireless Mouse MX Master 3S";

        smartshift: { 
          on: true; 
          threshold: 25; 
          torque: 50;
        };

        hiresscroll: { 
          hires: true; 
          invert: false; 
          target: false; 
        };

        dpi: 1500;

        thumbwheel: {
          divert: true;
          invert: false;
          left: {
            mode: "OnInterval";
            interval: 2;
            action: {
              type: "Keypress";
              keys: ["KEY_VOLUMEDOWN"];
            };
          };
          right: {
            mode: "OnInterval";
            interval: 2;
            action: {
              type: "Keypress";
              keys: ["KEY_VOLUMEUP"];
            };
          };
          tap: {
            type: "Keypress";
            keys: ["KEY_MUTE"];
          };
        };

        buttons: (
          // top button
          { cid: 0xc4; action = { type = "ToggleSmartshift"; }; },
        );
        
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
