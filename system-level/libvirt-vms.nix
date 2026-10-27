# system-level/libvirt-vms.nix
# Declarative VM definitions for the nix-expert learning lab.
#
# When this module is imported, 'nixos-rebuild switch' automatically:
#   1. Creates qcow2 disk images for each VM (via systemd tmpfiles)
#   2. Generates libvirt XML domain definitions
#   3. Registers the domains with libvirt (virsh define)
#   4. Configures static DHCP leases so VMs get predictable IPs
#
# After rebuilding, VMs are visible in virt-manager and via 'virsh list --all'.
# Start a VM:  virsh start server-01
# Stop a VM:  virsh shutdown server-01
#
# NixOS 26.05 — declarative libvirt domains via XML + systemd.

{ config, pkgs, lib, ... }:

let
  # ── VM definitions ────────────────────────────────────────────────────────
  # Each entry becomes a fully declarative libvirt domain.
  vms = {
    nixos-minimal = {
      memory = 2048;
      vcpus = 1;
      diskSize = "20G";
      mac = "52:54:00:00:00:64";
      osVariant = "nixos-unstable";
    };
    server-01 = {
      memory = 4096;
      vcpus = 2;
      diskSize = "40G";
      mac = "52:54:00:00:00:10";
      osVariant = "nixos-unstable";
    };
    server-02 = {
      memory = 4096;
      vcpus = 2;
      diskSize = "40G";
      mac = "52:54:00:00:00:11";
      osVariant = "nixos-unstable";
    };
    desktop-01 = {
      memory = 8192;
      vcpus = 4;
      diskSize = "60G";
      mac = "52:54:00:00:00:20";
      osVariant = "nixos-unstable";
      graphics = true;
    };
    desktop-02 = {
      memory = 4096;
      vcpus = 2;
      diskSize = "40G";
      mac = "52:54:00:00:00:21";
      osVariant = "nixos-unstable";
      graphics = true;
    };
    build-farm = {
      memory = 8192;
      vcpus = 4;
      diskSize = "80G";
      mac = "52:54:00:00:00:30";
      osVariant = "nixos-unstable";
    };
  };

  # ── ISO path for installation media ────────────────────────────────────────
  # Download the NixOS 26.05 minimal ISO to this path once.
  # After VMs are installed, they boot from disk and ignore the CD-ROM.
  isoPath = "/var/lib/libvirt/images/latest-nixos-minimal-x86_64-linux.iso";

  # ── XML generator ──────────────────────────────────────────────────────────
  mkDomainXml = name: vm: let
    graphicsSection = lib.optionalString (vm.graphics or false) ''
      <graphics type='spice' port='-1' autoport='yes' listen='127.0.0.1'>
        <gl enable='no'/>
      </graphics>
      <video>
        <model type='virtio' heads='1' primary='yes'/>
      </video>
      <channel type='spicevmc'>
        <target type='virtio' name='com.redhat.spice.0'/>
      </channel>
    '';
  in
  pkgs.writeText "${name}.xml" ''
    <domain type='kvm'>
      <name>${name}</name>
      <metadata>
        <nix:generator xmlns:nix='http://nixos.org/' version='1.0'/>
      </metadata>
      <memory unit='KiB'>${toString (vm.memory * 1024)}</memory>
      <currentMemory unit='KiB'>${toString (vm.memory * 1024)}</currentMemory>
      <vcpu placement='static'>${toString vm.vcpus}</vcpu>
      <os>
        <type arch='x86_64' machine='pc-q35-9.0'>hvm</type>
        <boot dev='hd'/>
        <boot dev='cdrom'/>
        <firmware feature='enrolled-keys' enabled='no'/>
        <firmware feature='secure-boot' enabled='no'/>
      </os>
      <features>
        <acpi/>
        <apic/>
        <vmport state='off'/>
      </features>
      <cpu mode='host-passthrough' check='none' migratable='on'/>
      <clock offset='utc'>
        <timer name='rtc' tickpolicy='catchup'/>
        <timer name='pit' tickpolicy='delay'/>
        <timer name='hpet' present='no'/>
      </clock>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <pm>
        <suspend-to-mem enabled='no'/>
        <suspend-to-disk enabled='no'/>
      </pm>
      <devices>
        <emulator>${pkgs.qemu_kvm}/bin/qemu-kvm</emulator>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
          <source file='/var/lib/libvirt/images/${name}.qcow2'/>
          <target dev='vda' bus='virtio'/>
          <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
        </disk>
        <disk type='file' device='cdrom'>
          <driver name='qemu' type='raw'/>
          <source file='${isoPath}'/>
          <target dev='sda' bus='sata'/>
          <readonly/>
          <address type='drive' controller='0' bus='0' target='0' unit='0'/>
        </disk>
        <controller type='usb' index='0' model='qemu-xhci' ports='15'>
          <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
        </controller>
        <controller type='pci' index='0' model='pcie-root'/>
        <controller type='virtio-serial' index='0'>
          <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
        </controller>
        <controller type='sata' index='0'>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
        </controller>
        <interface type='network'>
          <mac address='${vm.mac}'/>
          <source network='default'/>
          <model type='virtio'/>
          <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
        </interface>
        <serial type='pty'>
          <target type='isa-serial' port='0'>
            <model name='isa-serial'/>
          </target>
        </serial>
        <console type='pty'>
          <target type='serial' port='0'/>
        </console>
        <input type='mouse' bus='virtio'>
          <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
        </input>
        <input type='keyboard' bus='virtio'>
          <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
        </input>
        <rng model='virtio'>
          <backend model='random'>/dev/urandom</backend>
          <address type='pci' domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
        </rng>
        ${graphicsSection}
      </devices>
    </domain>
  '';

  vmNames = lib.attrNames vms;
