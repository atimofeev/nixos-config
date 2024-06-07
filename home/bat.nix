{ pkgs, ... }:
let
  # HACK: bat won't implement negative line range
  # https://github.com/sharkdp/bat/issues/791
  # https://github.com/sharkdp/bat/issues/2944
  # Wrapper to gain tail-like functionality
  tail = pkgs.pkgs.writeShellScriptBin "tail" ''
    #!/usr/bin/env bash
    file="$1"
    show="$2"

    if [ -z "$2" ]; then
        show=10
    fi

    lines=$(wc -l < "$file")
    range="$lines:-$((show - 1))"

    exec bat "$file" --color=always --style=plain --paging=never --line-range "$range"
  '';
in {
  programs = {

    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = {
          file = "themes/Catppuccin Macchiato.tmTheme";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "0ce3d34921ba1b544a4d82aa01352abd553d51ef";
            sha256 = "sha256-PLbTLj0qhsDj+xm+OML/AQsfRQVPXLYQNEPllgKcEx4=";
          };
        };
      };
    };

    fish = {
      shellAliases = {
        less = "bat --color=always --style=auto";
        cat = "bat --color=always --style=plain --paging=never";
        tail = "${tail}/bin/tail";
      };
      functions = {
        head = ''
          set file $argv[1]

          if set -q argv[2]
              set show $argv[2]
          else
              set show 10
          end

          set range "1:"$show

          bat $file --color=always --style=plain --paging=never --line-range $range
        '';
      };
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };
}
