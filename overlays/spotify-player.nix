# NOTE: default `rodio-backend` creates always active ALSA->PW stream
# prevents proper function of `wayland-pipewire-idle-inhibit`
_final: prev: {
  spotify-player = prev.spotify-player.override {
    withAudioBackend = "pulseaudio";
  };

  unstable = prev.unstable // {
    spotify-player = prev.unstable.spotify-player.override {
      withAudioBackend = "pulseaudio";
    };
  };

}
