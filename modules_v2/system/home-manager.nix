{
  inputs,
  pkgs,
  vars,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs vars; };
    users.${vars.username} = import ../../home;
  };

}
