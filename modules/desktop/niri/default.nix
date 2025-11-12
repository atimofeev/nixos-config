{
  inputs,
  pkgs,
  vars,
  ...
}:
{

  # imports = [ inputs.niri.nixosModules.niri ];

  home-manager.users.${vars.username} = import ./config;

  # programs.niri = {
  #   enable = true;
  #   package = pkgs.niri;
  # };

}
