_: {

  imports = [

    ./shell/common-aliases.nix
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/nushell.nix

    ./apps/nvim
    ./apps/k9s

    ./apps/bat.nix
    ./apps/htop.nix
    ./apps/playerctl.nix
    ./apps/ripgrep.nix
    ./apps/ssh.nix
    ./apps/tealdeer.nix

  ];

}
