{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.globalprotect;
  hmUser = config.custom.hm-admin;

  # HIP report script for GlobalProtect CSD (Host Information Profile).
  # openconnect invokes this as --csd-wrapper to generate the HIP XML report
  # required by GlobalProtect gateways for host posture assessment.
  # Source: https://gitlab.com/openconnect/openconnect/-/blob/master/trojans/hipreport.sh
  hipreportScript =
    pkgs.runCommand "hipreport"
      {
        src = pkgs.fetchFromGitLab {
          owner = "openconnect";
          repo = "openconnect";
          rev = "a7e751442e0e4bb8e3f18965960b1428e1a26bbc";
          hash = "sha256-OV5LMTV3NqSASChelVh5Hpw+ZnuJ89FPLkGTCej2j4w=";
        };
      }
      ''
        mkdir -p $out/bin
        install -m755 $src/trojans/hipreport.sh $out/bin/hipreport.sh
        patchShebangs $out/bin/hipreport.sh
      '';
in
{
  options.custom.work.globalprotect = {
    enable = lib.mkEnableOption "GlobalProtect VPN (NM + DMS)";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gnome-keyring
      gp-saml-gui
      openconnect
    ];

    services.gnome.gnome-keyring = {
      enable = true;
    };

    networking.networkmanager = {

      plugins = [
        pkgs.networkmanager-openconnect
      ];

      ensureProfiles = {

        profiles."GlobalProtect" = {
          connection = {
            id = "GlobalProtect";
            type = "vpn";
            autoconnect = false;
            permissions = "user:${hmUser}:";
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            protocol = "gp";
            gateway = "$GP_PORTAL";
            csd-wrapper = "${hipreportScript}/bin/hipreport.sh";
            enable-csd-trojan = "yes";
          };
          ipv4 = {
            method = "auto";
          };
        };
      };

    };

  };
}
