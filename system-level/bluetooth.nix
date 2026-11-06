# Bluetooth: MX Master 3S reconnect after suspend/hibernate.
# After resume, bluetoothd's background scan doesn't pick the mouse up until
# discovery is started (which GNOME's settings pane does). Do that ourselves.
{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Stop the MediaTek controller being USB-autosuspended (can't resume cleanly).
  boot.extraModprobeConfig = "options btusb enable_autosuspend=0";

  # Covers suspend, hibernate, hybrid-sleep and suspend-then-hibernate.
  systemd.services.bluetooth-resume = {
    description = "Kick Bluetooth discovery after resume";
    wantedBy = ["post-resume.target"];
    after = ["post-resume.target" "bluetooth.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      sleep 2
      ${pkgs.bluez}/bin/bluetoothctl --timeout 20 scan on
    '';
  };
}
