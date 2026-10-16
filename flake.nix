{
  description = "My nixos setup";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = inputs@{flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        # NixOS feature modules — exported as flake.nixosModules.<name>
        ./modules/system/flake-parts.nix
        ./modules/users/flake-parts.nix
        ./modules/programs/flake-parts.nix

        # Home-manager feature modules — exported as flake.homeManagerModules.<name>
        ./modules/home/flake-parts.nix

        # Host declarations — each host is a small flake-parts module that
        # selects which NixOS / home-manager aspects to enable.
        ./host/flake-parts.nix

      ];

    let
      # Automatically get all directory names under the ./hosts folder
      hostDirs = builtins.attrNames (builtins.readDir ./hosts);

      mkSystem = hostname: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass the hostname down into the modules
        specialArgs = { inherit inputs hostname; };
        modules = [
          ./hosts/${hostname}/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs hostname; };
          }
        ];
      };
    in {
      # Dynamically generate nixosConfigurations based on folder names
      nixosConfigurations = nixpkgs.lib.genAttrs hostDirs (hostname: mkSystem hostname);
    };

    perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-tree;
    };
}
