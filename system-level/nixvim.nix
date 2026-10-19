# Nixvim — declarative Neovim configuration via builtins.fetchGit.
# This is the non-flake way to pull in the nixvim module.
# We pin to the nixos-26.05 branch to match our nixpkgs version.
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

    # Catppuccin Mocha theme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    # Status line
    plugins.lualine = {
      enable = true;
    };
  };
}
