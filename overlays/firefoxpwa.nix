# NOTE: firefoxpwa 2.18.2 in nixos-26.05 has build bug:
#   touch: cannot touch '.../lib/firefoxpwa/is-packaged-app': No such file or directory
# Pin to 2.18.0 until fix lands upstream.
final: prev: {
  firefoxpwa = prev.firefoxpwa.overrideAttrs (og: rec {
    version = "2.18.0";
    src = prev.fetchFromGitHub {
      owner = "filips123";
      repo = "PWAsForFirefox";
      rev = "v${version}";
      hash = "sha256-F/Sj72er6aNxoV/dR7wCafgAHOKkQ7267/E+vfXdfdw=";
    };
    sourceRoot = "${src.name}/native";
    cargoHash = "sha256-PnqfYZO454t9XCzc9dwNCe4Qcp0FrG82sQcHUNdEnoo=";
  });
}
