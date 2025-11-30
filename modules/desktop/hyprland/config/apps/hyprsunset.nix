{

  services.hyprsunset = {
    enable = true;
    settings.profile = [
      {
        time = "8:30";
        identity = true;
      }
      {
        time = "22:00";
        temperature = "5000";
        gamma = 0.8;
      }
    ];
  };

  systemd.user.services.hyprsunset.Unit = {
    StartLimitBurst = 5;
    StartLimitIntervalSec = 120;
  };

}
