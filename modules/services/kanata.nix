{ lib, config, ... }:
let
  cfg = config.custom.services.kanata;
in
{

  options.custom.services.kanata = {
    enable = lib.mkEnableOption "kanata bundle";
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        default = {
          inherit (cfg) devices;
          extraArgs = [
            "--quiet"
          ];
          extraDefCfg = ''
            process-unmapped-keys yes
            log-layer-changes no
          '';

          config = # lisp
            ''
              (defsrc
                caps a s d f h j k l ; ins
              )

              (defvar
                tap-time 300 ;; double-hit key within this timeout to repeat tap action
                hold-time 200
              )

              (defalias
                escnav (tap-hold $tap-time $hold-time esc (layer-while-held nav))
                a (tap-hold $tap-time $hold-time a lmet)
                s (tap-hold $tap-time $hold-time s lalt)
                d (tap-hold $tap-time $hold-time d lsft)
                f (tap-hold $tap-time $hold-time f lctl)
                h _
                j (tap-hold $tap-time $hold-time j rctl)
                k (tap-hold $tap-time $hold-time k rsft)
                l (tap-hold $tap-time $hold-time l ralt)
                sc (tap-hold $tap-time $hold-time ; rmet)

                gm-on (layer-switch game)
                gm-off (layer-switch base)
              )

              (deflayer base
                @escnav @a @s @d @f @h @j @k @l @sc @gm-on
              )

              (deflayer game
                _ a s d f h j k l ; @gm-off
              )

              (deflayer nav
                _
                _
                _
                _
                _
                left
                down   
                up     
                right
                _
                _
              )
            '';
        };
      };
    };
  };
}
