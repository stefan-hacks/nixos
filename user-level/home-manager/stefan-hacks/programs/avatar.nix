# User avatar — placed as ~/.face for GNOME/AccountsService pick-up.
# The `.face` approach is less reliable than system-level AccountsService
# configuration, but keeps the avatar under Home Manager (user-level) control.
{...}: {
  home.file.".face".source = ../../../../assets/icon2.png;
}
