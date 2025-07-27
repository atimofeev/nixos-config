{ pkgs, vars, ... }:
{

  programs.${vars.shell}.enable = true;
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    extraGroups = [ "wheel" ];
    shell = pkgs.${vars.shell};
  };

}
