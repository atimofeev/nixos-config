{

  wayland.windowManager.niri.settings.workspace = [
    {
      _args = [ "special" ];
      open-on-output = "eDP-1";
    }
    {
      _args = [ "main" ];
      open-on-output = "eDP-1";
    }
    {
      _args = [ "right" ];
      _children = [
        { open-on-output = "Lenovo Group Limited M14t V309WMZ3"; }
        { open-on-output = "Dell Inc. DELL P2422H 4X6V7N3"; }
      ];
    }
  ];

}
