{ pkgs, ... }:
{

  home.packages = with pkgs; [ bluetuith ];

  xdg.configFile."bluetuith/bluetuith.conf".text = # conf
    ''
      {
        adapter: ""
        adapter-states: ""
        connect-bdaddr: ""
        gsm-apn: ""
        gsm-number: ""
        keybindings: {
          NavigateDown: j
          NavigateUp: k
          Quit: q
        }
        receive-dir: ""
        theme: {}
      }
    '';

}
