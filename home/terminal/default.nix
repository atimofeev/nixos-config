_: {

  imports = [

    ./shell/common-aliases.nix
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/nushell.nix

    ./apps/nvim
    ./apps/k9s

    ./apps/bat.nix
    ./apps/eza.nix
    ./apps/git.nix
    ./apps/htop.nix
    ./apps/kubecolor.nix
    ./apps/playerctl.nix
    ./apps/ripgrep.nix
    ./apps/ssh.nix
    ./apps/starship.nix
    ./apps/tealdeer.nix

  ];

}
