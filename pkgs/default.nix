{ ... }:

{

  nixpkgs.overlays = [
    (_final: prev: {
      awsx = prev.callPackage ./awsx.nix { };
      # falcon = prev.callPackage ./falcon.nix { };
      pi-codex-conversion-helpers = prev.callPackage ./pi-codex-conversion-helpers.nix { };
      kubectl-login = prev.callPackage ./kubectl-login.nix { };
      linux-g14 = prev.callPackage ./linux-g14.nix { };
      nvidia-hide = prev.callPackage ./nvidia-hide.nix { };
      glci = prev.callPackage ./glci.nix { };
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
