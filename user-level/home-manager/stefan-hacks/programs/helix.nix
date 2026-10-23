# helix.nix — Home Manager helix configuration
{ config, lib, pkgs, ... }:

{
  programs.helix = {
    enable = true;
  };
}
