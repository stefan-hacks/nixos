# starship.nix — Home Manager starship prompt
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    # Full TOML config embedded via settings
    settings = {
      # Add your starship settings here or keep defaults
      # The previous starship.toml had custom config — migrate key settings
    };
  };
}
