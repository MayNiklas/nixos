{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.monitoring-server;
in
{

  options.mayniklas.services.monitoring-server = {
    enable = mkEnableOption "monitoring-server setup";

    blackboxTargets = mkOption {
      type = types.listOf types.str;
      default = [ "https://github.com" ];
      example = [ "https://lounge.rocks" ];
      description = "Targets to monitor with the blackbox-exporter";
    };

    blackboxPingTargets = mkOption {
      type = types.listOf types.str;
      default = [ "10.88.88.2" ];
      example = [ "10.88.88.2" ];
      description = "Targets to monitor with the icmp module";
    };

    nodeTargets = mkOption {
      type = types.listOf types.str;
      default = [ "localhost:9100" ];
      example = [ "hostname.wireguard:9100" ];
      description = "Targets to monitor with the node-exporter";
    };

    shellyTargets = mkOption {
      type = types.listOf types.str;
      default = [ "http://192.168.15.2/status" ];
      example = [ "http://192.168.15.2/status" ];
      description = "Shelly's to monitor with the json-exporter";
    };
  };

  config = mkIf cfg.enable {

    services.prometheus = {
      enable = true;
      extraFlags = [ "--log.level=debug" "--storage.tsdb.retention.size=3GB" ];
      retentionTime = "2y";
      # environmentFile = /var/src/secrets/prometheus/envfile;

      scrapeConfigs = [
        {
          job_name = "json";
          scrape_interval = "10s";
          metrics_path = "/probe";
          static_configs = [{ targets = cfg.shellyTargets; }];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement =
                "127.0.0.1:7979"; # The blackbox exporter's real hostname:port.
            }
          ];
        }
        {
          job_name = "blackbox";
          metrics_path = "/probe";
          params = { module = [ "http_2xx" ]; };
          static_configs = [{ targets = cfg.blackboxTargets; }];

          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement =
                "127.0.0.1:9115"; # The blackbox exporter's real hostname:port.
            }
          ];
        }
        {
          job_name = "icmp";
          metrics_path = "/probe";
          params = { module = [ "icmp" ]; };
          static_configs = [{ targets = cfg.blackboxPingTargets; }];

          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement =
                "127.0.0.1:9115"; # The blackbox exporter's real hostname:port.
            }
          ];
        }
        {
          job_name = "node-stats";
          static_configs = [{ targets = cfg.nodeTargets; }];
        }
      ];
    };
  };
}
