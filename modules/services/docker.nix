{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.docker;
in
{

  options.custom.services.docker = {
    enable = lib.mkEnableOption "docker bundle";
    package = lib.mkPackageOption pkgs "docker" { };
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.custom.hm-admin}.extraGroups = [ "docker" ];

    virtualisation = {
      docker = {
        enable = true;
        inherit (cfg) package;
      };
      oci-containers.backend = "docker";
    };

    environment.systemPackages = with pkgs; [
      # TODO: move to root-less podman
      # podman-desktop
      # podman-compose
      # podman-tui
      docker-compose
      lazydocker
      dive
    ];
  };

}
