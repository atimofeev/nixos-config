{

  nixpkgs.overlays = [
    (_final: prev: {
      # falcon = prev.callPackage ./falcon.nix { };
      darkreader-declarative = prev.callPackage ./darkreader-declarative.nix { };
      surfingkeys-declarative = prev.callPackage ./surfingkeys-declarative.nix { };
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
