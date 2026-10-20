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

  # Load btusb in initrd so the Bluetooth controller is initialised early
  # after hibernate (S4), where the kernel must re-enumerate USB devices
  # before userspace is available.
  boot.initrd.kernelModules = [ "btusb" ];

  # Disable USB autosuspend for the MediaTek Bluetooth controller (13d3:3621).
  # This controller fails to resume properly when the USB root hub suspends it
  # during S3/S4, causing HID devices (mouse/keyboard) to stop responding even
  # though the Bluetooth link appears "Connected".
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3621", ATTR{power/control}="on"
  '';

  # Replace powerManagement.resumeCommands with a proper systemd service
  # that runs after both suspend (S3) and hibernate (S4) resume.
  # We stop bluetooth, wait for the USB controller to re-appear, then restart.
  systemd.services.bluetooth-resume = {
    description = "Restart Bluetooth after suspend/hibernate";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      ExecStart = [
        "${pkgs.systemd}/bin/systemctl stop bluetooth"
        "${pkgs.coreutils}/bin/sleep 1"
        "${pkgs.systemd}/bin/systemctl start bluetooth"
      ];
    };
  };
}
