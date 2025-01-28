{ vars, ... }: {

  home-manager.users.${vars.username} = {

    # FIX: there is clearly something very wrong with this approach
    # NOTE: fix handsfree on Marshall Motiff II
    # fix hyprpanel sound OCD after pipewire restart
    # fix wayland-pipewire-idle-inhibit after pipewire restart
    # fix xdg-desktop-portal after pipewire restart
    programs.fish.shellAliases.pipewire-restart = ''
      systemctl --user restart pipewire.service && \
      systemctl --user restart pipewire-pulse.service && \
      systemctl --user restart hyprpanel && \
      systemctl --user restart wayland-pipewire-idle-inhibit.service && \
      systemctl --user restart xdg-desktop-portal'';

  };
}
