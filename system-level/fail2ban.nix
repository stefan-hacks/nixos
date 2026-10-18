# Fail2ban intrusion prevention
{ config, lib, pkgs, ... }:

{
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
}
