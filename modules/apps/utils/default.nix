{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [

    wl-clipboard
    coreutils
    util-linux
    curl
    wget
    jq
    yq-go
    nmap
    unzip
    file
    bc
    usbutils

    # improved utils
    fd # find
    ripgrep # grep
    eza # ls
    du-dust # du
    curlie # curl

    # misc
    fzf
    tldr

  ];

}
