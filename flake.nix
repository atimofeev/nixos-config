{
  description = "Nixos config flake";

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {

        milaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/milaptop
            ./modules
            ./overlays
            ./pkgs
          ];
        };

        zefir = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/zefir
            ./modules
            ./overlays
            ./pkgs
          ];
        };

      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    asus-px-keyboard-tool.url = "github:a-chaudhari/asus-px-keyboard-tool";

    catppuccin.url = "github:catppuccin/nix/main";

    catppuccin-zen-browser = {
      # url = "github:catppuccin/zen-browser?dir=themes/Macchiato/Lavender";
      url = "github:code-irisnk/catppuccin-zen-browser/main?dir=themes/Macchiato/Lavender";
      flake = false;
    };

    dank-material-shell = {
      # NOTE: waits for merge https://github.com/AvengeMedia/DankMaterialShell/pull/2428
      # url = "github:AvengeMedia/DankMaterialShell/stable";
      url = "github:atimofeev/DankMaterialShell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-extensions-declarative.url = "github:firefox-extensions-declarative/firefox-extensions-declarative";

    github-avatar = {
      url = "https://avatars.githubusercontent.com/u/39891735?v=4";
      flake = false;
    };

    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";

    lanzaboote.url = "github:nix-community/lanzaboote";

    niri-nix.url = "git+https://codeberg.org/BANanaD3V/niri-nix";

    niri-pr-fork = {
      url = "github:atimofeev/niri";
      flake = false;
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

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

    walls = {
      url = "github:atimofeev/walls";
      flake = false;
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

  };
}
