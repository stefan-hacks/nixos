# wall-nix declarative GNOME/GDM theming from wallpaper
{...}: {
  programs.wall-nix = {
    enable = true;
    wallpaper = ../../../../assets/wallpapers/nixos_wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png;
    gdmBackground = ../../../../assets/wallpapers/nixos_wallpapers/gdm_blur.png;
    colors = 5;
    autoSwitch = true;
  };
}
