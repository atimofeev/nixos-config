{ pkgs, ... }: {
  # FIX: enable fish in sudo
  programs = {
    kitty.shellIntegration.enableFishIntegration = true;
    starship.enableFishIntegration = true;
    fish = {
      enable = true;
      # TODO: add z or zoxide.fish
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
      shellAliases = {
        # NIX
        nix-rebuild-test =
          "sudo nixos-rebuild test --flake ~/repos/nixos-config#default";
        nix-rebuild-switch =
          "sudo nixos-rebuild switch --flake ~/repos/nixos-config#default";
        # WORK
        restart-vpn = "sudo systemctl restart openvpn-officeVPN.service";
        ssh = "TERM=xterm-256color command ssh";
        d = "docker";
        d-stop-all = "docker stop $(docker ps -q)";
        a = "ansible";
        t = "terraform";
        k = "kubectl";
        mk = "minikube";
        # EZA
        ls = "eza --color=always --group-directories-first";
        ll = "eza --long --color=always --group-directories-first";
        la = "eza --all --long --color=always --group-directories-first";
        ld =
          "eza --list-dirs --long --color=always --group-directories-first"; # show exact dir info
        lt =
          "eza --tree --level 2 --all --color=always --group-directories-first";
        # TODO: escape egrep quotes
        #l.="eza --all | egrep "^\.""; #show only dotfiles
        # BAT
        # TODO: set MANPAGER to bat
        #set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" # man pages -> bat
        #set -x MANROFFOPT -c # bat man pages formatting fix
        less = "bat --color=always --style=auto";
        cat = "bat --color=always --style=plain --paging=never";
        rg = "rg --color=always --ignore-case"; # ripgrep
        tb = "nc termbin.com 9999"; # [command] | tb
        nf = "neofetch --backend off --color_blocks off";
        chx = "chmod +x";
        # adding flags
        df =
          "df --human-readable --print-type --exclude-type=tmpfs --exclude-type=squashfs --exclude-type=devtmpfs --exclude-type=efivarfs";
        du = "du --human-readable";
        free = "free --human";
        mkdir = "mkdir --parents --verbose";
        # Colorize grep output (good for log files)
        grep = "grep --color=auto";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";
        # confirm before overwriting something
        cp = "cp --interactive";
        rm = "rm --interactive";
        #mv="mv --interactive";
      };
      # TODO: add these functions
      #
      # function touchx
      #     for file in $argv
      #         touch $file
      #         chmod +x $file
      #     end
      # end
      #
      # function dn
      #     $argv 2>/dev/null
      # end
      # TODO: how about famous archive extraction function?
      # TODO: add custom fzf functions 
    };
  };
}
