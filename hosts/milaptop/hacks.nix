{ vars, ... }: {

  home-manager.users.${vars.username} = {

    # NOTE: fix handsfree on Marshall Motiff II
    # NOTE: fix hyprpanel sound OCD after pipewire restart
    # NOTE: fix wayland-pipewire-idle-inhibit after pipewire restart
    programs.fish.shellAliases.pipewire-restart = ''
      systemctl --user restart pipewire.service && \
      systemctl --user restart pipewire-pulse.service && \
      systemctl --user restart hyprpanel && \
      systemctl --user restart wayland-pipewire-idle-inhibit.service
    '';

  };
}
