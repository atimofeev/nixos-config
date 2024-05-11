{ pkgs, ... }: {
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Mi Notebook: Fix +30db default gain on built-in mic
  environment.etc."alsa-state.conf".source = ../assets/alsa-state.conf;
  environment.systemPackages = with pkgs; [ alsaUtils ];
  systemd.services.load-alsa-state = {
    after = [ "sound.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.alsaUtils}/bin/alsactl -f /etc/alsa-state.conf restore
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
