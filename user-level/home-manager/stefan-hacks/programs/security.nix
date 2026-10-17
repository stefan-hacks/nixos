# GPG + SSH agent — user-level, replacing system-level programs.gnupg.agent
# (removed from system-level/programs.nix). Restores the legacy behaviour
# (gnupg agent with SSH support) instead of GNOME's gcr-ssh-agent.
{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3; # release-26.05: pinentryPackage -> pinentry.package
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
  };
}
