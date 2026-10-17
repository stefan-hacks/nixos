{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow Unfree
  nixpkgs.config.allowUnfree = true;

  # Allow experimental features and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

}
