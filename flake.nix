{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # hypridle = {
    #   url = "github:hyprwm/hypridle";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # hyprlock = {
    #   url = "github:hyprwm/hyprlock";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # hyprpolkitagent = {
    #   url = "github:hyprwm/hyprpolkitagent";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

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
          inputs.nix-gaming.nixosModules.platformOptimizations
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
}
