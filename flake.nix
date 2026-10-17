
{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep your existing nixvim, and
    # other required inputs here as well.
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      hostNames = [
        "ghost"
        "titan"
        "minimal"
        "server"
      ];

      mkHost = hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs hostName;
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/${hostName}
          ];
        };
    in
    {
      nixosConfigurations =
        builtins.listToAttrs (
          map (hostName: {
            name = hostName;
            value = mkHost hostName;
          }) hostNames
        );
    };
}

