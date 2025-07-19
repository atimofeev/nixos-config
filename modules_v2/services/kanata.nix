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
          extraDefCfg = "process-unmapped-keys yes";

          config = # lisp
            ''
              (defsrc
                caps a s d f h j k l ;
              )

              (defvar

                tap-time 250 ;; double-hit key within this timeout to repeat tap action
                hold-time 175

                ;; TODO: complete per-finger timout config
                little-hold-time 175
                ring-hold-time 165
                middle-hold-time 160
                index-hold-time 150

                left-hand-keys (
                  q w e r t
                  a s d f g
                  z x c v b
                )

                right-hand-keys (
                  y u i o p
                  h j k l ;
                  n m , . /
                )

              )

              (deffakekeys
                to-base (layer-switch base)   
              )

              (defalias
                tap (multi
                  (layer-switch nomods)
                  (on-idle-fakekey to-base tap 20)
                )
              )

              (defalias
                escnav (tap-hold $tap-time $hold-time esc (layer-while-held nav))
                a (tap-hold-release-keys $tap-time $hold-time (multi a @tap) lmet $left-hand-keys)
                s (tap-hold-release-keys $tap-time $hold-time (multi s @tap) lalt $left-hand-keys)
                d (tap-hold-release-keys $tap-time $hold-time (multi d @tap) lsft $left-hand-keys)
                f (tap-hold-release-keys $tap-time $hold-time (multi f @tap) lctl $left-hand-keys)
                h _
                j (tap-hold-release-keys $tap-time $hold-time (multi j @tap) rctl $right-hand-keys)
                k (tap-hold-release-keys $tap-time $hold-time (multi k @tap) rsft $right-hand-keys)
                l (tap-hold-release-keys $tap-time $hold-time (multi l @tap) ralt $right-hand-keys)
                ; (tap-hold-release-keys $tap-time $hold-time (multi ; @tap) rmet $right-hand-keys)
              )

              (deflayer base
                @escnav @a @s @d @f @h @j @k @l @;
              )

              (deflayer nomods
                @escnav a s d f h j k l ;
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
              )
            '';
        };
      };
    };
  };
}
