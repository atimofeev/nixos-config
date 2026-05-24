{ inputs }:
_: prev: {
  niri = prev.niri.overrideAttrs (_: {
    # Build niri from local checkout with focus-on-activate feature.
    src = inputs.niri-pr-fork;
    # Set to fake hash initially. First build will fail and print the correct hash.
    # Copy the actual hash here and rebuild.
    cargoHash = prev.lib.fakeHash;
  });
}
