{ pkgs, config, ... }:

{
  imports = [
    ./exporter/blackbox.nix
    ./exporter/node.nix
    ./grafana.nix
    ./loki.nix
    ./prometheus.nix
  ];
}
