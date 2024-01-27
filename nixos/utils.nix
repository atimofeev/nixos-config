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

    # improved utils
    fd # find
    ripgrep # grep
    eza # ls
    bat # cat
    htop # top
  ];
}
