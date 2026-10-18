{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system.nix
  ];

  networking.hostName = "titan";

  # LUKS encrypted root (shared UUID with ghost)
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  # AMD graphics (titan-specific)
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

  system.stateVersion = "26.05";
}
