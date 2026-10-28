# Single-node Kubernetes practice cluster via k3s.
# Auto-deploys a 3-replica nginx Deployment + Service on startup.
{pkgs, ...}: {
  # ── K3s lightweight Kubernetes ──
  services.k3s = {
    enable = true;
    role = "server";
    # Make kubeconfig world-readable so kubectl works without sudo
    extraFlags = "--write-kubeconfig-mode 644";

    # Auto-deploy manifest — k3s watches /var/lib/rancher/k3s/server/manifests
    manifests.nginx = {
      enable = true;
      content = [
        {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "nginx-deployment";
            namespace = "default";
          };
          spec = {
            replicas = 3;
            selector = {
              matchLabels.app = "nginx";
            };
            template = {
              metadata.labels.app = "nginx";
              spec.containers = [
                {
                  name = "nginx";
                  image = "nginx:latest";
                  ports = [{containerPort = 80;}];
                }
              ];
            };
          };
        }
        {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            name = "nginx-service";
            namespace = "default";
          };
          spec = {
            selector.app = "nginx";
            ports = [
              {
                protocol = "TCP";
                port = 80;
                targetPort = 80;
              }
            ];
            type = "ClusterIP";
          };
        }
      ];
    };
  };

  # ── Kubernetes tooling ──
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    k9s
    stern
    kubectx
  ];

  # Default kubectl to k3s kubeconfig (now world-readable)
  environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
