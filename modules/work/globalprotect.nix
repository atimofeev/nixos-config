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
in
{

  options.custom.work.globalprotect = {
    enable = lib.mkEnableOption "GlobalProtect (gpclient) bundle";

    package = lib.mkPackageOption pkgs "gpclient" { };

    portal = lib.mkOption {
      type = lib.types.str;
      default = "$GP_PORTAL";
      description = "Portal hostname/url (default: env var GP_PORTAL from sops secret).";
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

      custom-hm.user.shellAliases = lib.mkIf (cfg.portal != null) {
        gp-start = "sudo -E gpclient connect --as-gateway --default-browser ${cfg.portal} &";
        gp-stop = "sudo pkill gpclient";
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
