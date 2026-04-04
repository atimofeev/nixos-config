{ pkgs, ... }:
{

  imports = [
    ./plugins
    ./keymap.nix
    ./options.nix
  ];

  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # soft deps
      gcc
      # xclip
      wl-clipboard
    ];

    extraLuaConfig = # lua
      ''
        -- Sync clipboard between OS and Neovim.
        --  Schedule the setting after `UiEnter` because it can increase startup-time.
        vim.schedule(function()
          vim.opt.clipboard = 'unnamedplus'
        end)


        -- Disabled in kitty-scrollback
        if vim.env.KITTY_SCROLLBACK_NVIM ~= 'true' then
          vim.api.nvim_create_autocmd('TextYankPost', {
            desc = 'Highlight when yanking (copying) text',
            group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
            callback = function()
              vim.highlight.on_yank({higroup='Search', timeout=300})
            end,
          })

          vim.api.nvim_create_autocmd("TermClose", {
            desc = 'Close terminal if its process has ended',
            callback = function()
               vim.cmd("bdelete")
            end
          })
        end

      '';

  };
}
