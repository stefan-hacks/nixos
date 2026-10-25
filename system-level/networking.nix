# Network configuration
{
  ...
}: {
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Avahi — network printing & file sharing, local discovery, local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Automatically installs and configures nss-mdns for IPv4
    openFirewall = true;
  };

  services.mullvad-vpn.enable = true;

  # Fix the "Invalid group-name group='netdev'" D-Bus warning.
  # This declaratively creates the netdev group that Avahi's D-Bus config expects.
  users.groups.netdev = {};
}
