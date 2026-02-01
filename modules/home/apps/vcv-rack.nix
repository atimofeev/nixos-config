{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.vcv-rack;

  vcv-config-source = pkgs.writeShellScript "source" ''
    rm -rf $HOME/.local/share/Rack2
    ln -s $HOME/repos/vcv-rack2-settings/ $HOME/.local/share/Rack2
    ln -s $HOME/repos/vcv-rack2-patches/ $HOME/.local/share/Rack2/patches
  '';
in
{

  options.custom-hm.applications.vcv-rack = {
    enable = lib.mkEnableOption "vcv-rack bundle";
    package = lib.mkPackageOption pkgs "vcv-rack" { };
  };

  config = lib.mkIf cfg.enable {
    custom-hm.user.shellAliases.vcv-config-source = "${vcv-config-source}";
    home.packages = [ cfg.package ];
  };

}
