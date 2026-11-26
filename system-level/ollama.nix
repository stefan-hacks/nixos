{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.ollama;
  baseModel = "qwen3:4b";
  embedModel = "nomic-embed-text:latest";
  customModel = "infra-systems-coder";

  # Optional: Once you train a GGUF LoRA adapter on your NixOS/Rust/GJS/RHEL/Debian docs,
  # point `adapterPath` to it and uncomment the `ADAPTER` line in `modelfile` below.
  # adapterPath = "/var/lib/ollama/adapters/infra-systems-lora.gguf";

  modelfile = pkgs.writeText "Modelfile.${customModel}" ''
    FROM ${baseModel}
    # ADAPTER /var/lib/ollama/adapters/infra-systems-lora.gguf

    # Hermes requires >=64k context so its full tool schema & memory prompts aren't truncated
    PARAMETER num_ctx 65536
    # Pin to the 4 physical CPU cores on the HP EliteBook G8
    PARAMETER num_thread 4
    PARAMETER temperature 0.15
    PARAMETER top_p 0.9

    SYSTEM """
    /no_think
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
    - Source-Grounded Learning: Treat local manuals, man pages, official documentation, and checked-out Git repositories as the single source of truth. Inspect actual files/schemas/headers before writing code or commands.
    - Zero Guessing on Interfaces: Never invent NixOS options, RHEL/Debian flags, GJS/GNOME Shell APIs, or Terraform provider attributes. If unverified, inspect the local manual/source or state what needs verification.
    - Pragmatic & Concise: Respond directly without internal monologues. Lead with working code, exact commands, or minimal diffs.
    """
  '';

  createProfileScript = pkgs.writeShellScript "create-${customModel}" ''
    set -euo pipefail

    for _ in $(seq 1 30); do
      if ${cfg.package}/bin/ollama list >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

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
