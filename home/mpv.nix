{ pkgs, ... }: {
  programs.mpv = {
    enable = true;

    config = {
      slang = "eng,en";
      alang = "jpn,jap,ja,jp";
    };

    bindings = {
      a = "cycle audio";
      s = "cycle sub";
      WHEEL_UP = "add volume 2.5";
      WHEEL_DOWN = "add volume -2.5";
      UP = "add volume 2.5";
      DOWN = "add volume -2.5";
      ENTER = "ignore";
    };

    scripts = with pkgs.mpvScripts; [
      inhibit-gnome # do not let gnome sleep during playback
      mpris # integrate with media controls
      autoload # load playlist entries from play dir

      # TODO: try this out
      # simple-mpv-ui # web ui to control mpv

      # TODO: import select-subtitle to ignore case in sub naming
      # https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/select-subtitle.lua

      # TODO: import auto-save-state to keep current playback timestamp for a specific file
      # https://github.com/atimofeev/dotfiles/blob/main/mpv/files/scripts/auto-save-state.lua
    ];
  };
}
