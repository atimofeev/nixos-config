{ lib, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.strings.concatStrings [
        "[](#9A348E)"
        "$battery"
        "[](bg:#DA627D fg:#9A348E)"
        "$directory"
        "[](fg:#DA627D bg:#eb9675)"
        "$git_branch"
        "$git_status"
        "[](fg:#eb9675 bg:#33658A)"
        "$time"
        "$cmd_duration"
        "[ ](fg:#33658A)"
      ];
      battery = {
        disabled = false;
        format = "[$symbol$percentage]($style)";
      };
      battery.display = {
        threshold = 90;
        style = "bg:#9A348E fg:#DA627D";
        charging_symbol = "⚡";
        discharging_symbol = "💀";
      };
      directory = {
        style = "bg:#DA627D";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = "";
        style = "bg:#eb9675";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#eb9675";
        format = "[$all_status$ahead_behind ]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[ 󰧼 $time ]($style)";
      };
      cmd_duration = {
        min_time = 1000;
        style = "bg:#33658A fg:#F0C674";
        format = "[ $duration ]($style)";
        #Waiting for resolution of this:
        #https://github.com/starship/starship/issues/1933
        #show_notifications = true;
        #min_time_to_notify = 45000;
      };
    };
  };
}
