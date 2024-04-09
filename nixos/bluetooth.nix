{ ... }: {
  # FIX: Marshall Motif II trying to connect in LE mode
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "dual";
      # Experimental = true;
    };
    Policy = { AutoEnable = true; };
  };
}
