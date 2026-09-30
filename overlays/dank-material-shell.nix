{ inputs, ... }:
final: _prev:
{
  dms-shell = inputs.dank-material-shell.packages.${final.stdenv.hostPlatform.system}.dms-shell.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      final.makeWrapper
    ];
    patches = (old.patches or [ ]) ++ [ ./patches/dms-networkmanager-gpclient.patch ];
    postFixup = (old.postFixup or "") + ''
      wrapProgram "$out/bin/dms" \
        --prefix PATH : ${final.lib.makeBinPath [ final.gpauth ]}
    '';
  });
}
