{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.bat;

  tail = pkgs.writeShellScript "tail" ''
    file="$1"
    show="$2"

    if [ -z "$2" ]; then
        show=10
    fi

    lines=$(wc -l < "$file")
    range="$lines:-$((show - 1))"

    exec bat "$file" --style=plain --paging=never --line-range "$range"'';

  head = pkgs.writeShellScript "head" ''
    file="$1"
    show="$2"

    if [ -z "$2" ]; then
        show=10
    fi

    exec bat "$file" --style=plain --paging=never --line-range 1:"$show"'';

in
{

  options.custom-hm.applications.bat = {
    enable = lib.mkEnableOption "bat bundle";
    package = lib.mkPackageOption pkgs "bat" { };
  };

  config = lib.mkIf cfg.enable {

    programs.bat = {
      enable = true;
      inherit (cfg) package;
    };

    custom-hm.user.shellAliases = {
      less = "bat --style=auto";
      cat = "bat --style=plain --paging=never";
      tail = "${tail}";
      head = "${head}";
    };

  };

}
