{
  pkgs,
  lib,
  config,
  osConfig,
  vars,
  ...
}:
let
  commonAliases = {
    # NIX
    r = "sudo nixos-rebuild test --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rd = "sudo nixos-rebuild dry-activate --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rs = "sudo nixos-rebuild switch --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rb = "sudo nixos-rebuild boot --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    shell = "NIXPKGS_ALLOW_UNFREE=1 nix-shell --run $SHELL";
    v = vars.terminal.editor;
    sops-secrets = "sops ~/repos/nixos-config/secrets/secrets.yaml";
    flake-update = ''nix flake metadata --json | jq --raw-output ".locks.nodes.root.inputs[]" | fzf | xargs nix flake lock --update-input'';

    # MISC
    icat = "kitty +kitten icat";
    fd = "fd --hidden";
    rg = "rg --color=always";
    tb = "nc termbin.com 9999"; # [command] | tb
    nf = "neofetch --backend off --color_blocks off";
    chx = "chmod +x";

    # WORK
    vpn-stop = "sudo systemctl stop openvpn-officeVPN.service";
    vpn-restart = "sudo systemctl restart openvpn-officeVPN.service";
    vpn-status = "systemctl status openvpn-officeVPN.service";
    d = "docker";
    dc = "docker-compose";
    t = "tofu";
    k = "kubectl";
    mk = "minikube";
    kx = "kubie ctx";
    kn = "kubie ns";

    # hyprland
    sunrise = "${lib.getExe' pkgs.hyprland "hyprctl"} hyprsunset temperature 6500";
    sunset = "${lib.getExe' pkgs.hyprland "hyprctl"} hyprsunset temperature 4500";

    # adding flags
    df = "df --human-readable --print-type --exclude-type=tmpfs --exclude-type=squashfs --exclude-type=devtmpfs --exclude-type=efivarfs";
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

    # git
    gs = "git status --short";
    gd = "git diff";
    ga = "git add";
    gap = "git add --patch";
    gc = "git commit";
    gp = "git push";
    gP = "git pull";
    gl = "git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'";
    gb = "git branch";
    gi = "git init";
    gcl = "git clone";
  };
  fishAliases = {
    unset = "set -e";
  };
in
{

  programs = {
    bash = lib.mkIf config.programs.bash.enable { shellAliases = commonAliases; };
    fish = lib.mkIf config.programs.fish.enable {
      shellAliases = commonAliases // fishAliases;
    };
    nushell = lib.mkIf config.programs.nushell.enable {
      shellAliases = lib.attrsets.removeAttrs commonAliases [
        "shell"
        "du"
        "mkdir"
      ];
    };
    zsh = lib.mkIf config.programs.zsh.enable { shellAliases = commonAliases; };
  };

}
