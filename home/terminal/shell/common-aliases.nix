{ lib, config, osConfig, ... }:
let
  commonAliases = {
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
    dc = "docker-compose";
    t = "tofu";
    k = "kubectl";
    mk = "minikube";
    # FIX: https://github.com/sbstp/kubie/issues/123
    # kx = "kubie ctx; k9s";
    kx = "kubie ctx";
    kn = "kubie ns";

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
in {

  programs = {
    nushell =
      lib.mkIf config.programs.nushell.enable { shellAliases = commonAliases; };
    fish =
      lib.mkIf config.programs.fish.enable { shellAliases = commonAliases; };
    bash =
      lib.mkIf config.programs.bash.enable { shellAliases = commonAliases; };
    zsh = lib.mkIf config.programs.zsh.enable { shellAliases = commonAliases; };
  };

}
