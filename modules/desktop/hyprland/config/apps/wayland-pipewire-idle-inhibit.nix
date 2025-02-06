{ inputs, lib, pkgs, config, ... }: {

  imports = [ inputs.wayland-pipewire-idle-inhibit.homeModules.default ];

  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = {
      verbosity = "INFO";
      media_minimum_duration = 5;
      idle_inhibitor = "wayland";
    };
  };

  # NOTE: default `rodio-backend` creates always active ALSA->PW stream
  # prevents proper function of `wayland-pipewire-idle-inhibit`
  programs.spotify-player.package =
    lib.mkIf config.programs.spotify-player.enabled
    (pkgs.spotify-player.override { withAudioBackend = "pulseaudio"; });

}
