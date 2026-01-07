final: _prev:
let
  old_pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/dc205f7b4fdb04c8b7877b43edb7b73be7730081.tar.gz";
    sha256 = "sha256:0khifkmi7bmr8dv23js4yax5grqzwkpxcvya8krha4zzzac0fjmi";
  }) { inherit (final.stdenv.hostPlatform) system; };
in
{

  ansible_2_17 = old_pkgs.ansible_2_17.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
      old_pkgs.python3Packages.boto3
      old_pkgs.python3Packages.botocore
      old_pkgs.python3Packages.dnspython
      old_pkgs.python3Packages.hvac
    ];
  });

}
