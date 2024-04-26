{ pkgs, ... }: {
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

        tail = ''
          set file $argv[1]   

          if set -q argv[2]
              set show $argv[2]
          else
              set show 10
          end

          set lines (wc -l < $file)
          set range (math "$lines - $show + 1")":"$lines

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
