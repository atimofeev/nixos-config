{
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.custom.hardware.sound;
in
{

  options.custom.hardware.sound = {
    enable = lib.mkEnableOption "Sound bundle";
  };

  config = lib.mkIf cfg.enable {
    users.users.${vars.username}.extraGroups = [ "audio" ];

    security.rtkit.enable = true;

    services = {
      pulseaudio.enable = false;
      pipewire = {
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
    };
  };

}
