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
      # Enable nix-command and flakes experimental features globally.
      # Even without flakes as the primary workflow, these are required by
      # modern tooling (nix search, nix-shell, nh, etc.).
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
