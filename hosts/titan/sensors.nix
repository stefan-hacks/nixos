# hosts/titan/sensors.nix — Per-host hardware sensor modules.
# Detected on AZW SER (AMD Ryzen 7 6800H) via `sudo sensors-detect`.
{ config, lib, pkgs, ... }:

{
  # AMD Zen 3+ thermal sensors (Ryzen 7 6800H)
  # ITE IT8613E Super I/O (fan speed / voltage / motherboard sensors).
  # sensors-detect reported: "Found `ITE IT8613E Super IO Sensors`"
  # The upstream `it87` driver supports IT8613E in kernel 6.6+; if it fails
  # to auto-probe, force-load with:
  #   sudo modprobe it87 force_id=0x8613
  boot.kernelModules = [ "k10temp" "it87" ];

  # Optional: force the ITE chip ID if auto-detection fails.
  # Uncomment after testing if `sensors` shows no fan data:
  # boot.extraModprobeConfig = ''
  #   options it87 force_id=0x8613
  # '';
}
