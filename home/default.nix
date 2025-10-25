{
  osConfig,
  vars,
  ...
}:
{

  imports = [

    ./terminal
    ./firefox

    ./mpv.nix
    ./nix-index.nix
    ./obsidian.nix
    ./qbittorrent.nix
    ./slack.nix
    ./sops.nix
    ./swappy.nix
    ./vcv-rack.nix
    ./zathura.nix
    ./zen-browser.nix

  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch"; # reload system units on config update

  home = {
    inherit (osConfig.system) stateVersion;
    inherit (vars) username;
    homeDirectory = "/home/${vars.username}";
  };

}
