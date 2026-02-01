{
  config,
  osConfig,
  ...
}:
{
  custom-hm.user.shellAliases = {
    # NIX
    r = "sudo nixos-rebuild test --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rd = "sudo nixos-rebuild dry-activate --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rs = "sudo nixos-rebuild switch --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    rb = "sudo nixos-rebuild boot --flake ~/repos/nixos-config#${osConfig.networking.hostName}";
    shell = "NIXPKGS_ALLOW_UNFREE=1 nix-shell --run $SHELL";
    v = config.custom-hm.user.editor;
    flake-update = ''nix flake metadata --json | jq --raw-output ".locks.nodes.root.inputs | keys[]" | fzf | xargs nix flake update'';

    # MISC
    icat = "kitty +kitten icat";
    fd = "fd --hidden";
    rg = "rg --color=always";
    tb = "nc termbin.com 9999"; # [command] | tb
    nf = "neofetch --backend off --color_blocks off";
    chx = "chmod +x";

    # WORK
    d = "docker";
    dc = "docker-compose";
    t = "tofu";
    k = "kubectl";
    mk = "minikube";
    kx = "kubie ctx";
    kn = "kubie ns";

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

    # systemctl
    sc = "systemctl";
    scs = "systemctl status";
    scr = "systemctl restart";
    scc = "systemctl cat";
    scu = "systemctl --user";
    scsu = "systemctl status --user";
    scru = "systemctl restart --user";
    sccu = "systemctl cat --user";
  };

  programs.fish.shellAliases = {
    unset = "set -e";
  };

}
