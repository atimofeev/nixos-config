_final: prev:
{
  starship-jj = prev.starship-jj.overrideAttrs (_old: rec {
    version = "0.7.0-unstable-2026-03-17";

    src = prev.fetchFromGitLab {
      owner = "lanastara_foss";
      repo = "starship-jj";
      rev = "8ca6a95798bad2d3eeabcbac0e9e14bda144ea85";
      hash = "sha256-icIxTSR4n4f+NkQ5NhTykzyOpFm/nOrXvhF2WTC3c0k=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-ZG16M+2NLHOgM7J2sMFHi5ipVXPxFipRGrqCndejWiE=";
    };
  });
}
