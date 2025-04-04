{ pkgs, osConfig, ... }: {
  programs = {

    kitty.shellIntegration.enableFishIntegration = false;
    yazi.enableFishIntegration = false;
    carapace.enableFishIntegration = false;

    zoxide.enableFishIntegration = true;
    starship = {
      enableFishIntegration = true;
      enableTransience = true;
    };

    fish = {
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

      shellAliases = {
        # NIX
        r =
          "sudo nixos-rebuild test --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
        rd =
          "sudo nixos-rebuild dry-activate --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
        rs =
          "sudo nixos-rebuild switch --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
        rb =
          "sudo nixos-rebuild boot --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
        shell = "NIXPKGS_ALLOW_UNFREE=1 nix-shell --run $SHELL";
        v = "nix run ~/repos/nixvim-config/";
        sops-secrets = "sops ~/repos/nixos-config/secrets/secrets.yaml";
        flake-update = ''
          nix flake metadata --json | jq --raw-output ".locks.nodes.root.inputs[]" | fzf | xargs nix flake lock --update-input'';

        # MISC
        icat = "kitty +kitten icat";
        fd = "fd --hidden";
        rg = "rg --color=always";
        tb = "nc termbin.com 9999"; # [command] | tb
        nf = "neofetch --backend off --color_blocks off";
        chx = "chmod +x";
        ip = "ip -4 a";

        # WORK
        vpn-stop = "sudo systemctl stop openvpn-officeVPN.service";
        vpn-restart = "sudo systemctl restart openvpn-officeVPN.service";
        vpn-status = "systemctl status openvpn-officeVPN.service";
        d = "docker";
        d-stop-all = "docker stop $(docker ps -q)";
        d-img-del-all = "docker rmi $(docker images -aq) --force";
        dc = "docker-compose";
        t = "tofu";
        k = "kubectl";
        mk = "minikube";
        # FIX: https://github.com/sbstp/kubie/issues/123
        # kx = "kubie ctx; k9s";
        kx = "kubie ctx";
        kn = "kubie ns";

        # EZA
        ls = "eza --color=always --group-directories-first";
        ll = "eza --long --color=always --group-directories-first";
        la = "eza --all --long --color=always --group-directories-first";
        ld =
          "eza --list-dirs --long --color=always --group-directories-first"; # show exact dir info
        lt =
          "eza --tree --level 2 --all --color=always --group-directories-first";
        "l." = ''eza --all | egrep "^\."''; # show only dotfiles

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
        # mv="mv --interactive";
      };

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
  };

  home.sessionVariables.fish_greeting = "";
}
