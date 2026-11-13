# Printing services
{pkgs, ...}: {
  # CUPS print server
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
    # Disable remote printer discovery — reduces attack surface;
    # browse-enabled printers can be exploited via network scanning
    browsed.enable = false;
  };
}
