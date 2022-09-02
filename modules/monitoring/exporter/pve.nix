{ lib, pkgs, config, self, ... }:
with lib;
let cfg = config.mayniklas.metrics.pve;
in
{

  options.mayniklas.metrics.pve = {

    enable = mkEnableOption "prometheus pve-exporter metrics";

    configure-prometheus =
      mkEnableOption "enable pve-exporter in prometheus";

    port = mkOption {
      type = types.port;
      default = 9221;
      description = ''
        Port being used for prometheus pve-exporter
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "10.88.88.1";
      description = "Address being used for prometheus pve-exporter";
    };

    targets = mkOption {
      type = types.listOf types.str;
      default = [ "192.168.5.11" ];
      description = "Targets to monitor with the pve-exporter";
    };

  };

  config = {

    services.prometheus = {

      exporters = {
        pve = mkIf cfg.enable {
          enable = true;
          port = cfg.port;
          listenAddress = cfg.listenAddress;
          configFile = "/var/src/secrets/prometheus-pve-exporter/pve.yml";
        };
      };

      scrapeConfigs = mkIf cfg.configure-prometheus [{
        job_name = "pve";
        metrics_path = "/pve";
        scrape_interval = "15s";
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
              "127.0.0.1:${toString cfg.port}";
          }
        ];
        static_configs = [{
          targets = cfg.targets;
        }];
      }];

    };
  };
}
