_: {

  imports = [

    ./kitty.nix

    ./shell/fish.nix
    ./shell/nushell.nix

    ./apps/nvim
    ./apps/k9s

    ./apps/bat.nix
    ./apps/btop.nix
    ./apps/git.nix
    ./apps/htop.nix
    ./apps/kubecolor.nix
    ./apps/playerctl.nix
    ./apps/ripgrep.nix
    ./apps/spotify-player.nix
    ./apps/ssh.nix
    ./apps/starship.nix
    ./apps/yazi.nix
    ./apps/zoxide.nix

  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    # MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    # MANROFFOPT = "-c";
  };

}
