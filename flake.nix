{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server (flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pure-vim = {
      url = "github:stefan-hacks/pure-vim";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
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

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    vellum = {
      url = "github:blackhat-7/vellum.nvim";
      flake = false;
    };

    por-cli = {
      url = "github:stefan-hacks/por-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kitty-scrollback = {
      url = "github:mikesmithgh/kitty-scrollback.nvim/v8.0.0";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    treefmt-nix,
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
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.stefan-hacks = {
                imports = [
                  inputs.nixdatifier.homeManagerModules.default
                  inputs.pure-vim.homeManagerModules.default
                  inputs.por-cli.homeManagerModules.default
                  ./user-level/home-manager/stefan-hacks/default.nix
                ];
              };
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

    # Development shell with quality-check tools
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShellNoCC {
      name = "nixos-quality";
      packages = with nixpkgs.legacyPackages.${system}; [
        deadnix
        statix
        nixpkgs-fmt
        treefmtEval.config.build.wrapper
      ];
      shellHook = ''
        echo "NixOS quality-check environment"
        echo "  deadnix .       # scan for dead code"
        echo "  statix check    # lint Nix code"
        echo "  nix fmt         # auto-format all files"
        echo "  nix flake check # evaluate all checks"
      '';
    };

    # Flake checks — run automatically during `nix flake check`
    checks.${system}.deadnix =
      nixpkgs.legacyPackages.${system}.runCommand "deadnix-check"
      {
        nativeBuildInputs = [nixpkgs.legacyPackages.${system}.deadnix];
      }
      ''
        cp -r ${./.} src
        chmod -R +w src
        cd src
        deadnix --fail .
        touch $out
      '';
  };
}
