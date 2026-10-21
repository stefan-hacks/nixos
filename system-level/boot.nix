# Boot loader configuration
{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Quiet boot: suppress kernel and systemd status messages.
  # Flow: systemd-boot menu → LUKS prompt → GDM → desktop
  boot.kernelParams = [
    "quiet"                       # Suppress kernel boot messages
    "systemd.show_status=auto"    # Only show status on error
    "rd.systemd.show_status=auto" # Same for initrd
    "vt.global_cursor_default=0"  # Hide blinking cursor
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
