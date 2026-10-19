# Nixvim — declarative Neovim configuration via builtins.fetchGit.
# This is the non-flake way to pull in the nixvim module.
{ config, lib, pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-26.05";
  });
in
{
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Add your Nixvim settings here.
    # Example:
    # colorschemes.catppuccin.enable = true;
    # plugins.lualine.enable = true;
  };
}
