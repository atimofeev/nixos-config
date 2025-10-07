{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.custom.services.docker;
in
{

  options.custom.services.docker = {
    enable = lib.mkEnableOption "docker bundle";
  };

  config = lib.mkIf cfg.enable {
    users.users.${vars.username}.extraGroups = [ "docker" ];

    virtualisation = {
      docker.enable = true;
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
