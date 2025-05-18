final: prev:
let rofi-wayland = { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
in {

  rofi-calc = prev.rofi-calc.override rofi-wayland;

}
