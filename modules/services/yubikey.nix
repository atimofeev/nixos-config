# NOTE: figure out config options
{
  pkgs,
  vars,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.services.yubikey;
in
{

  options.custom.services.yubikey = {
    enable = lib.mkEnableOption "yubikey bundle";
    yubikey-touch-detector = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "personal/yubico/u2f_keys" = {
        owner = vars.username;
        sopsFile = ../../secrets + "/${config.networking.hostName}.yaml";
      };
      "personal/ssh_keys/id_ed25519_sk" = {
        owner = vars.username;
        sopsFile = ../../secrets + "/${config.networking.hostName}.yaml";
        path = "/home/${vars.username}/.ssh/id_ed25519_sk";
      };
    };

    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      pam_u2f
    ];

    programs.yubikey-touch-detector = {
      enable = cfg.yubikey-touch-detector;
      libnotify = true;
      unixSocket = false;
    };
    # NOTE: required for icon in libnotify
    home-manager.users.${vars.username}.home.packages = [ pkgs.yubikey-touch-detector ];

    services.pcscd.enable = true;

    security.pam = {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true;
          authFile = config.sops.secrets."personal/yubico/u2f_keys".path;
          # debug = true;
        };
      };
      services = {
        login.u2fAuth = false;
        greetd.u2fAuth = false;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };
  };

}
