# Hermes Agent — desktop AI assistant
# =============================================================================
# IMPORTANT BUILD LIMITATION (nixpkgs 26.05)
# -----------------------------------------------------------------------------
# hermes-agent is NOT in nixpkgs 26.05. The upstream repo (NousResearch/
# hermes-agent) builds via a flake using uv2nix + pyproject.nix, which
# resolve ~17 Python dependencies from PyPI exact pins.
#
# A proper fetchFromGitHub + buildPythonPackage derivation would require
# packaging all of these deps in nixpkgs first:
#   openai, certifi, truststore, python-dotenv, fire, httpx[socks], rich,
#   tenacity, tomli-w, ruamel.yaml, requests, jinja2, firecrawl-anydoc,
#   pydantic, prompt_toolkit, croniter, snowballstemmer
#
# nixpkgs 26.05's python314Packages set is too minimal for this today.
#
# OPTIONS:
# 1. Store-path bridge (below) — references the existing build from the
#    previous flake era. Works now; breaks if GC'd.
# 2. Re-enable flakes and import github:NousResearch/hermes-agent — the
#    upstream-supported path.
# 3. Wait for nixpkgs unstable to land the Python deps, then write a
#    proper buildPythonPackage derivation.
# =============================================================================
{ config, lib, pkgs, ... }:

let
  # These store paths come from the last flake-based build. They must be
  # kept alive (e.g. via nix-store --add-root) to survive GC.
  # To pin: sudo nix-store --add-root /nix/var/nix/gcroots/hermes-agent \
  #   /nix/store/paijdg6jkza5lahajx5s8k3hkkirbpdr-hermes-agent-0.0.0
  hermes-agent = pkgs.runCommand "hermes-agent"
    {
      src = /nix/store/paijdg6jkza5lahajx5s8k3hkkirbpdr-hermes-agent-0.0.0;
    }
    ''
      cp -r $src $out
    '';

  hermes-desktop = pkgs.runCommand "hermes-desktop"
    {
      src = /nix/store/3iswj33zx4plnqwxxzpbzqknl3xfqakx-hermes-desktop-0.0.0;
    }
    ''
      cp -r $src $out
    '';
in
{
  environment.systemPackages = [ hermes-agent hermes-desktop ];
}
