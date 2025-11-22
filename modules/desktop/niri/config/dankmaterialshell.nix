{ pkgs, inputs, ... }:
{

  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  programs.dankMaterialShell = {
    enable = true;
    niri = {
      # enableKeybinds = true; # Automatic keybinding configuration
      enableSpawn = true; # Auto-start DMS with niri
    };
    quickshell.package = pkgs.unstable.quickshell;
  };

  systemd.user.services.niri-flake-polkit.enable = false;

}
