# Fail2ban intrusion prevention
_: {
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      maxtime = "7d";
      overalljails = true;
    };

    jails.sshd.settings = {
      enabled = true;
      maxretry = 5;
      findtime = 600;
      bantime = 3600;
    };
  };

  # Harden fail2ban — leaf service that only reads logs and updates firewall rules
  systemd.services.fail2ban.serviceConfig = {
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictRealtime = true;
    LockPersonality = true;
  };
}
