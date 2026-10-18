# Hermes Agent — desktop AI assistant
# IMPORTANT: services.hermes-agent is NOT in nixpkgs 26.05. It was previously
# provided by the flake input github:NousResearch/hermes-agent.
# In this non-flake setup we reference the existing store derivation directly.
# If the store path is garbage-collected, rebuild from a flake checkout first.
{ config, lib, pkgs, ... }:

let
  # Store path from the last flake build. Replace with a proper source build
  # (fetchFromGitHub + buildPythonPackage) if this path disappears.
  hermes-agent = pkgs.runCommand "hermes-agent" {} ''
    mkdir -p $out
    cp -r ${/nix/store/paijdg6jkza5lahajx5s8k3hkkirbpdr-hermes-agent-0.0.0}/* $out/
  '';
in
{
  environment.systemPackages = [ hermes-agent ];

  # Optional systemd user service (previously provided by the flake module).
  # The service needs OPENAI_API_KEY set, even for local Ollama.
  # Create ~/.config/hermes/env with:
  #   OPENAI_API_KEY=placeholder
  # and adjust ExecStart to source it, or run hermes-agent interactively.
  systemd.user.services.hermes-agent = {
    description = "Hermes Agent";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${hermes-agent}/bin/hermes-agent";
      Restart = "on-failure";
    };
  };
}
