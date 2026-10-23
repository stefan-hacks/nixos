# fastfetch.nix — Home Manager fastfetch system info
{ config, lib, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
  };
}
