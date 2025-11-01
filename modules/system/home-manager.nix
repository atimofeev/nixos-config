{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.custom;
in
{
  imports = [ inputs.home-manager.nixosModules.default ];

  options.custom = {

    hm-users = lib.mkOption {
      default = null;
      type = lib.types.listOf lib.types.str;
    };

    hm-admin = lib.mkOption {
      default = lib.lists.elemAt cfg.hm-users 0;
      type = lib.types.str;
    };

  };

  config = lib.mkIf (cfg.hm-users != null) {

    home-manager = {
      extraSpecialArgs = { inherit inputs pkgs vars; };

      users = lib.attrsets.genAttrs cfg.hm-users (u: {

        imports = [
          (../../users + "/${u}") # import user options
          ../home # import hm modules
        ];

        programs.home-manager.enable = true;
        systemd.user.startServices = "sd-switch"; # reload system units on config update

        home = {
          username = u;
          homeDirectory = "/home/${u}";
          inherit (config.system) stateVersion;
        };

      });
    };
  };

}
