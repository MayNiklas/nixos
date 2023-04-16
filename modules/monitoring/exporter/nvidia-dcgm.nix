{ lib, pkgs, config, self, ... }:
with lib;
let cfg = config.mayniklas.metrics.nvidia-dcgm;
in
{

  options.mayniklas.metrics.nvidia-dcgm = {

    enable = mkEnableOption "prometheus nvidia-dcgm-exporter metrics";

    configure-prometheus =
      mkEnableOption "enable nvidia-dcgm-exporter in prometheus";

    targets = mkOption {
      type = types.listOf types.str;
      default = [ "gpu-server:9400" ];
      description = "Targets to monitor with the nvidia-dcgm-exporter";
    };

  };

  config = {

    # newest version can be found here:
    # https://github.com/NVIDIA/dcgm-exporter/
    virtualisation.oci-containers.containers.dcgm_exporter = mkIf cfg.enable {
      autoStart = true;
      image = "nvcr.io/nvidia/k8s/dcgm-exporter:3.1.7-3.1.4-ubuntu20.04";
      # ports = [ "9400:9400" ];
      extraOptions = [ "--network" "host" "--cap-add" "SYS_ADMIN" "--gpus" "all" ];
    };
    
    networking.firewall.interfaces.wg0.allowedTCPPorts = lib.optional cfg.enable 9400;

    services.prometheus.scrapeConfigs = mkIf cfg.configure-prometheus [
      {
        job_name = "nvidia";
        scrape_interval = "10s";
        static_configs = [
          { targets = cfg.targets; }
        ];
      }
    ];

  };
}
