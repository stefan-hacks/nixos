# Desktop environment — GNOME on X11
{pkgs, ...}: {
  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.dconf.enable = true;

  # GNOME Extensions
  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    quake-terminal
    steal-my-focus-window
    user-themes
  ];
}
