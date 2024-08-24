{ lib, ... }:
let
  # catppuccin macchiato palette
  colors = {
    rosewater = "#f4dbd6";
    flamingo = "#f0c6c6";
    pink = "#f5bde6";
    mauve = "#c6a0f6";
    red = "#ed8796";
    maroon = "#ee99a0";
    peach = "#f5a97f";
    yellow = "#eed49f";
    green = "#a6da95";
    teal = "#8bd5ca";
    sky = "#91d7e3";
    sapphire = "#7dc4e4";
    blue = "#8aadf4";
    lavender = "#b7bdf8";
    text = "#cad3f5";
    subtext1 = "#b8c0e0";
    subtext0 = "#a5adcb";
    overlay2 = "#939ab7";
    overlay1 = "#8087a2";
    overlay0 = "#6e738d";
    surface2 = "#5b6078";
    surface1 = "#494d64";
    surface0 = "#363a4f";
    base = "#24273a";
    mantle = "#1e2030";
    crust = "#181926";
  };
  section1 = {
    bg = colors.surface0;
    fg = colors.red;
  };
  section2 = {
    bg = colors.subtext0;
    fg = colors.surface0;
  };
  section3 = {
    bg = colors.surface1;
    fg = colors.text;
  };
  section4 = {
    bg = colors.surface2;
    fg = colors.text;
  };
  section5 = {
    bg = colors.surface0;
    fg = colors.yellow;
  };
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      format = lib.strings.replaceStrings [ "\n" ] [ "" ] # toml
        ''
          [](${section1.bg})
          $battery
          $username
          $env_var
          [](fg:${section1.bg} bg:${section2.bg})
          $directory
          [](fg:${section2.bg} bg:${section3.bg})
          $git_branch
          $git_status
          [](fg:${section3.bg} bg:${section4.bg})
          $time
          [](fg:${section4.bg} bg:${section5.bg})
          $cmd_duration
          $status
          [ ](fg:${section5.bg})
        '';

      battery = {
        disabled = false;
        format = "[$symbol$percentage]($style)";
      };

      battery.display = [{
        style = "fg:${section1.fg} bg:${section1.bg}";
        threshold = 90;
      }];

      username = {
        disabled = false;
        format = "[!]($style)";
        style_root = "fg:${section1.fg} bg:${section1.bg}";
      };

      env_var = {
        IN_NIX_SHELL = {
          format = "[$symbol]($style)";
          style = "fg:${colors.blue} bg:${section1.bg}";
          symbol = "";
          variable = "IN_NIX_SHELL";
        };
      };

      directory = {
        format = "[ $path ]($style)";
        style = "fg:${section2.fg} bg:${section2.bg}";
        truncation_symbol = "";
        truncation_length = 3;
      };

      git_branch = {
        format = "[ $symbol $branch ]($style)";
        style = "fg:${section3.fg} bg:${section3.bg}";
        symbol = "";
        truncation_length = 20;
      };

      git_status = {
        format = "[$all_status$ahead_behind ]($style)";
        style = "fg:${section3.fg} bg:${section3.bg}";
      };

      time = {
        disabled = false;
        format = "[ 󰧼 $time ]($style)";
        style = "fg:${section4.fg} bg:${section4.bg}";
        time_format = "%R"; # Hour:Minute Format
      };

      cmd_duration = {
        format = "[ 󱦟$duration ]($style)";
        style = "fg:${section5.fg} bg:${section5.bg}";
        min_time = 1000;

        # show_notifications = true;
        # min_time_to_notify = 45000;
        # Waiting for resolution of this:
        # https://github.com/starship/starship/issues/1933
      };

      status = {
        disabled = false;
        style = "fg:${section5.fg} bg:${section5.bg}";
        format = "[!$int]($style)";
      };
    };
  };
}
