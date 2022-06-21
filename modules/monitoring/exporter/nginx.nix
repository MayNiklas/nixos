{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.metrics.nginx;
in
{
  options.mayniklas.metrics.nginx = {

    enable = mkEnableOption "prometheus nginx-exporter metrics";

    configure-prometheus = mkEnableOption "enable nginx-exporter in prometheus";

    port = mkOption {
      type = types.port;
      default = 9113;
      description = ''
        Port being used for prometheus nginx-exporter
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "10.88.88.1";
      description = "Address being used for prometheus nginx-exporter";
    };

  };

  config = {

    services.nginx.statusPage = mkIf cfg.enable true;

    services.prometheus = {

      exporters = {
        nginx = mkIf cfg.enable {
          enable = true;
          port = cfg.port;
          listenAddress = cfg.listenAddress;
        };
      };

      scrapeConfigs = mkIf cfg.configure-prometheus [{
        job_name = "nginx";
        scrape_interval = "15s";
        static_configs = [{
          targets = [ "${cfg.listenAddress}:${toString cfg.port}" ];
        }];
      }];

    };

  };
}
