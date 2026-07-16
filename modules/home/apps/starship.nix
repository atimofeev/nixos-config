{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom-hm.applications.starship;
  # NOTE: https://github.com/catppuccin/nix/pull/738
  catppuccin = {
    blue = "#89b4fa";
    mauve = "#cba6f7";
    red = "#f38ba8";
    sky = "#89dceb";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    surface2 = "#585b70";
    surface1 = "#45475a";
    text = "#cdd6f4";
  };
in
{

  options.custom-hm.applications.starship = {
    enable = lib.mkEnableOption "starship bundle";
    package = lib.mkPackageOption pkgs "starship" { };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      inherit (cfg) package;
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
              $aws
              [](fg:surface0 bg:subtext0)
              $directory
              [](fg:subtext0 bg:surface1)
              $git_branch
              ''${custom.jj}
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
            threshold = 75;
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

        aws = {
          disabled = false;
          format = "[$symbol $profile( \\($region\\))]($style)";
          style = "bold fg:yellow bg:surface0";
          symbol = "☁️";
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
          format = "[ $symbol $branch]($style)";
          style = "fg:text bg:surface1";
          symbol = "";
          truncation_length = 20;
          only_attached = true;
        };

        # NOTE: waiting for https://github.com/starship/starship/issues/6076 resolution
        custom.jj = {
          command = "prompt";
          format = "[ $output]($style)";
          style = "fg:text bg:surface1";
          ignore_timeout = true;
          shell = [
            (lib.getExe pkgs.starship-jj)
            "--ignore-working-copy"
            "starship"
          ];
          use_stdin = false;
          when = true;
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

    # NOTE: waiting for https://github.com/starship/starship/issues/6076 resolution
    xdg.configFile."starship-jj/starship-jj.toml".text = ''
      module_separator = " "
      reset_color = false

      [bookmarks]
      search_depth = 100
      exclude = []

      [[module]]
      type = "Symbol"
      symbol = ""
      color = "${catppuccin.text}"
      bg_color = "${catppuccin.surface1}"

      [[module]]
      type = "Bookmarks"
      separator = ""
      color = "${catppuccin.text}"
      bg_color = "${catppuccin.surface1}"
      behind_symbol = "⇡"
      surround_with_quotes = false
      ignore_empty_commits = "None"

      [[module]]
      type = "Commit"
      previous_message_symbol = "⇣"
      max_length = 24
      show_previous_if_empty = false
      empty_text = ""
      surround_with_quotes = false
      color = "${catppuccin.text}"
      bg_color = "${catppuccin.surface1}"

      [module.non_unique]
      color = "Black"
      bg_color = "${catppuccin.surface1}"

      [[module]]
      type = "State"
      separator = ""

      [module.conflict]
      disabled = false
      text = "C"
      color = "Red"
      bg_color = "${catppuccin.surface1}"

      [module.divergent]
      disabled = false
      text = "D"
      color = "Cyan"
      bg_color = "${catppuccin.surface1}"

      [module.empty]
      disabled = false
      text = "E"
      color = "Yellow"
      bg_color = "${catppuccin.surface1}"

      [module.immutable]
      disabled = false
      text = "I"
      color = "Yellow"
      bg_color = "${catppuccin.surface1}"

      [module.hidden]
      disabled = false
      text = "H"
      color = "Yellow"
      bg_color = "${catppuccin.surface1}"

      [[module]]
      type = "Metrics"
      template = "{changed} {added}󰦒{removed} "
      hide_if_empty = false
      color = "${catppuccin.text}"
      bg_color = "${catppuccin.surface1}"

      [module.changed_files]
      prefix = ""
      suffix = ""
      color = "Cyan"
      bg_color = "${catppuccin.surface1}"

      [module.added_lines]
      prefix = ""
      suffix = ""
      color = "Green"
      bg_color = "${catppuccin.surface1}"

      [module.removed_lines]
      prefix = ""
      suffix = ""
      color = "Red"
      bg_color = "${catppuccin.surface1}"
    '';

  };

}
