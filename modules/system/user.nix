{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.custom;
in
{

  programs.${vars.shell}.enable = true;
  users.users =
    lib.recursiveUpdate

      (lib.attrsets.genAttrs cfg.hm-users (u: {
        isNormalUser = true;
        description = u;
        shell = pkgs.${vars.shell};
      }))

      { "${cfg.hm-admin}".extraGroups = [ "wheel" ]; };

}
