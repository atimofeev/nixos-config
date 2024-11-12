{ lib, fetchFromGitHub, rustPlatform, pkg-config, glib, pango, gtk4
, wrapGAppsHook4 }:

rustPlatform.buildRustPackage rec {
  pname = "hyprlauncher";
  version = "v0.1.2";

  src = fetchFromGitHub {
    owner = "hyprutils";
    repo = pname;
    rev = version;
    hash = "sha256-SxsCfEHrJpFSi2BEFFqmJLGJIVzkluDU6ogKkTRT9e8=";
  };

  cargoHash = "sha256-hS6Ff+tcDAcibbsNQawFMGyEQOS3tJmO3SM9HOBkERA=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ glib pango gtk4 ];

  meta = with lib; {
    description =
      "GUI for launching applications, written in blazingly fast Rust";
    homepage = "https://github.com/hyprutils/hyprlauncher";
    license = lib.licenses.gpl2Only;
    # maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "hyprlauncher";
  };
}
