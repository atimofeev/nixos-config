# NOTE: figure out config options
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.yubikey;
  pivProvider = "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
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

    environment.systemPackages = with pkgs; [
      pam_u2f
      yubico-piv-tool
      yubikey-manager
      yubioath-flutter
    ];

    programs.yubikey-touch-detector = {
      enable = cfg.yubikey-touch-detector;
      libnotify = true;
      unixSocket = false;
    };

    home-manager.users.${config.custom.hm-admin} = {
      custom-hm.user.shellAliases.yk-ssh-add = "${lib.getExe' pkgs.openssh "ssh-add"} -s ${pivProvider}";
      home.packages = [ pkgs.yubikey-touch-detector ]; # NOTE: required for icon in libnotify
      services.ssh-agent = {
        pkcs11Whitelist = [ "${pkgs.yubico-piv-tool}/lib/*" ];
        defaultMaximumIdentityLifetime = 8 * 60 * 60;
      };
    };

    # NOTE: https://github.com/max-baz/yubikey-touch-detector/issues/72
    systemd.user.services.yubikey-touch-detector.serviceConfig.StandardOutput = "null";

    services.pcscd.enable = true;

    security.pam = {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true;
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
