{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      # inputs.nixpkgs.follows = "hyprland";
    };

    hyprpanel = {
      url =
        "github:Jas-SinghFSU/HyprPanel?ref=f21d70949f9f4426f39d12f542ec788d47330763";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      libx = import ./lib { inherit pkgs; };
      vars = import ./variables.nix;
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs libx vars; };
        modules = [
          ./nixos
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.xremap.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
}
