{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.metrics.blackbox;
in
{
  options.mayniklas.metrics.blackbox = {

    enable = mkEnableOption "prometheus blackbox-exporter metrics collection";

    configure-prometheus = mkEnableOption "enable blackbox-exporter in prometheus";

    targets = mkOption {
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

  };

  config = {

    services.prometheus = {

      exporters = {
        blackbox = mkIf cfg.enable {
          enable = true;
          openFirewall = false;
          configFile = pkgs.writeTextFile {
            name = "blackbox-exporter-config";
            text = ''
              modules:
                icmp:
                  prober: icmp
                  icmp:
                    preferred_ip_protocol: ip4
                http_2xx:
                  prober: http
                  timeout: 5s
                  http:
                    valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
                    valid_status_codes: []  # Defaults to 2xx
                    method: GET
                    no_follow_redirects: false
                    fail_if_ssl: false
                    fail_if_not_ssl: false
                    tls_config:
                      insecure_skip_verify: false
                    preferred_ip_protocol: "ip4" # defaults to "ip6"
                    ip_protocol_fallback: true  # fallback to "ip6"
            '';
          };
        };
      };

      scrapeConfigs = mkIf cfg.configure-prometheus [
        {
          job_name = "blackbox";
          scrape_interval = "15s";
          metrics_path = "/probe";
          params = { module = [ "http_2xx" ]; };
          static_configs = [{ targets = cfg.targets; }];
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
          scrape_interval = "15s";
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
      ];

    };

  };
}
