# system.nix — Backward-compatible entry point for desktop hosts.
# Simply imports both core and desktop modules.
_: {
  imports = [
    ./system-core.nix
    ./system-desktop.nix
  ];
}
