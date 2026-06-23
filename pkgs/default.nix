{ inputs, ... }:

{

  nixpkgs.overlays = [
    (_final: prev: {
      awsx = prev.callPackage ./awsx.nix { };
      # falcon = prev.callPackage ./falcon.nix { };
      darkreader-declarative =
        inputs.firefox-extensions-declarative.packages.${prev.stdenv.hostPlatform.system}.darkreader-declarative;
      kubectl-login = prev.callPackage ./kubectl-login.nix { };
      linux-g14 = prev.callPackage ./linux-g14.nix { };
      nvidia-hide = prev.callPackage ./nvidia-hide.nix { };
      surfingkeys-declarative =
        inputs.firefox-extensions-declarative.packages.${prev.stdenv.hostPlatform.system}.surfingkeys-declarative;
      glci = prev.callPackage ./glci.nix { };
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
