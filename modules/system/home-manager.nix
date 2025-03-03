{ inputs, pkgs, libx, vars, ... }: {

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs libx vars; };
    users.${vars.username} = import ../../home;
  };

}
