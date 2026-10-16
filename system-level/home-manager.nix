{ ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit username inputs desktopProfile;
      inherit (inputs) nix-graph;
    };

    users.${username} = inputs.self.lib.homeManagerModules.user-stefan-hacks;

    sharedModules = [
      (lib.mkIf (desktopProfile == "gnome") {
        # nix-my-gnome is the dconf dump → nix generator used for GNOME.
        # It provides the `nmg` CLI and generated dconf modules.
        home.packages = [ inputs.nix-my-gnome.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      })
    ];
  };
}
