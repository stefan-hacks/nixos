# Bluetooth configuration
{ config, lib, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
      };
    };
  };
}
