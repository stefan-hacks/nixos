{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # Shared operating-system configuration
    ../../system-level

    # Desktop-level (GUI) modules
    ../../system-level/bluetooth.nix
    ../../system-level/fonts.nix
    ../../system-level/kanata.nix
    ../../system-level/ollama.nix
    ../../system-level/pkgs-gui.nix
  ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  networking.hostName = "ghost";

  # Keep genuinely host-specific settings here.
  # For example:
  # services.ollama.enable = true;
  system.stateVersion = "26.05";
}
