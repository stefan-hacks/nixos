{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system.nix
  ];

  networking.hostName = "ghost";

  # LUKS encrypted root (shared UUID with titan)
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  system.stateVersion = "26.05";
}
