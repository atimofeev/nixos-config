{ inputs }:
_: prev: {
  niri = prev.niri.overrideAttrs (_: {
    src = inputs.niri-pr-fork;
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      src = inputs.niri-pr-fork;
      hash = "sha256-aNovCzrTtmqTO33YtZap47npdN73zXC1bap5q5dZvZk=";
    };
  });
}
