{ inputs, pkgs, libx, vars, hostname, ... }: {

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs libx vars hostname; };
    users.${vars.username} = import ../../home;
  };

}
