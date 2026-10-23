# starship.nix — Home Manager starship prompt
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
