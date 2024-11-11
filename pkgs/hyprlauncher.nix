{ lib, fetchFromGitHub, rustPlatform, pkg-config, glib, gdk-pixbuf, pango
, graphene, gtk4 }:

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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gdk-pixbuf pango graphene gtk4 ];

  meta = with lib; {
    description =
      "GUI for launching applications, written in blazingly fast Rust!";
    homepage = "https://github.com/hyprutils/hyprlauncher";
    # license = licenses.mit; # NOTE: GPL-2.0
    # maintainers = [ maintainers.azazak123 ];
    platforms = platforms.linux;
    mainProgram = "hyprlauncher";
  };
}
