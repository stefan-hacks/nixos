# Disko declarative disk layout for titan
# This template recreates the existing LUKS+LVM layout.
# To use during a fresh install, uncomment the disko import lines in
# hosts/titan/default.nix and run the disko CLI from a NixOS installer.
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
                uuid = "8a350d7a-ce96-4ba6-938c-61b2739239f6";
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
                    size = "32G";
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
