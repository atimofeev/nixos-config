{ pkgs, ... }:
let
  vcv-config-source = pkgs.pkgs.writeShellScriptBin "source" ''
    rm -rf $HOME/.local/share/Rack2
    ln -s $HOME/repos/vcv-rack2-settings/ $HOME/.local/share/Rack2
    ln -s $HOME/repos/vcv-rack2-patches/ $HOME/.local/share/Rack2/patches
  '';
in
{
  programs.fish.shellAliases.vcv-config-source = "${vcv-config-source}/bin/source";
  home.packages = [ pkgs.vcv-rack ];

  # TODO: add check for existing repos
  # git clone git@github.com:atimofeev/vcv-rack2-settings.git $HOME/repos/vcv-rack2-settings/
  # git clone git@github.com:atimofeev/vcv-rack2-patches.git $HOME/repos/vcv-rack2-patches/
}
