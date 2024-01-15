{ ... }: {
  virtualisation.docker.enable = true;
  # TODO: username: use global variable
  users.users.atimofeev.extraGroups = [ "docker" ];
}
