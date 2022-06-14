{ lib, pkgs, config, self, ... }:
with lib;
let cfg = config.mayniklas.metrics.wireguard;
in
{

  options.mayniklas.metrics.wireguard = {

    enable = mkEnableOption "prometheus wireguard-exporter metrics";

    configure-prometheus =
      mkEnableOption "enable wireguard-exporter in prometheus";

    port = mkOption {
      type = types.port;
      default = 9586;
      description = ''
        Port being used for prometheus wireguard-exporter
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "10.88.88.1";
      description = "Address being used for prometheus wireguard-exporter";
    };

  };

  config = {

    services.prometheus = {

      exporters = {
        wireguard = mkIf cfg.enable {
          enable = true;
          port = cfg.port;
          listenAddress = cfg.listenAddress;
        };
      };

      scrapeConfigs = mkIf cfg.configure-prometheus [{
        job_name = "WireGuard";
        scrape_interval = "60s";
        static_configs = [{
          targets = [ "${cfg.listenAddress}:${toString cfg.port}" ];
        }];
      }];

    };
  };
}
