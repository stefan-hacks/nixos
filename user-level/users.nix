# User accounts and per-user system configuration.
# Multi-user support: add additional entries to users.users as needed.
{ config, lib, pkgs, ... }:

{
  # When to use mutable: Temporary testing, transitioning from another distro.
  # When to use immutable: Production, reproducibility, version control.
  # users.mutableUsers = false;

  users.users."stefan-hacks" = {
    isNormalUser = true;

    # Set password interactively with `passwd` after first boot.
    # For declarative password management, consider sops-nix or agenix.
    # hashedPassword = "...";  # DO NOT commit password hashes to git!

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "input"
      "uinput"
      # "dialout"
      # "libvirtd"
    ];

    packages = with pkgs; [
      # Per-user packages go here; most tools are installed system-wide.
      # tree
    ];
  };
}
