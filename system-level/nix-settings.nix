# Nix package manager settings
{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Ensures the system always knows where to look for rebuilds
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
