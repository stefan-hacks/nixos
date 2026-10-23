# git.nix — Home Manager git configuration
{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
  };
}
