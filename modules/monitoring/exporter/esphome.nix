{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.metrics.esphome;
in
{
  options.mayniklas.metrics.esphome = {

    configure-prometheus = mkEnableOption "enable esphome-exporter in prometheus";

    targets = mkOption {
      type = types.listOf types.str;
      default = [ "192.168.15.9" ];
      description = "Targets to monitor with the esphome-exporter";
    };

  };

  config = {

    services.prometheus = {

      scrapeConfigs = mkIf cfg.configure-prometheus [
        {
          job_name = "esphome";
          scrape_interval = "30s";
          static_configs = [{ targets = cfg.targets; }];
        }
      ];

    };

  };
}
