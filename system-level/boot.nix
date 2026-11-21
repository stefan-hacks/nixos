# Boot loader configuration
_: {
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # Quiet boot: suppress kernel and systemd status messages.
    # Flow on desktop hosts: systemd-boot menu → LUKS prompt → GDM
    kernelParams = [
      "quiet" # Suppress kernel boot messages
      "systemd.show_status=auto" # Only show status on error
      "rd.systemd.show_status=auto" # Same for initrd
      "vt.global_cursor_default=0" # Hide blinking cursor
    ];

    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
