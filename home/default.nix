{ vars, ... }:
{

  imports = [

    ./terminal

    ./firefox.nix
    ./mpv.nix
    ./nix-index.nix
    ./obsidian.nix
    ./qbittorrent.nix
    ./slack.nix
    ./sops.nix
    ./swappy.nix
    ./vcv-rack.nix
    ./zathura.nix

  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch"; # reload system units on config update

  home = {
    inherit (vars.nix) stateVersion;
    inherit (vars) username;
    homeDirectory = "/home/${vars.username}";
  };

}
