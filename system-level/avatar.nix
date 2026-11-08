# User avatar via AccountsService (system-level, required for GDM/GNOME display).
# AccountsService does NOT read ~/.face on NixOS; it only uses /var/lib/AccountsService/.
{...}: let
  username = "stefan-hacks";
  avatar = ../assets/icon2.png;
in {
  services.accounts-daemon.enable = true;

  systemd.tmpfiles.rules = [
    # Symlink the avatar image into AccountsService icons directory.
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${avatar}"

    # Create the per-user AccountsService config pointing to the icon.
    "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\nSystemAccount=false\\n"
  ];
}
