{
  config,
  lib,
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

    users.users = lib.attrsets.genAttrs config.custom.hm-users (u: {
      extraGroups = [ "audio" ];
    });

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

        # extraConfig.pipewire = {
        #   "10-logging" = { "context.properties"."log.level" = 3; };
        # };

      };
    };
  };

}
