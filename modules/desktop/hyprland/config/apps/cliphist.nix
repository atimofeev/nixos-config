{ lib, ... }: {

  # NOTE: usage:
  # fzf: cliphist list | fzf --no-sort | cliphist decode | wl-copy
  # fuzzel: cliphist list | fuzzel --dmenu | cliphist decode | wl-copy

  # NOTE: https://github.com/nix-community/home-manager/pull/6751
  systemd.user.services.cliphist.Unit.After =
    lib.mkForce "graphical-session.target";
  systemd.user.services.cliphist-images.Unit.After =
    lib.mkForce "graphical-session.target";

  services.cliphist = {
    enable = true;
    allowImages = true;
    # systemdTargets = [ "graphical-session.target" ];
    systemdTarget = "graphical-session.target";
  };

}
