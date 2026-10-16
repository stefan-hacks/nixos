{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-my-gnome = {
      url = "github:stefan-hacks/nix-my-gnome";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-graph = {
      url = "github:AlexAntonik/nix-graph";
      # NOTE: nix-graph pins nixos-unstable. Do NOT add follows here,
      #       because its buildGoModule may need a newer Go toolchain
      #       than what nixos-26.05 stable provides.
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      # Helper for automatic host discovery
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostname}
          ./modules/system
          home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."stefan-hacks" = import ./user-level/home-manager/stefan-hacks
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    in {
      nixosConfigurations = {
        titan = mkHost "titan";
        # Adding new hosts is trivial:
        # laptop = mkHost "laptop";
        # server = mkHost "server";
      };
    };
}
