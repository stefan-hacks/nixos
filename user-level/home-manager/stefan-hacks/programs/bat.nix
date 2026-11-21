# bat.nix — Home Manager bat configuration
# Catppuccin-Mocha theme. Requires bat installed at system-level.
{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header";
      pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
        ".ignore:Git Ignore"
      ];
    };
    extraPackages = [ pkgs.bat-extras.core ];
  };
}
