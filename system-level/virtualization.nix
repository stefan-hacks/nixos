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
    # On-demand daemon: starts only when virt-manager connects
    onBoot = "ignore";
    onShutdown = "shutdown";
    # Default to QEMU/KVM (not Xen)
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      # OVMF firmware is included by default in NixOS 26.05+
    };
  };

  # virt-manager GUI
  programs.virt-manager.enable = true;

  # SPICE USB redirection (for USB device passthrough to VMs)
  virtualisation.spiceUSBRedirection.enable = true;

  # Ensure user can manage VMs without sudo
  users.users.stefan-hacks.extraGroups = ["libvirtd"];
}
