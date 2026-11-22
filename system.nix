# system.nix — Backward-compatible entry point for desktop hosts.
# Simply imports both core and desktop modules.
_: {
  imports = [
    ./system-level/system-core.nix
    ./system-level/system-desktop.nix
  ];
}
