{...}: let
  username = "stefan-hacks";
  avatar = ../../../../assets/icon2.png;
in {
  services.accounts-daemon.enable = true;

  systemd.tmpfiles.rules = [
    # Install the avatar into AccountsService.
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${avatar}"

    # Configure the user's avatar.
    "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\nSystemAccount=false\\n"
  ];
}
