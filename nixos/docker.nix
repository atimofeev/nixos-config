{ ... }: {
  virtualisation.docker.enable = true;
  # TODO: use global variable
  users.users.atimofeev.extraGroups = [ "docker" ];
}
