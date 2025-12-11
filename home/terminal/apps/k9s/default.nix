{ pkgs, ... }:
{

  imports = [ ./plugins ];

  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;

    aliases = {
      cr = "clusterrole";
      crb = "clusterrolebinding";
      de = "deployment";
      dp = "deployment";
      rb = "rolebinding";
      sec = "secrets";
    };
  };

}
