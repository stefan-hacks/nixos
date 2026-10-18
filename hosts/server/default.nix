{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system.nix
  ];

  networking.hostName = "server";

  # Server-specific services belong here
  # or in dedicated modules imported here.

  system.stateVersion = "26.05";
}
