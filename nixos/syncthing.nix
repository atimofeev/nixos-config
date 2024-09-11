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
          "5PBOCJM-4TCDB6V-XW6NI46-ANC7KNU-PT5LCC2-NW6EL6S-KW5L3NF-ZDJF5AU";
      };

      folders = {
        obsidian-vault = {
          path = "/home/${vars.username}/obsidian-vault";
          devices = [ "milaptop" "Pixel 5a" ];
          ignorePerms = true;
          # copyOwnershipFromParent = true;
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
