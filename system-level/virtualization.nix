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

  # Ensure the libvirt 'default' NAT network is created and autostarted.
  # This is required for VM internet access and for virt-manager to start domains.
  systemd.services.libvirt-default-network = {
    description = "Create and autostart libvirt default network";
    wantedBy = ["multi-user.target"];
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "libvirt-default-net-start" ''
        # Wait for libvirtd socket
        for i in $(seq 1 30); do
          if ${pkgs.libvirt}/bin/virsh uri >/dev/null 2>&1; then
            break
          fi
          sleep 1
        done

        # Check if default network exists
        if ! ${pkgs.libvirt}/bin/virsh net-list --all --name | grep -q '^default$'; then
          # Define the default network if it doesn't exist
          ${pkgs.libvirt}/bin/virsh net-define /dev/stdin <<'EOF'
<network>
  <name>default</name>
  <uuid>c4acfd00-4597-41c7-a48e-e2302234fa89</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:02:77:4b'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
EOF
        fi

        # Start and autostart the default network
        ${pkgs.libvirt}/bin/virsh net-start default 2>/dev/null || true
        ${pkgs.libvirt}/bin/virsh net-autostart default
      '';
      ExecStop = pkgs.writeShellScript "libvirt-default-net-stop" ''
        ${pkgs.libvirt}/bin/virsh net-destroy default 2>/dev/null || true
      '';
    };
  };

  # Allow the default libvirt network through the firewall
  networking.firewall.trustedInterfaces = ["virbr0"];

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