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
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "personal/yubico/u2f_keys" = {
        owner = vars.username;
        path = "/home/${vars.username}/.config/Yubico/u2f_keys";
      };
      "personal/ssh_keys/yubikey_home" = {
        owner = vars.username;
        path = "/home/${vars.username}/.ssh/id_yubikey_home";
      };
    };

    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      pam_u2f
    ];

    services.pcscd.enable = true;

    security.pam = {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true;
          authFile = "/home/${vars.username}/.config/Yubico/u2f_keys";
          # debug = true;
        };
      };
      services = {
        login.u2fAuth = false;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };
  };

}
