{
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    inputs.niri.homeModules.niri

    ./input.nix
    ./keybinds.nix
    ./layout.nix
    ./outputs.nix
    ./window-rules.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };

}
