# wall-nix system-level module — all GNOME/GDM theming in one place.
# This imports the wall-nix NixOS module and configures the GDM login
# background so theming is not scattered across desktop.nix.
{inputs, ...}: {
  imports = [inputs.wall-nix.nixosModules.default];

  services.displayManager.gdm.wallNix = {
    enable = true;
    background = ../assets/wallpapers/nixos_wallpapers/gdm_blur.png;
    colors = 5;
  };
}
