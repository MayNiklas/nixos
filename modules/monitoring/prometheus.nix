{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.services.monitoring-server;
in
{

  options.mayniklas.services.monitoring-server = {
    enable = mkEnableOption "monitoring-server setup";
  };

  config = mkIf cfg.enable {

    services.prometheus = {
      enable = true;
      extraFlags = [ "--log.level=debug" "--storage.tsdb.retention.size=3GB" ];
      retentionTime = "2y";
      # environmentFile = /var/src/secrets/prometheus/envfile;

    };
  };
}
