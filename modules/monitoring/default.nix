{ pkgs, config, ... }:

{
  imports = [
    ./exporter/blackbox.nix
    ./exporter/esphome.nix
    ./exporter/nginx.nix
    ./exporter/node.nix
    ./exporter/nvidia-dcgm.nix
    ./exporter/pve.nix
    ./exporter/wireguard.nix
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
  ];
}
