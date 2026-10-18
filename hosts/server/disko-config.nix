# Disko declarative disk layout for server
# Simple single-disk ext4 template (no LUKS, no LVM).
# To use during a fresh install, uncomment the disko import lines in
# hosts/server/default.nix and run the disko CLI from a NixOS installer.
#
# Replace /dev/sda with the actual target disk before formatting.

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";   # ← set this to the real disk (lsblk to identify)
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" "dmask=0077" ];
            };
          };

          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
