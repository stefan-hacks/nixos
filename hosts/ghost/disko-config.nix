# Disko declarative disk layout for ghost
# This template recreates the existing LUKS+LVM layout.
# ghost shares the same cryptroot UUID as titan.
# To use during a fresh install, uncomment the disko import lines in
# hosts/ghost/default.nix and run the disko CLI from a NixOS installer.
#
# Replace /dev/nvme0n1 with the actual target disk before formatting.
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1"; # ← set this to the real disk (lsblk to identify)
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077" "dmask=0077"];
            };
          };

          luks = {
            name = "luks";
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
                uuid = "bcf8be51-1c8a-4da2-8dec-c728b7082e6d";
              };
              content = {
                type = "lvm";
                name = "nixosvg";
                lvs = {
                  root = {
                    size = "100%FREE";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                  swap = {
                    size = "64G";
                    content = {
                      type = "swap";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
