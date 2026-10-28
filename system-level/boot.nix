# Boot loader configuration
_: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Quiet boot: suppress kernel and systemd status messages.
  # Flow: systemd-boot menu → Plymouth LUKS prompt → GDM → desktop
  boot.kernelParams = [
    "quiet" # Suppress kernel boot messages
    "splash" # Enable framebuffer splash (required by Plymouth)
    "systemd.show_status=auto" # Only show status on error
    "rd.systemd.show_status=auto" # Same for initrd
    "vt.global_cursor_default=0" # Hide blinking cursor
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Plymouth graphical boot splash. Uses the default theme (spinner)
  # which shows a lock icon for LUKS unlock and a loading circle during boot.
  boot.plymouth.enable = true;
}
