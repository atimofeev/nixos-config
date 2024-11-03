_: {
  # TODO: setup
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
  # dots: https://github.com/anotherhadi/nixy/blob/9ffeb42e142b8367d077bd1c022cac9a04cdd19d/home/scripts/system/default.nix#L48
  # NOTE: example config
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [{
        path = "${../../assets/dark-shore.png}";
        blur_passes = 3;
        blur_size = 8;
        contrast = 0.8916;
        brightness = 0.7172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }];

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          # color = foreground;
          font_size = 28;
          # font_family = font + " Bold";
          position = "0, -50";
          halign = "center";
          valign = "top";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
          # color = foreground;
          font_size = 80;
          font_family = "steelfish outline regular";
          position = "0, -125";
          halign = "center";
          valign = "top";
        }
        # USER
        {
          monitor = "eDP-1";
          text = "    $USER";
          # color = foreground;
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 18;
          # font_family = font + " Bold";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [{
        monitor = "eDP-1";
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 0)";
        inner_color = "rgba(255, 255, 255, 0.1)";
        # font_color = foreground;
        fade_on_empty = false;
        # font_family = font + " Bold";
        placeholder_text = "<i>...</i>";
        hide_input = false;
        position = "0, -50";
        halign = "center";
        valign = "center";
      }];

      # input-field = [{
      #   size = "200, 50";
      #   position = "0, -80";
      #   monitor = "";
      #   dots_center = true;
      #   fade_on_empty = false;
      #   font_color = "rgb(202, 211, 245)";
      #   inner_color = "rgb(91, 96, 120)";
      #   outer_color = "rgb(24, 25, 38)";
      #   outline_thickness = 5;
      #   placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
      #   shadow_passes = 2;
      # }];

    };
  };
}
