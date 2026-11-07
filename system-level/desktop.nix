# Desktop environment — GNOME on X11
{ pkgs, inputs, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # GNOME Desktop
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.dconf.enable = true;

  # wall-nix GDM theming (system-level)
  imports = [ inputs.wall-nix.nixosModules.default ];

  services.displayManager.gdm.wallNix = {
    enable = true;
    background = ../assets/wallpapers/nixos_wallpapers/nix-wallpaper-waterfall.png;
    colors = 5;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # GNOME Extensions
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    dynamic-music-pill
    pomodoro-timer
    quick-settings-audio-panel
    quake-terminal
    steal-my-focus-window
    user-themes
    vitals
  ];
}
