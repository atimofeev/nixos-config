{ inputs, config, vars, ... }: {
  imports = [
    ./gnome
    ./hyprland
    ./rofi
    ./terminal

    ./firefox.nix
    ./mpv.nix
    ./qbittorrent.nix
    ./swappy.nix
    ./vcv-rack.nix
    ./zathura.nix

    inputs.sops-nix.homeManagerModules.sops
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = vars.nix.stateVersion;
  programs.home-manager.enable = true;
  systemd.user.startServices =
    "sd-switch"; # reload system units on config update

  home = {
    inherit (vars) username;
    homeDirectory = "/home/${vars.username}";
  };

  manual.json.enable = true; # required for manix

  sops = {
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

}
