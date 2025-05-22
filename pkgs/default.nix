{

  nixpkgs.overlays = [
    (final: prev: {
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
