<<<<<<< HEAD
{inputs, ...}: {
=======
{ ...}: {
>>>>>>> 363fa343c3f1e9d875ec6f6f9a8c7f199f9ff21e
  imports = [
    ./hardware-configuration.nix
    ../../system.nix

    # ── Disko (uncomment during initial install only) ──
    # Imports the disko module from nix-community/disko and the declarative
    # disk layout for this host.  Remove/comment these lines after the first
    # install — the generated hardware-configuration.nix already contains the
    # fileSystems and swapDevices that NixOS needs for day-to-day rebuilds.
    #
    # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    # ./disko-config.nix
  ];

  networking.hostName = "server";

  # Server-specific services belong here
  # or in dedicated modules imported here.

  system.stateVersion = "26.05";
}
