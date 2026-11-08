# I²C / DDC support for external monitor brightness control
{pkgs, ...}: {
  # Enable I²C bus support (required for DDC/CI communication with monitors)
  hardware.i2c.enable = true;

  # Load the i2c-dev kernel module at boot
  boot.kernelModules = ["i2c-dev"];

  # ddcutil — CLI tool for DDC/CI monitor control
  environment.systemPackages = [pkgs.ddcutil];
}
