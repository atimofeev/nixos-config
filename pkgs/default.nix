_: {

  nixpkgs = {
    overlays = [

      (self: super: {
        vault-kv-mv = import ./vault-kv-mv.nix {
          inherit (super) lib fetchFromGitHub buildGoModule;
        };
      })

      (self: super: {
        cato-client = import ./cato.nix {
          inherit (super)
            stdenv fetchurl writeScript autoPatchelfHook dpkg libz lib;
        };
      })

      # (self: super: {
      #   monokle = import ./monokle.nix {
      #     inherit (super)
      #       lib buildNpmPackage fetchFromGitHub electron nix-update-script
      #       makeBinaryWrapper;
      #   };
      # })

    ];
  };

}
