final: prev: {
  terraformer = prev.terraformer.override (old: {
    buildGoModule = args:
      old.buildGoModule (args // {

        version = "0.8.24-a5b4b69";

        src = prev.fetchFromGitHub {
          owner = "GoogleCloudPlatform";
          repo = "terraformer";
          rev = "a5b4b69b1cd36942ed85c1c6f8ba81e16b8b8a2b";
          sha256 = "sha256-V0U+OO3L1zEJn20Z3ZalxMB/O6TL7oOfa438PKOrbAQ=";
        };

        vendorHash = "sha256-P8YIPbwvb/8DHOWJcDH6oq6KihOQGGlO/X8RBWm9tqk=";

      });
  });

}
