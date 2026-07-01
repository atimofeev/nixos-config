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

  programs.fish = {
    shellAliases = {
      unset = "set -e";
    };

    functions = {
      ar = ''
        set region (printf "%s\n" \
          us-east-1 us-east-2 us-west-1 us-west-2 \
          eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 eu-south-1 \
          ap-south-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 ap-northeast-2 ap-northeast-3 \
          ap-east-1 ap-south-2 \
          sa-east-1 ca-central-1 af-south-1 me-south-1 me-central-1 | fzf)
        if test -n "$region"
          set -gx AWS_REGION $region
          set -gx AWS_DEFAULT_REGION $region
        end
      '';

      ax = ''
        set profile (awsx list 2>&1 | grep 'aws=' | awk '{print $1}' | fzf)
        if test -n "$profile"
          awsx use $profile | source
        end
      '';
    };
  };
}
