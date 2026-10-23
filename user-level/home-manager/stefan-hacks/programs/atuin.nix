# atuin.nix — Home Manager atuin shell history
{ config, lib, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };
}
