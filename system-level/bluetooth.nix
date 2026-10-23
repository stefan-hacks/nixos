# Bluetooth configuration
# Addresses post-suspend/hibernate HID reconnection failures (e.g. Logitech MX Master 3S).
# The Bluetooth controller resumes but BlueZ does not re-trigger HID enumeration.
# Fix: restart bluetooth.service after resume + kernel-side HID handling.
{
  config,
  lib,
  pkgs,
  ...
}: let
  # MX Master 3S MAC address — used by the reconnect hook after resume.
  mxMasterMac = "D4:10:D5:87:B1:6E";
in {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Experimental mode improves BLE HID support (required by MX Master 3S).
        Experimental = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Ensure the Logitech HID++ driver is loaded early for BT HID devices
  # (MX Master 3S, MX Keys, etc.).
  boot.kernelModules = ["hid_logitech_hidpp"];

  # Load btusb in initrd so the Bluetooth controller is initialised early
  # after hibernate (S4), where the kernel must re-enumerate USB devices
  # before userspace is available.
  boot.initrd.kernelModules = ["btusb"];

  # Disable USB autosuspend for the MediaTek Bluetooth controller (13d3:3621).
  # This controller fails to resume properly when the USB root hub suspends it
  # during S3/S4, causing HID devices (mouse/keyboard) to stop responding even
  # though the Bluetooth link appears "Connected".
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3621", ATTR{power/control}="on"
  '';

  # ═══════════════════════════════════════════════════════════════════════════
  # Post-resume: restart bluetooth.service after suspend/hibernate.
  # The controller loses power on resume and re-runs firmware setup,
  # but bluetoothd never notices. Restarting the daemon re-syncs state.
  # If restart alone doesn't reconnect the mouse, we fall back to an
  # explicit bluetoothctl connect after a short delay.
  # ═══════════════════════════════════════════════════════════════════════════
  systemd.services.bluetooth-resume = {
    description = "Restart Bluetooth after suspend/hibernate";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    serviceConfig = {
      Type = "oneshot";
      # Give the USB controller time to finish re-initialising before
      # touching bluetoothd. 3s is the sweet spot for the MediaTek chip.
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart bluetooth.service";
    };
  };

  # Optional fallback: explicitly reconnect the mouse if the restart
  # doesn't auto-reconnect it. This runs 5 seconds after the restart.
  # To test whether this is needed, run manually after a failed resume:
  #   bluetoothctl connect D4:10:D5:87:B1:6E
  # If that works instantly, uncomment the block below.
  #
  # systemd.services.bluetooth-reconnect-mxmaster = {
  #   description = "Reconnect MX Master 3S after resume";
  #   after = [ "bluetooth-resume.service" ];
  #   wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
  #     ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect ${mxMasterMac}";
  #   };
  # };
}