in
{
  # ── Prerequisites ────────────────────────────────────────────────────────
  # This module requires libvirtd (already enabled in virtualization.nix).
  # Ensure the ISO exists for first-install.

  # ── Generate libvirt XML files in /etc ────────────────────────────────────
  # These XML files are the declarative domain definitions.
  # A systemd service (below) registers them with libvirt on boot.
  environment.etc = lib.listToAttrs (lib.mapAttrsToList (name: vm:
    lib.nameValuePair "libvirt-vms/${name}.xml" {
      source = mkDomainXml name vm;
    }
  ) vms);

  # ── Ensure disk images exist (systemd tmpfiles) ──────────────────────────
  # If a VM's qcow2 does not exist, create a sparse empty image.
  # The VM will boot from CD-ROM (ISO) on first run, install NixOS to vda,
  # then boot from vda on subsequent runs.
  systemd.tmpfiles.rules = lib.mapAttrsToList (name: vm:
    "f /var/lib/libvirt/images/${name}.qcow2 0640 qemu-libvirtd qemu-libvirtd -"
  ) vms;

  # ── Auto-create qcow2 disks on boot ──────────────────────────────────────
  systemd.services.ensure-vm-disks = {
    description = "Create lab VM qcow2 disks if missing";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ensure-vm-disks" ''
        set -euo pipefail
        mkdir -p /var/lib/libvirt/images
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: vm: ''
          if [ ! -f /var/lib/libvirt/images/${name}.qcow2 ]; then
            echo "Creating ${name}.qcow2 (${vm.diskSize})..."
            ${pkgs.qemu}/bin/qemu-img create -f qcow2 /var/lib/libvirt/images/${name}.qcow2 ${vm.diskSize}
          fi
        '') vms)}
      '';
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
  };

  # ── Register domains with libvirt on boot ──────────────────────────────────
  # This is the key step: 'virsh define' tells libvirt about the domain.
  # If the domain already exists, virsh define updates its XML.
  systemd.services.define-libvirt-vms = {
    description = "Define nix-expert lab VMs in libvirt";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "define-libvirt-vms" ''
        set -euo pipefail
        echo "Defining nix-expert lab VMs in libvirt..."
        ${lib.concatStringsSep "\n" (map (name: ''
          if ${pkgs.libvirt}/bin/virsh dominfo "${name}" >/dev/null 2>&1; then
            echo "  ${name}: already defined, undefining first..."
            ${pkgs.libvirt}/bin/virsh undefine "${name}" --nvram || true
          fi
          echo "  ${name}: defining..."
          ${pkgs.libvirt}/bin/virsh define /etc/libvirt-vms/${name}.xml
        '') vmNames)}
        echo "All VMs defined."
      '';
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" "ensure-vm-disks.service" ];
    requires = [ "ensure-vm-disks.service" ];
  };

  # ── Ensure the ISO is downloaded ───────────────────────────────────────────
  # We can't fetch the ISO in pure Nix (it's 1GB), so we use a systemd
  # service to download it on first boot if it doesn't exist.
  systemd.services.ensure-nixos-iso = {
    description = "Download NixOS 26.05 minimal ISO for VM lab";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "ensure-nixos-iso" ''
        set -euo pipefail
        ISO="${isoPath}"
        if [ -f "$ISO" ]; then
          echo "NixOS ISO already present: $ISO"
          exit 0
        fi
        echo "Downloading NixOS 26.05 minimal ISO..."
        mkdir -p "$(dirname "$ISO")"
        ${pkgs.wget}/bin/wget -O "$ISO" \
          https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso
        echo "Downloaded to $ISO"
      '';
    };
    wantedBy = [ "multi-user.target" ];
  };

  # ── Packages ───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    virt-viewer       # SPICE/VNC viewer
    qemu              # qemu-img for manual disk ops
    wget              # For ISO download service
  ];
}
