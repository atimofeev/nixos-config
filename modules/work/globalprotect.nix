{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.work.globalprotect;
  hmUser = config.custom.hm-admin;
  firefoxEnabled = config.custom-hm.applications.firefox.enable or false;

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
    enable = lib.mkEnableOption "GlobalProtect (gpclient) bundle";

    package = lib.mkPackageOption pkgs "gpclient" { };

    portal = lib.mkOption {
      type = lib.types.str;
      default = "$GP_PORTAL";
      description = "Portal hostname/url (default: env var GP_PORTAL).";
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      default = "$GP_GATEWAY";
      description = "Portal gateway (default: env var GP_GATEWAY).";
    };

    enableGnomeKeyring = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable gnome-keyring (fix Secure Storage not ready)";
    };

    fixBrowserCallback = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Register globalprotectcallback: protocol handler (Firefox prefs + XDG mime)";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages =
      (with pkgs; [
        cfg.package
        openconnect
      ])
      ++ (with pkgs; lib.optionals cfg.enableGnomeKeyring [ gnome-keyring ]);

    services.gnome.gnome-keyring = lib.mkIf cfg.enableGnomeKeyring {
      enable = lib.mkDefault true;
    };

    home-manager.users.${hmUser} = {

      custom-hm.user.shellAliases = lib.mkIf (cfg.portal != null) rec {
        gp-start = "sudo -E sh -c 'gpclient connect --default-browser --hip --csd-wrapper ${hipreportScript}/bin/hipreport.sh --gateway ${cfg.gateway} ${cfg.portal} > /dev/null 2> /tmp/gpclient-error.log &'";
        gp-stop = "sudo pkill -9 gpclient";
        gp-restart = "${gp-stop}; ${gp-start}";
      };

      # NOTE: https://github.com/yuezk/GlobalProtect-openconnect/issues/589
      # Firefox protocol handler for globalprotectcallback: URI.
      # After SAML auth, IdP redirects browser to globalprotectcallback:... URI.
      # Firefox must delegate this to gpclient (via gpgui.desktop).
      # Without this the SAML response never reaches gpclient → hangs after auth.
      programs.firefox = lib.mkIf (cfg.fixBrowserCallback && firefoxEnabled) {
        profiles.default.settings = {
          "network.protocol-handler.expose.globalprotectcallback" = false;
          "network.protocol-handler.external.globalprotectcallback" = true;
          "network.protocol-handler.warn-external.globalprotectcallback" = false;
        };
      };

      xdg.mimeApps = lib.mkIf (cfg.fixBrowserCallback && firefoxEnabled) {
        defaultApplications."x-scheme-handler/globalprotectcallback" = "gpgui.desktop";
      };

    };

  };
}
