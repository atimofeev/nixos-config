# Logitech Mice Software

## g15daemon

```nix
hardware.logitech.wireless = {
  enable = true;
  enableGraphical = true;
};
```

## libratbag & piper

```nix
services.ratbagd.enable = true;
pkgs.piper
```

https://github.com/libratbag/piper

## Solaar

https://github.com/pwr-Solaar/Solaar
https://github.com/Svenum/Solaar-Flake
