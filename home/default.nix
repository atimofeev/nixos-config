{ inputs, config, vars, ... }: {
  imports = [
    ./desktop/hyprland
    # ./desktop/gnome

    ./terminal

    ./firefox.nix
    ./mpv.nix
    ./qbittorrent.nix
    ./swappy.nix
    ./vcv-rack.nix
    ./zathura.nix

    inputs.sops-nix.homeManagerModules.sops
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices =
    "sd-switch"; # reload system units on config update

  home = {
    inherit (vars.nix) stateVersion;
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
