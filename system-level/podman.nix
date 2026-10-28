# Podman + declarative containers (system-level)
# Provides a Debian and Rocky Linux container accessible via SSH on localhost ports.
{ pkgs, ... }: let
  sshSetupScript = pkgs.writeShellScriptBin "container-ssh-setup" ''
    set -e
    # Install OpenSSH server (Debian vs Rocky paths differ)
    if command -v apt-get >/dev/null 2>&1; then
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -qq
      apt-get install -y -qq openssh-server >/dev/null 2>&1
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y openssh-server >/dev/null 2>&1
    elif command -v yum >/dev/null 2>&1; then
      yum install -y openssh-server >/dev/null 2>&1
    fi

    mkdir -p /root/.ssh /var/run/sshd
    chmod 700 /root/.ssh

    # Authorise the host user's public key if mounted
    for key in /root/.ssh/id_ed25519.pub /root/.ssh/id_rsa.pub /root/.ssh/id_ecdsa.pub; do
      if [ -f "$key" ]; then
        cp "$key" /root/.ssh/authorized_keys
        chmod 600 /root/.ssh/authorized_keys
        break
      fi
    done

    # Force key-only auth for root
    {
      echo "PermitRootLogin prohibit-password"
      echo "PasswordAuthentication no"
      echo "PubkeyAuthentication yes"
    } >> /etc/ssh/sshd_config

    # Generate host keys if missing (containers often ship without them)
    if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
      ssh-keygen -A
    fi

    exec /usr/sbin/sshd -D
  '';
in {
  # ── Podman daemonless container engine ──
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;                     # `docker` → `podman` alias
    defaultNetwork.settings.dns_enabled = true; # DNS for inter-container comms
  };

  virtualisation.containers.enable = true;

  # ── Declarative containers via podman backend ──
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    debian = {
      image = "docker.io/library/debian:bookworm-slim";
      autoStart = true;
      ports = [ "127.0.0.1:2222:22" ];
      volumes = [
        "/home/stefan-hacks/.ssh:/root/.ssh:ro"
      ];
      cmd = [ "${sshSetupScript}/bin/container-ssh-setup" ];
    };

    rocky = {
      image = "docker.io/library/rockylinux:9";
      autoStart = true;
      ports = [ "127.0.0.1:2223:22" ];
      volumes = [
        "/home/stefan-hacks/.ssh:/root/.ssh:ro"
      ];
      cmd = [ "${sshSetupScript}/bin/container-ssh-setup" ];
    };
  };

  # ── Tooling ──
  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    buildah
    skopeo
  ];

  # Allow stefan-hacks to manage rootless podman too
  users.users."stefan-hacks".extraGroups = [ "podman" ];
}
