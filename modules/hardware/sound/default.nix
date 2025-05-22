{ vars, ... }:
{

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.${vars.username}.extraGroups = [ "audio" ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    # extraConfig.pipewire = {
    #   "10-logging" = { "context.properties"."log.level" = 3; };
    # };
  };

}
