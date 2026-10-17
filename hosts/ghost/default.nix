
{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Shared operating-system configuration
    ../../system-level

    # Desktop-specific operating-system configuration
    ../../desktops/gnome

    # Host-specific modules can be added here
  ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  networking.hostName = "ghost";

  # Keep genuinely host-specific settings here.
  # For example:
  # services.ollama.enable = true;
}
