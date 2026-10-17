{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system-level
  ];

  networking.hostName = "server";

  # Server-specific services belong here
  # or in dedicated modules imported here.
  system.stateVersion = "26.05";
}
