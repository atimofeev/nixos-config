{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
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

    # nix utils
    comma # launch any nixpkg with ', <pkg>'
  ];
}
