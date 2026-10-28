# hosts/titan/sensors.nix — Per-host hardware sensor modules.
# Detected on AZW SER (AMD Ryzen 7 6800H) via `sudo sensors-detect`.
_: {
  # AMD Zen 3+ thermal sensors (Ryzen 7 6800H)
  boot.kernelModules = ["k10temp"];

  # NOTE: sensors-detect found an ITE IT8613E Super I/O chip at 0xa30,
  # but the upstream `it87` driver fails to bind with "No such device".
  # On this AZW SER mini PC the fan is controlled by the embedded controller
  # (EC) firmware and is NOT exposed through standard hwmon interfaces.
  # This is a hardware/firmware limitation — Vitals will not show fan data.
  #
  # The following modules were attempted and failed:
  #   sudo modprobe it87 force_id=0x8613
  #   sudo modprobe it87 force_id=0x8613 ignore_resource_conflict=1
  #
  # Temperature and power readings (k10temp, amdgpu, nvme) work fine.
}
