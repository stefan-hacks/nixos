{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Logging
  services.logrotate = {
    enable = true;
    # Native NixOS options wrap formatting neatly without defaulting to dry-run states
  };

  security.auditd.enable = true;

  security.audit = {
    # Rules to log.
    rules = [
      # Log all sudo usage.
      "-a always,exit -F arch=b64 -S setuid -S setgid -k privilege-escalation"

      # Log all file deletions in /etc.
      "-w /etc/ -p wa -k etc-modifications"

      # Log SSH key file access.
      "-w /etc/ssh/ -p wa -k ssh-key-access"

      # Log all authentication attempts.
      "-w /var/log/auth.log -p wa -k auth-log-access"
    ];
  };
}
