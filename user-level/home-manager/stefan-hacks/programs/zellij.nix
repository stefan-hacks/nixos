# zellij.nix — Home Manager zellij terminal multiplexer
{ config, lib, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
  };
}
