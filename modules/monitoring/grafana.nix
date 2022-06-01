{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.monitoring-server.grafana;
in
{

  imports = [ (mkRenamedOptionModule [ "mayniklas" "services" "monitoring-server" "dashboard" ] [ "mayniklas" "services" "monitoring-server" "grafana" ]) ];

  options.mayniklas.services.monitoring-server.grafana = {

    enable = mkEnableOption "Grafana dashboard";

    openFirewall = mkEnableOption "Open firewall for Grafana";

    nginx = mkEnableOption "enable nginx for grafana";

    domain = mkOption {
      type = types.str;
      default = "status.nik-ste.de";
      example = "dashboards.myhost.com";
      description = "Domain for grafana";
    };

  };

  config = mkIf cfg.enable {

    # No need to support plain HTTP, forcing TLS for all vhosts. Certificates
    # provided by Let's Encrypt via ACME. Generation and renewal is automatic
    # if DNS is set up correctly for the (sub-)domains.
    services.nginx.virtualHosts = mkIf cfg.nginx {

      # Graphana
      "${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          allow 10.88.88.0/24;
          allow 192.168.5.0/24;
          deny all; # deny all remaining ips
        '';
        locations."/" = { proxyPass = "http://127.0.0.1:9005"; };
      };

    };

    # # Grafana image renderer (using Chromium)
    # # changing render size does not work!!
    # services.grafana-image-renderer = {
    #   enable = true;
    #   settings.rendering = {
    #     height = 1080;
    #     width = 1920;
    #   };
    #   settings.rendering.args = [ "--no-sandbox" "--window-size=1920x1080" ];
    # };

    # Graphana fronend
    services.grafana = {
      enable = true;
      domain = cfg.domain;
      # Default is 3000
      port = 9005;
      addr = "127.0.0.1";
      auth.anonymous.enable = true;

      provision.datasources = [
        {
          name = "Prometheus localhost";
          url = "http://localhost:9090";
          type = "prometheus";
          isDefault = true;
        }
        {
          name = "loki";
          url = "http://localhost:3100";
          type = "loki";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 9005 ];

  };
}
