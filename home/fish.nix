{ pkgs, ... }: {
  # FIX: enable fish in sudo
  programs = {
    starship.enableFishIntegration = true;
    # FIX: not working
    fzf.enableFishIntegration = true;
    fish = {
      enable = true;
      # FIX: none of these are working properly
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z;
        }
        {
          name = "puffer-fish";
          src = pkgs.fishPlugins.puffer;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf;
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
        ll = "eza -l --color=always --group-directories-first";
        la = "eza --all -l --color=always --group-directories-first";
        ld =
          "eza --list-dirs -l --color=always --group-directories-first"; # show exact dir info
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
        # RIPGREP
        rg = "rg --color=always --ignore-case";
        # ---
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
    };
  };
}
