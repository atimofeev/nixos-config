{ pkgs, ... }:
{

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "5d3cb25e0d63356c3342fb3101810799bb651b64";
          sha256 = "sha256-aPxEHSXfiJJXosIm7b3Pd+yFnyz43W3GXyUB5BFAF54=";
        };
      }
    ];

    functions = {

      fish_user_key_bindings = # fish
        ''
          bind \cf fg # Ctrl-f - `fg`
        '';

      # touchx = # fish
      #   ''
      #     for file in $argv
      #         touch $file
      #         chmod +x $file
      #     end
      #   '';

      # dn = "$argv 2>/dev/null";

      # ex = # fish
      #   ''
      #     if not test -f "$argv[1]"
      #         echo "'$argv[1]' is not a valid file"
      #         return
      #     end
      #
      #     switch "$argv[1]"
      #         case '*.tar.bz2' '*.tbz2'
      #             tar xjf $argv[1]
      #         case '*.tar.gz' '*.tgz'
      #             tar xzf $argv[1]
      #         case '*.bz2'
      #             bunzip2 $argv[1]
      #         case '*.rar'
      #             unrar x $argv[1]
      #         case '*.gz'
      #             gunzip $argv[1]
      #         case '*.tar'
      #             tar xf $argv[1]
      #         case '*.zip'
      #             unzip $argv[1]
      #         case '*.Z'
      #             uncompress $argv[1]
      #         case '*.7z'
      #             7z x $argv[1]
      #         case '*.tar.xz'
      #             tar -Jxf $argv[1]
      #         case '*.tar.zst'
      #             unzstd $argv[1]
      #         case '*'
      #             echo "'$argv[1]' cannot be extracted via ex()"
      #     end
      #   '';

    };

    # TODO: add custom fzf functions
  };

  home.sessionVariables.fish_greeting = "";
}
