# Firewall configuration
_: {
  networking.firewall = {
    enable = true;
    # Allow TCP ports.
    allowedTCPPorts = [22 80 443];
    # Allow UDP ports.
    allowedUDPPorts = [53];

    # Allow traffic on specific interfaces.
    interfaces."wlp3s0".allowedTCPPorts = [8080];
  };
}
