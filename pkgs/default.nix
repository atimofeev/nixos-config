{

  nixpkgs.overlays = [
    (final: prev: {
      cato-client = prev.callPackage ./cato.nix { };
      vault-kv-mv = prev.callPackage ./vault-kv-mv.nix { };
    })
  ];

}
