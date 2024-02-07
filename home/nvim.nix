# TODO: migrate dotfile conf to nix conf
{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # soft deps
      gcc
      xclip
      # mason installers
      nodejs_21
      go
      cargo
      # lint/fmt/lsp
      stylua
      statix
      nixfmt
      nixpkgs-fmt
      nixd
    ];
  };
}
