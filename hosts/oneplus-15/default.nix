# nix-on-droid module — separate from NixOS module tree
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  username = "nix-on-droid";
in
{

  time.timeZone = "Europe/Podgorica";
  system.stateVersion = "24.05";

  user.shell = "${pkgs.fish}/bin/fish";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs;
      osConfig = config;
    };

    config = {
      imports = [
        ../../modules/home
        ../../users/nix-on-droid
      ];

      home = {
        inherit username;
        homeDirectory = "/data/data/com.termux.nix/files/home";
        inherit (config.system) stateVersion;
      };
    };
  };

}
