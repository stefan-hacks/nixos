# Podman + declarative containers (system-level)
# Provides a Debian and Rocky Linux container accessible via SSH on localhost ports.
{pkgs, ...}: {
  # ── Podman daemonless container engine ──
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # `docker` → `podman` alias
    defaultNetwork.settings.dns_enabled = true; # DNS for inter-container comms
  };

  virtualisation.containers.enable = true;

  # ── Declarative containers via podman backend ──
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    debian = {
      image = "docker.io/library/debian:bookworm-slim";
      autoStart = true;
      ports = ["127.0.0.1:2222:22"];
      volumes = [
        "/home/stefan-hacks/.ssh:/tmp/host-ssh:ro"
      ];
      # Run setup inside the container (no access to host /nix/store)
      cmd = [
        "bash"
        "-c"
        ''
          set -e
          export DEBIAN_FRONTEND=noninteractive
          apt-get update -qq
          apt-get install -y -qq openssh-server

          mkdir -p /var/run/sshd

          {
            echo "PermitRootLogin yes"
            echo "PasswordAuthentication yes"
          } >> /etc/ssh/sshd_config

          echo 'root:root' | chpasswd

          [ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -A

          exec /usr/sbin/sshd -D
        ''
      ];
    };

    rocky = {
      image = "docker.io/library/rockylinux:9";
      autoStart = true;
      ports = ["127.0.0.1:2223:22"];
      volumes = [
        "/home/stefan-hacks/.ssh:/tmp/host-ssh:ro"
      ];
      cmd = [
        "bash"
        "-c"
        ''
          set -e
          dnf install -y openssh-server

          mkdir -p /var/run/sshd

          {
            echo "PermitRootLogin yes"
            echo "PasswordAuthentication yes"
          } >> /etc/ssh/sshd_config

          echo 'root:root' | chpasswd

          [ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -A

          exec /usr/sbin/sshd -D
        ''
      ];
    };
  };

  # ── Tooling ──
  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    buildah
    skopeo
  ];

  users.users."stefan-hacks".extraGroups = ["podman"];
}
