{

  # NOTE: usage:
  # fzf: cliphist list | fzf --no-sort | cliphist decode | wl-copy
  # fuzzel: cliphist list | fuzzel --dmenu | cliphist decode | wl-copy

  services.cliphist = {
    enable = true;
    allowImages = true;
    # systemdTargets = [ "graphical-session.target" ];
    systemdTarget = "graphical-session.target";
  };

}
