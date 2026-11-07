# wall-nix declarative GNOME/GDM theming from wallpaper
{...}: {
  programs.wall-nix = {
    enable = true;
    wallpaper = ../../../../assets/wallpapers/nixos_wallpapers/23970564.png;
    colors = 5;
    variant = "dark";
    kittyTheme = true;
    autoSwitch = true;
  };
}
