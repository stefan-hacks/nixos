# Systemd hardening for leaf services that process untrusted input or logs.
# Core infrastructure (display-manager, dbus, udev, NetworkManager, etc.)
# is intentionally NOT touched — those services need full root and device access.
_: {
  # nscd / nsncd — name service cache; only needs system paths for DNS/user lookups
  systemd.services.nscd.serviceConfig = {
    # ProtectHome is already "read-only" in the NixOS nscd module — do not override
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    SystemCallArchitectures = "native";
  };
}
