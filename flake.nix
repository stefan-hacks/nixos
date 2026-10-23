{
  description = "NixOS fleet — Ghost, Titan, Minimal and Server (flakes + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent/main";
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

    mega-cmdparse = {
      url = "github:ColinKennedy/mega.cmdparse";
      flake = false;
    };

    mega-logging = {
      url = "github:ColinKennedy/mega.logging";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    nvf,
    hermes-agent,
    nixdatifier,
    nix-graph,
    vellum,
    kitty-scrollback,
    mega-cmdparse,
    mega-logging,
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
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
  };
}
