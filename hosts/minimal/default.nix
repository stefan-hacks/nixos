{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system-level
  ];

  networking.hostName = "minimal";
}
