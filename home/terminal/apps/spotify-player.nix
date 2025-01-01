{ pkgs, ... }: {

  programs.spotify-player = {
    enable = true;
    package = pkgs.spotify-player.override {
      # NOTE: `rodio-backend` creates always active ALSA->PW stream
      # prevents proper function of `wayland-pipewire-idle-inhibit`
      withAudioBackend = "pulseaudio";
    };
    settings = {
      liked_icon = "";
      device = {
        volume = 85;
        autoplay = true;
      };
    };
  };

}
