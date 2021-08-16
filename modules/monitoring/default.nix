{ pkgs, config, ... }:

{
  imports = [ ./metrics.nix ./grafana.nix ];
}
