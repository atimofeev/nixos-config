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
      luarocks
      nodejs_21
      go
      cargo
      # lint/fmt/lsp
      statix
      nixfmt
      nixpkgs-fmt
      nixd
    ];
  };
}
