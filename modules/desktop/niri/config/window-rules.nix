{

  programs.niri.settings.window-rules = [
    {
      geometry-corner-radius = {
        top-left = 6.0;
        top-right = 6.0;
        bottom-left = 6.0;
        bottom-right = 6.0;
      };
      clip-to-geometry = true;
      opacity = 1.0;
    }
    {
      matches = [
        { is-focused = false; }
      ];
      opacity = 0.9;
    }
  ];

}
