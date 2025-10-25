{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
let
  hostUsers = vars.hostUsers.${config.networking.hostName};
in
{

  imports = [ inputs.home-manager.nixosModules.default ];

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs pkgs vars; };
  #   users.${vars.username} = import ../../home;
  # };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs vars; };
    users = lib.attrsets.genAttrs hostUsers (u: {

      imports = [ (../../users + "/${u}") ];

      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch"; # reload system units on config update

      home = {
        username = u;
        homeDirectory = "/home/${u}";
        inherit (config.system) stateVersion;
      };

    });
  };

}
