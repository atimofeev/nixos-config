{ ... }: {
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "bredr"; # Fixes Marshall Motif II LE mode
    };
    Policy = { AutoEnable = true; };
  };
}
