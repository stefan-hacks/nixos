{
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;

    user = "ollama";
    group = "ollama";

    loadModels = [
      "qwen3.5:0.8b"
    ];
  };

  # Work around the NixOS DynamicUser bug.
  systemd.services.ollama.serviceConfig.DynamicUser =
    lib.mkForce false;
}
