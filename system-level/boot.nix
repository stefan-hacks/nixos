{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  # Allow experimental features and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nixos - Maintenance
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
