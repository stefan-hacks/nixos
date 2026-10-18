{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system.nix
  ];

  networking.hostName = "minimal";

  system.stateVersion = "26.05";
}
