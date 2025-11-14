{

  programs.niri.settings.layout = {

    gaps = 3;

    center-focused-column = "never";

    default-column-width.proportion = 0.5;

    preset-column-widths = [
      { proportion = 0.5; }
      { proportion = 1.0; }
    ];

    preset-window-heights = [
      { proportion = 0.5; }
      { proportion = 1.0; }
    ];

    empty-workspace-above-first = true;

    focus-ring.enable = false;

    border = {
      enable = true;
      width = 3;
      active.gradient = {
        from = "#c6a0f6";
        to = "#8aadf4";
        angle = 90;
      };
      inactive.color = "#505050";
      urgent.color = "#9b0000";
    };

  };

}
