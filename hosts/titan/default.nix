{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Shared operating-system configuration
    ../../system-level

    # Desktop-specific operating-system configuration
    ../../desktops/gnome

    # Host-specific modules can be added here
  ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  # Ensure graphics drivers are properly mapped
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL support for AMD
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  networking.hostName = "titan"; # Define your hostname.

  system.stateVersion = "26.05";
}
