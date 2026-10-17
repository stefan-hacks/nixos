{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Pin the system registry to the flake's nixpkgs: `nix search nixpkgs`,
    # `nix-shell '<nixpkgs>'` & co. now track nixos-26.05 from flake.lock
    # instead of the (per-user) channels.
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  # Ported from the legacy configuration.nix (was channel-based, daily 04:00,
  # no auto-reboot). Flake variant: builds the nixosConfiguration whose name
  # matches the machine's hostname from the PUSHED main branch of the repo —
  # so it only picks up committed state, matching the old channel semantics.
  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    allowReboot = false; # set true to auto-reboot when kernel/initrd/modules change
    flake = "github:stefan-hacks/nixos";
  };
}
