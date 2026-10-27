# Virtualization support
{pkgs, ...}: {
  # libvirtd — QEMU/KVM hypervisor daemon
  virtualisation.libvirtd = {
    enable = true;
    # "start" ensures the daemon runs at boot, allowing autostart networks to initialize properly
    onBoot = "start";
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      # This helper ensures the user-space emulator can hook into network bridge interfaces
      verbatimConfig = ''
        bridge_helper = "${pkgs.qemu}/libexec/qemu-bridge-helper"
      '';
    };
  };

  # virt-manager GUI
  programs.virt-manager.enable = true;

  # SPICE USB redirection (for USB device passthrough to VMs)
  virtualisation.spiceUSBRedirection.enable = true;

  # Ensure user can manage VMs without sudo
  users.users.stefan-hacks.extraGroups = ["libvirtd" "kvm"];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    qemu_kvm
    libguestfs
  ];
}
