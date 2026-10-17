{
  description = "Stefan's Modular Sysadmin NixOS Flake";

  inputs = {
    # Pinning to your preferred stable channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {

      # Example Host: titan (e.g., your primary workstation with GNOME)
      titan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/titan/default.nix               # Machine-specific base & hardware
          ./system-level/default.nix             # Global system-level infrastructure
          ./desktops/gnome/default.nix            # Complete GNOME desktop suite

          # Wire Home Manager as a core NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Link the exact home-manager profile path from your tree
            home-manager.users.stefan = import ./user-level/home-manager/stefan-hacks/default.nix;
          }
        ];
      };

      # Example Host: server (Headless infrastructure - NO GNOME module)
      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/server/default.nix
          ./system-level/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.stefan = import ./user-level/home-manager/stefan-hacks/default.nix;
          }
        ];
      };

    };
  };
}

