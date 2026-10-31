{ inputs, ... }:
final: _prev:
{
  asus-px-keyboard-tool = inputs.asus-px-keyboard-tool.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/asus-px-keyboard-tool-hid-id.patch ];
  });
}
