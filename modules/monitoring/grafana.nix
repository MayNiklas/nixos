{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.monitoring-server.dashboard;
in {

  options.mayniklas.services.monitoring-server.dashboard = {
    enable = mkEnableOption "Grafana dashboard";
    openFirewall = mkEnableOption "Open firewall for Grafana";

    domain = mkOption {
      type = types.str;
      default = "status.nik-ste.de";
      example = "dashboards.myhost.com";
      description = "Domain for grafana";
    };
  };

  config = mkIf cfg.enable {
    # Graphana fronend
    services.grafana = {
      enable = true;
      domain = cfg.domain;
      # Default is 3000
      port = 9005;
      addr = "127.0.0.1";

      provision.datasources = [{
        name = "Prometheus localhost";
        url = "http://localhost:9090";
        type = "prometheus";
        isDefault = true;
      }];
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 9005 ];

  };
}
