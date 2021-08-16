{ pkgs, config, ... }:

{
  imports = [ ./metrics.nix ./grafana.nix ./prometheus.nix ];
}
