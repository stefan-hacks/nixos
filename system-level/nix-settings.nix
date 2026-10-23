# Nix package manager settings
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # nixpkgs-unstable overlay — selectively pull newer packages
  # ═══════════════════════════════════════════════════════════════════════════
  # Some packages (e.g. joplin-desktop) need a version newer than what
  # nixos-26.05 stable provides. We import nixpkgs-unstable via flake input
  # and overlay only the packages we need, keeping the rest of the system on stable.
  nixpkgs.overlays = [
    (self: super: {
      joplin-desktop-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.joplin-desktop;
    })
  ];

  # nix.nixPath is used by `nix-shell`, `nix repl`, and tools that use
  # angle-bracket syntax like `<nixpkgs>` and `<nixos-config>`.
  #
  # IMPORTANT: This repo lives in ~/.config/nixos and uses a multi-host
  # modular layout. `nixos-rebuild` must be run from that directory with
  # the -I flag pointing to the correct host entry:
  #
  #   cd ~/.config/nixos
  #   sudo nixos-rebuild switch -I nixos-config=hosts/titan/default.nix
  #
  # The legacy /etc/nixos/configuration.nix is intentionally NOT referenced
  # here — it contains the old monolith and is no longer the source of truth.
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
      # Enable nix-command and flakes experimental features globally.
      # Even without flakes as the primary workflow, these are required by
      # modern tooling (nix search, nix-shell, nh, etc.).
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
