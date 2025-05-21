{
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
        extraDefCfg = "process-unmapped-keys yes";

        config = # lisp
          ''
            (defsrc
              caps a s d f h j k l ;
            )

            (defvar
              tap-time 150
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
              ; (tap-hold $tap-time $hold-time ; rmet)
            )

            (deflayer base
              @escnav @a @s @d @f @h @j @k @l @;
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
}
