{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  hostUsers = vars.hostUsers.${config.networking.hostName};
in
{

  programs.${vars.shell}.enable = true;
  users.users = lib.attrsets.genAttrs hostUsers (u: {
    isNormalUser = true;
    description = u;
    extraGroups = [ "wheel" ];
    shell = pkgs.${vars.shell};
  });

}
