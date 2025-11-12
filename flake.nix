{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    asus-px-keyboard-tool.url = "github:a-chaudhari/asus-px-keyboard-tool";

    betterfox = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix/release-25.05";

    catppuccin-zen-browser = {
      url = "github:catppuccin/zen-browser?dir=themes/Macchiato/Lavender";
      flake = false;
    };

    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";

    lanzaboote.url = "github:nix-community/lanzaboote";

    niri.url = "github:sodiboo/niri-flake";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      vars = import ./variables.nix;
    in
    {
      nixosConfigurations = {

        milaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/milaptop
            ./modules
            ./overlays
            ./pkgs
          ];
        };

        zefir = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/zefir
            ./modules
            ./overlays
            ./pkgs
          ];
        };

      };
    };
}
