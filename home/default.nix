{ inputs, vars, ... }: {
  imports = [
    ./gnome
    ./hyprland
    ./k9s
    ./nvim
    ./rofi

    ./bat.nix
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./htop.nix
    ./kitty.nix
    ./mpv.nix
    ./qbittorrent.nix
    ./spotify-player.nix
    ./ssh.nix
    ./starship.nix
    ./vcv-rack.nix
    ./yazi.nix
    ./zathura.nix
    ./zoxide.nix

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
    age.sshKeyPaths = [ "/home/${vars.username}/.ssh/id_ed25519" ];
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

}
