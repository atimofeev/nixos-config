{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    coreutils
    util-linux
    curl
    wget
    jq
    nmap
    unzip
    file
    bc

    # improved utils
    fd # find
    ripgrep # grep
    eza # ls
    htop # top
  ];
}
