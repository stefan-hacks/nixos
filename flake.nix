{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server (flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Added treefmt-nix input to manage both formatting and dead code checking
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # disko = {
    #   url = "github:nix-community/disko/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixdatifier = {
      url = "github:Muddyblack/nixdatifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-graph = {
      url = "github:AlexAntonik/nix-graph";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vellum = {
      url = "github:blackhat-7/vellum.nvim";
      flake = false;
    };

    kitty-scrollback = {
      url = "github:mikesmithgh/kitty-scrollback.nvim/v8.0.0";
      flake = false;
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    treefmt-nix,
    # disko,
    ...
  }: let
    system = "x86_64-linux";

    hostNames = ["ghost" "titan" "minimal" "server"];

    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs hostName;
          usernames = ["stefan-hacks"];
        };

        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/${hostName}
        ];
      };

    # Evaluate treefmt with Alejandra and Deadnix configured together
    treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
      projectRootFile = "flake.nix";

      # Enable Alejandra for pure structural formatting
      programs.alejandra.enable = true;

      # Enable Deadnix to automatically track and strip unused variables
      programs.deadnix.enable = true;
    };
  in {
    # Replaced the single nixfmt definition with the unified treefmt wrapper
    formatter.${system} = treefmtEval.config.build.wrapper;

    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
  };
}
