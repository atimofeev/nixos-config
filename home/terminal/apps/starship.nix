# TODO: figure out fallback for catppuccin colors
{ lib, config, ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      add_newline = false;

      format =
        lib.strings.replaceStrings [ "\n" ] [ "" ] # toml
          ''
            [](surface0)
            $battery
            $username
            $env_var
            $kubernetes
            [](fg:surface0 bg:subtext0)
            $directory
            [](fg:subtext0 bg:surface1)
            $git_branch
            $git_status
            [](fg:surface1 bg:surface2)
            $time
            [](fg:surface2 bg:surface0)
            $cmd_duration
            $status
            [ ](fg:surface0)
          '';

      battery = {
        disabled = false;
        format = "[$symbol$percentage]($style)";
      };

      battery.display = [
        {
          style = "fg:red bg:surface0";
          threshold = 79;
        }
      ];

      username = {
        disabled = false;
        format = "[! ]($style)";
        style_root = "fg:red bg:surface0";
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol $cluster( \\($namespace\\))]($style)";
        style = "bold fg:teal bg:surface0";
        symbol = "☸";
      };

      env_var = {
        IN_NIX_SHELL = {
          format = "[$symbol ]($style)";
          style = "fg:blue bg:surface0";
          symbol = "";
          variable = "IN_NIX_SHELL";
        };
      };

      directory = {
        format = "[ $path ]($style)";
        style = "fg:surface0 bg:subtext0";
        truncation_symbol = "";
        truncation_length = 3;
      };

      git_branch = {
        format = "[ $symbol $branch ]($style)";
        style = "fg:text bg:surface1";
        symbol = "";
        truncation_length = 20;
      };

      git_status = {
        disabled = true;
        format = "[$all_status$ahead_behind ]($style)";
        style = "fg:text bg:surface1";
      };

      time = {
        disabled = false;
        format = "[ 󰧼 $time ]($style)";
        style = "fg:text bg:surface2";
        time_format = "%R"; # Hour:Minute Format
      };

      cmd_duration = {
        format = "[ 󱦟$duration ]($style)";
        style = "fg:yellow bg:surface0";
        min_time = 1000;

        # show_notifications = true;
        # min_time_to_notify = 45000;
        # Waiting for resolution of this:
        # https://github.com/starship/starship/issues/1933
      };

      status = {
        disabled = false;
        style = "fg:yellow bg:surface0";
        format = "[!$int]($style)";
      };

      # NOTE: trying to utilize vim keybinds and show current mode in prompt
      character = {
        success_symbol = "[I](fg:yellow bg:surface0)";
        error_symbol = "[E](fg:yellow bg:surface0)";
        vicmd_symbol = "[N](fg:yellow bg:surface0)";
        vimcmd_replace_one_symbol = "[r](fg:yellow bg:surface0)";
        vimcmd_replace_symbol = "[R](fg:yellow bg:surface0)";
        vimcmd_visual_symbol = "[V](fg:yellow bg:surface0)";
      };

    };
  };
}
