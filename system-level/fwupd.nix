# fwupd.nix — Firmware update daemon (fwupd).
# Enables fwupdmgr for querying and installing firmware updates.
{ ... }: {
  # Enable the fwupd DBus service.
  services.fwupd.enable = true;

  # The fwupd-refresh timer downloads firmware metadata in the background.
  # It is enabled by default when services.fwupd.enable = true.
  # If you want to disable automatic background refreshes:
  # systemd.timers.fwupd-refresh.enable = false;
}
