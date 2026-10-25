# Virtualization support
{
  config,
  lib,
  pkgs,
  ...
}: {
  # libvirtd — QEMU/KVM hypervisor daemon
  virtualisation.libvirtd = {
    enable = true;
    # "start" ensures the daemon runs at boot, allowing autostart networks to initialize properly
    onBoot = "start";
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # Enable the default NAT network switch natively via NixOS networking
  networking.bridge.enable = true;
  # This helper ensures the user-space emulator can hook into the bridge interfaces
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    bridge_helper = "${pkgs.qemu}/libexec/qemu-bridge-helper"
  '';

  # virt-manager GUI
  programs.virt-manager.enable = true;

  # SPICE USB redirection (for USB device passthrough to VMs)
  virtualisation.spiceUSBRedirection.enable = true;

  # Ensure user can manage VMs without sudo
  users.users.stefan-hacks.extraGroups = ["libvirtd"];
}
