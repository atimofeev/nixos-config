_: {

  imports = [

    ./shell/common-aliases.nix
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/nushell.nix

    ./apps/nvim
    ./apps/k9s

    ./apps/playerctl.nix

  ];

}
