# Nix package manager settings
{ inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Register the flake's locked nixpkgs in the Nix registry so
  # `nix run nixpkgs#foo` uses the exact same nixpkgs revision.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Legacy nixPath for tools that still use angle-bracket syntax.
  # Points to the flake registry entry above rather than a channel.
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

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
