{ config, lib, pkgs, ... }:

{
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

  networking.hostName = "ghost";

  # LUKS encrypted root (shared UUID with titan)
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/8a350d7a-ce96-4ba6-938c-61b2739239f6";
  };

  system.stateVersion = "26.05";

  # Home Manager integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.stefan-hacks = import ../../user-level/home-manager/stefan-hacks;
  };
}
