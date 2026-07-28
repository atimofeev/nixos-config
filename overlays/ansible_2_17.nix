final: _prev:
let
  old_pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/dc205f7b4fdb04c8b7877b43edb7b73be7730081.tar.gz";
    sha256 = "sha256:0khifkmi7bmr8dv23js4yax5grqzwkpxcvya8krha4zzzac0fjmi";
  }) { inherit (final.stdenv.hostPlatform) system; };
in
{

  ansible_2_17 =
    let
      ansibleCore = old_pkgs.python3Packages.ansible-core.overridePythonAttrs (_oldAttrs: rec {
        version = "2.17.8";
        src = old_pkgs.fetchPypi {
          pname = "ansible_core";
          inherit version;
          hash = "sha256-Ob6KeYaix9NgabDZciC8L2eDxl/qfG1+Di0A0ayK+Hc=";
        };
      });
    in
    old_pkgs.python3.withPackages (
      ps:
      [ ansibleCore ]
      ++ (with ps; [
        boto3
        botocore
        dnspython
        hvac
      ])
    );

}
