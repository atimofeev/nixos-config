{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom;
in
{

  options.custom.user-shell = lib.mkOption {
    default = "fish";
    type = lib.types.str;
  };

  config = {

    programs.${cfg.user-shell}.enable = true;
    users.users =
      lib.recursiveUpdate

        (lib.attrsets.genAttrs cfg.hm-users (u: {
          isNormalUser = true;
          description = u;
          shell = pkgs.${cfg.user-shell};
        }))

        { "${cfg.hm-admin}".extraGroups = [ "wheel" ]; };

  };
}
