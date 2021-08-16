{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.monitoring-server.dashboard;
in {

  options.mayniklas.services.monitoring-server.dashboard = {
    enable = mkEnableOption "Grafana dashboard";
    openFirewall = mkEnableOption "Open firewall for Grafana";
  };

  config = mkIf cfg.enable {
    # Graphana fronend
    services.grafana = {
      enable = true;
      # Default is 3000
      port = 9005;
      addr = "0.0.0.0";
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 9005 ];

  };
}
