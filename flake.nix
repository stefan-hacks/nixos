{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server (flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    hermes-agent,
    treefmt-nix,
    ...
  }: let
    system = "x86_64-linux";

    hostNames = ["ghost" "titan" "minimal" "server"];

    # ─── OVERLAY CONFIGURATION TO BYPASS PATCHELF BUILD FAILURE ───
    hermesOverlay = _final: prev: {
      # Overrides any package downstream inside hermes that requests a patched patchelf instance
      patchelf = prev.patchelf;
    };

    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs hostName;
          usernames = ["stefan-hacks"];
        };

        modules = [
          # Apply the overlay so nixpkgs evaluates cleanly across the host configuration
          {nixpkgs.overlays = [hermesOverlay];}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.stefan-hacks = {
              imports = [
                hermes-agent.homeManagerModules.default
                ./user-level/home-manager/stefan-hacks/default.nix
              ];
            };
          }
          ./hosts/${hostName}
        ];
      };

    treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
      projectRootFile = "flake.nix";
      programs.alejandra.enable = true;
      programs.deadnix.enable = true;
    };
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
  };
}
