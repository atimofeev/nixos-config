{ pkgs, vars, ... }:
{

  imports = [
    # ./gns3.nix # NOTE: probably still broken
    # ./vm.nix
    ./ansible.nix
    ./cato.nix
    ./jira.nix
    ./k8s.nix
    ./nitrokey.nix
    ./tofu.nix
    ./vpn.nix
  ];

  environment.systemPackages = with pkgs; [
    # langs
    nodejs_18
    python3

    # cli tools
    awscli2
    cloudlens
    dig
    lazysql
    nettools
    pgcli
    pwgen
    vault
    vault-kv-mv

    # communication
    slack
    zoom-us
  ];

  # fix for WPA2-Enterprise PEAP
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
    [system_default_sect]
    CipherString = Default:@SECLEVEL=0
  '';

  sops.secrets."work/aws-creds" = {
    owner = vars.username;
    path = "/home/${vars.username}/.aws/credentials";
  };

}
