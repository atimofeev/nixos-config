{ pkgs, vars, ... }: {

  services.syncthing = {
    enable = true;
    user = vars.username;
    settings = {
      options = { urAccepted = -1; };

      devices = {
        milaptop.id =
          "GXF4VCC-3CL7DLT-L7MPYAZ-XU5BM6G-TIKPIVA-WGMNH3B-MMRO3Z2-KF6X2AF";
        "Pixel 5a".id =
          "6TLETF7-HMGU76V-M5SN43R-ZCHPQX7-KDJGIHM-VVXHQ3H-BXWDFJN-7LPKRA3";
        steamdeck.id =
          "AIATXVS-TQHLJRC-TTJLPNX-V2X45YE-ZGRERKG-ITMJKMT-FBNPCQL-MMXAQQ4";
      };

      folders = {
        obsidian-vault = {
          path = "/home/${vars.username}/repos/obsidian-vault";
          devices = [ "milaptop" "Pixel 5a" ];
          ignorePerms = true;
        };
        retrodeck = {
          path = "/home/${vars.username}/retrodeck";
          devices = [ "steamdeck" ];
          ignorePerms = true;
        };
      };

    };
  };

  systemd.services.setAclForSyncthing = {
    description = "Set ACLs for Syncthing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.acl}/bin/setfacl -R -m u:${vars.username}:rwx /var/lib/syncthing/";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

}
