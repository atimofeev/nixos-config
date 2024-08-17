{ pkgs, vars, ... }: {
  users.users.${vars.username}.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # TODO: move to root-less podman
    # podman-desktop
    # podman-compose
    # podman-tui 
    docker-compose
    dive
  ];

}
