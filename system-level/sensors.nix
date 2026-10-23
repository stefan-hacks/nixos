# system-level/sensors.nix — Hardware sensor support for lm_sensors and Vitals
{
  config,
  lib,
  pkgs,
  ...
}: {
  # lm_sensors and libgtop are already in packages.nix (required by Vitals).
  # This module loads the kernel drivers needed for fan/temperature/voltage
  # readings. The exact modules depend on your motherboard's Super I/O chip.
  #
  # To find your exact modules, run:
  #   sudo sensors-detect
  # and add any it suggests to the list below.
  #
  boot.kernelModules = [
    # Intel CPU temperature
    "coretemp"

    # AMD CPU temperature (comment out coretemp if on AMD)
    # "k10temp"

    # Common Super I/O chips for fan speed / voltage / motherboard sensors.
    # Only the one matching your board will load; the rest will safely fail.
    "nct6775" # Nuvoton — common on ASUS, MSI, Gigabyte
    "nct6683"
    "it87" # ITE — common on older ASUS, Gigabyte
    "f71882fg" # Fintek
  ];

  # The sensors command reads from /sys/class/hwmon/*.
  # udev already handles permissions, but ensure lm_sensors is available.
  environment.systemPackages = lib.mkBefore [];
}
