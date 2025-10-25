{ inputs, ... }:
{

  imports = [ inputs.hyprdynamicmonitors.homeManagerModules.default ];

  home.hyprdynamicmonitors = {
    enable = true;
    config = # toml
      ''
        [profiles.zefir-home]
        config_file = "/home/atimofeev/.config/hyprdynamicmonitors/hyprconfigs/zefir-home.go.tmpl"
        config_file_type = "template"
        [profiles.zefir-home.conditions]

        [[profiles.zefir-home.conditions.required_monitors]]
        description = "Samsung Display Corp. ATNA60DL01-0"
        monitor_tag = "monitor0"

        [[profiles.zefir-home.conditions.required_monitors]]
        description = "Lenovo Group Limited M14t V309WMZ3"
        monitor_tag = "monitor1"
      '';
  };

}
