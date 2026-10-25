# System maintenance and auto-upgrade
{
  ...
}: {
  system.autoUpgrade = {
    enable = true;

    # Run daily at 4:00 AM.
    dates = "04:00";

    # Use the nixos-26.05 stable channel for automatic updates.
    channel = "https://nixos.org/channels/nixos-26.05";

    # Allow reboot if required (for kernel updates).
    allowReboot = false; # Set to true for automatic reboots.
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # NOTE: Disabled because flakes do not support copySystemConfiguration.
  # system.copySystemConfiguration = true;
}
