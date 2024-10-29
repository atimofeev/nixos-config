{ pkgs, inputs, ... }: {
  # TODO: setup
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprsunset/
  # NOTE:
  # home-manager implementation
  # https://github.com/nix-community/home-manager/issues/5983

  home.packages = [ inputs.hyprsunset.packages.${pkgs.system}.default ];

}
