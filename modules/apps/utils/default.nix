{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [

    bc
    coreutils
    curl
    file
    jq
    nmap
    unzip
    usbutils
    util-linux
    wget
    wl-clipboard
    yq-go

    # improved utils
    xh # curl
    du-dust # du
    eza # ls
    fd # find
    ripgrep # grep

    # misc
    fzf
    tldr
    ani-cli

  ];

}
