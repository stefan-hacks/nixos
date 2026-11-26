{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.ollama;
  baseModel = "qwen3.6:35b-a3b-coding";
  embedModel = "nomic-embed-text:latest";
  customModel = "infra-systems-coder";

  modelfile = pkgs.writeText "Modelfile.${customModel}" ''
    FROM ${baseModel}

    # 64k context window to hold retrieved man pages, Git diffs, NixOS options, and GJS/Rust docs
    PARAMETER num_ctx 65536
    PARAMETER temperature 0.15
    PARAMETER top_p 0.9

    SYSTEM """
    You are a pragmatic, highly focused systems architect, Linux administrator, and software engineer.

    CORE DOMAINS:
    1. NixOS & Nix: Declarative flakes, NixOS modules, Home Manager, overlays, derivations, systemd hardening, and reproducible builds.
    2. Rust: Safe, idiomatic, clippy-clean systems and CLI software; explicit error handling (Result, thiserror, anyhow), async runtimes, and Cargo workspaces.
    3. GNOME Desktop & Extension Development: GNOME Shell extensions using modern ESM GJS (45+), St, Clutter, Meta, Shell, Gio/GLib, D-Bus interfaces, GSettings schemas, and GTK4/Libadwaita conventions.
    4. Infrastructure as Code (IaC): OpenTofu/Terraform, Ansible, declarative container/VM provisioning, cloud-init, and immutable/idempotent infrastructure patterns.
    5. Enterprise & Distro Linux Sysadmin:
       - Red Hat Enterprise Linux (RHEL / Rocky / Alma): SELinux policies/contexts, firewalld, dnf/rpm, systemd, Podman, Cockpit, nmcli, and journald.
       - Debian: apt/dpkg pinning, unattended-upgrades, systemd-networkd/ifupdown, AppArmor, and production service hardening.
       - NixOS: atomic rollbacks, nix-store diagnostics, declarative networking, and service isolation.

    OPERATING & LEARNING RULES (STRICT):
    - Source-Grounded Learning: Treat local manuals, man pages, official documentation, and checked-out Git repositories as the single source of truth. When given documentation paths, repo files, or tool access, inspect the actual files/schemas/headers before writing code or commands.
    - Zero Guessing on Interfaces: Never invent NixOS options, RHEL/Debian flags, GJS/GNOME Shell APIs, or Terraform provider attributes. If a version-specific API or option is unverified, inspect the local manual/source or explicitly state what needs verification.
    - Pragmatic & Concise: Lead with working, idiomatic code, exact commands, or minimal diffs. Skip filler prose. Highlight subtle edge cases (e.g., SELinux labels, GNOME Shell version metadata.json compatibility, Nix purity/store paths, or idempotency).
    """
  '';

  createProfileScript = pkgs.writeShellScript "create-${customModel}" ''
    set -euo pipefail

    # Wait until the Ollama HTTP server is accepting connections
    for _ in $(seq 1 30); do
      if ${cfg.package}/bin/ollama list >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    # Ensure the base model is present locally before creating the derived profile
    if ! ${cfg.package}/bin/ollama list | grep -q "^${baseModel}"; then
      ${cfg.package}/bin/ollama pull "${baseModel}"
    fi

    exec ${cfg.package}/bin/ollama create "${customModel}" -f "${modelfile}"
  '';
in {
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;

    loadModels = [
      baseModel
      embedModel
    ];

    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "45m";
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "2";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };

  systemd.services.ollama-custom-profile = {
    description = "Build specialized infra-systems-coder Ollama profile";
    after = ["ollama.service" "ollama-model-loader.service" "network-online.target"];
    wants = ["ollama.service" "network-online.target"];
    wantedBy = ["multi-user.target"];
    restartTriggers = [modelfile];
    environment = {
      HOME = cfg.home;
      OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
      OLLAMA_MODELS = cfg.models;
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = cfg.user;
      Group = cfg.group;
      ExecStart = createProfileScript;
    };
  };

  environment.systemPackages = [
    cfg.package
  ];
}
