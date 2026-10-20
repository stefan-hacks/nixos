# Bluetooth configuration
# Addresses post-suspend/hibernate HID reconnection failures (e.g. Logitech MX Master 3S).
# The Bluetooth controller resumes but BlueZ does not re-trigger HID enumeration.
# Fix: restart bluetooth.service after resume + kernel-side HID handling.
{ config, lib, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        # Experimental mode improves BLE HID support (required by MX Master 3S).
        Experimental = true;
      };
      Policy = {
        AutoEnable = true;
      };
      Input = {
        # Let the kernel manage HID devices instead of BlueZ userspace.
        # Fixes mice/keyboards that vanish after suspend even though the
        # Bluetooth link reports "Connected".
        UserspaceHID = false;
      };
    };
  };

  # Ensure the Logitech HID++ driver is loaded early for BT HID devices
  # (MX Master 3S, MX Keys, etc.).
  boot.kernelModules = [ "hid_logitech_hidpp" ];

  # Restart Bluetooth 2 seconds after resume so HID devices re-enumerate.
  # Backgrounded to avoid delaying the resume path.
  powerManagement.resumeCommands = ''
    (
      ${pkgs.coreutils}/bin/sleep 2
      ${pkgs.systemd}/bin/systemctl restart bluetooth
    ) &
  '';
}
