{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-graph = {
     url = "github:AlexAntonik/nix-graph";
     inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";

      hostNames = [
        "ghost"
        "titan"
        "minimal"
        "server"
      ];

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs hostName;
            usernames = [ "stefan-hacks" ];
          };

          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./hosts/${hostName}
          ];
        };
    in
    {
      # Modern Nix formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      # NixOS configurations for the fleet
      nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
    };
}
