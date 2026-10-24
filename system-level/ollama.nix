# Ollama — local LLM inference server
{
  config,
  lib,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;

    # Listens on localhost only by default (127.0.0.1:11434), which is
    # what nixos/hermes.nix points at. Set this to "0.0.0.0:11434"
    # if you need it reachable from other machines on your network.
    host = "127.0.0.1";
    port = 11434;

    # Pull models automatically on activation (optional).
    # The model must exist in the Ollama library (https://ollama.com/library).
    # Example: loadModels = [ "llama3.2" ];
    loadModels = ["qwen3.5:0.8b"]; # disabled — tag not found in registry

    # Uncomment if you have a GPU and want Ollama to use it.
    # acceleration = "cuda"; # or "rocm"
  };
}
