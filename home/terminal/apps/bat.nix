{
  config,
  lib,
  pkgs,
  ...
}:
let
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

  commonAliases = {
    less = "bat --style=auto";
    cat = "bat --style=plain --paging=never";
    tail = "${tail}";
    head = "${head}";
  };
in
{
  programs = {

    bat.enable = true;

    bash = lib.mkIf config.programs.bash.enable { shellAliases = commonAliases; };
    fish = lib.mkIf config.programs.fish.enable { shellAliases = commonAliases; };
    nushell = lib.mkIf config.programs.nushell.enable { shellAliases = commonAliases; };
    zsh = lib.mkIf config.programs.zsh.enable { shellAliases = commonAliases; };
  };

}
