# Desktop environment — GNOME on X11
{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME Desktop
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
}
