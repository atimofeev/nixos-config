final: prev: {
  manix = prev.manix.override (old: {
    rustPlatform = old.rustPlatform // {
      buildRustPackage = args:
        old.rustPlatform.buildRustPackage (args // {

          version = "0.8.0-pr20";

          src = prev.fetchFromGitHub {
            owner = "nix-community";
            repo = "manix";
            rev = "c532d14b0b59d92c4fab156fc8acd0565a0836af";
            sha256 = "sha256-Uo+4/be6rT0W8Z1dvCRXOANvoct6gJ4714flhyFzmKU=";
          };

          cargoHash = "sha256-ey8nXMCFnDSlJl+2uYYFm1YrhJ+r0sq48qtCwhqI0mo=";

        });
    };
  });
}
