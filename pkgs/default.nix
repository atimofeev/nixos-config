{

  nixpkgs.overlays = [
    (_final: prev: {
      # falcon = prev.callPackage ./falcon.nix { };
      darkreader-declarative = prev.callPackage ./darkreader-declarative.nix { };
      linux-g14 = prev.callPackage ./linux-g14.nix { };
      surfingkeys-declarative = prev.callPackage ./surfingkeys-declarative.nix { };
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
