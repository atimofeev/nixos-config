_: {

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=suspend
    HandleLidSwitchDocked=suspend
  '';

}
