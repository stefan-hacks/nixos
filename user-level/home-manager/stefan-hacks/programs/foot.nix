# foot.nix — Home Manager foot terminal
{ config, lib, pkgs, ... }:

{
  programs.foot = {
    enable = true;
  };
}
