# User-specific configuration for stefan-hacks.
# The generic user-module.nix already creates the account and dotfiles service.
# Put ONLY user-specific settings here (extra packages, per-user services, etc.).
{ config, lib, pkgs, primaryUser, ... }:

lib.mkIf (primaryUser == "stefan-hacks") {
  # Example: user-specific packages not worth installing system-wide.
  # users.users.${primaryUser}.packages = with pkgs; [ ];

  # Example: user-specific systemd user services.
  # systemd.user.services.foo = { ... };
}
