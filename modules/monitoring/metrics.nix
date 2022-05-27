{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.metrics;
in
{

  options.mayniklas.metrics.node = {
    enable = mkEnableOption "prometheus node-exporter metrics collection";
  };

  options.mayniklas.metrics.json = {
    enable = mkEnableOption "prometheus json-exporter metrics collection";
  };

  options.mayniklas.metrics.flake = {
    enable = mkEnableOption "prometheus node-exporter metrics collection";
  };

  options.mayniklas.metrics.blackbox = {
    enable = mkEnableOption "prometheus blackbox-exporter metrics collection";
  };

  config = {

    services.prometheus.exporters = {

      node = mkIf cfg.node.enable {
        enable = true;
        # Default port is 9100
        # Listen on 0.0.0.0, bet we only open the firewall for wg0
        openFirewall = false;
        enabledCollectors = [ "systemd" ];
        extraFlags =
          mkIf cfg.flake.enable [ "--collector.textfile.directory=/etc/nix" ];
      };

      json = mkIf cfg.json.enable {
        enable = true;
        listenAddress = "127.0.0.1";
        configFile = pkgs.writeTextFile {
          name = "json-exporter-config";
          text = ''
            ---
            metrics:

            - name: shelly_update_available
              help: "OTA update available"
              path: "{.update.has_update}"

            - name: shelly_uptime
              help: "current shelly uptime"
              path: "{.uptime}"

            - name: shelly_temperature
              help: "temperature of shelly"
              path: "{.temperature}"

            - name: shelly_power
              help: "current power consumption"
              path: "{.meters[0].power}"

            - name: shelly_power_total
              help: "total power consumption since last firmware update"
              path: "{.meters[0].total}"
          '';
        };
      };

      blackbox = mkIf cfg.blackbox.enable {
        enable = true;
        # Default port is 9115
        # Listen on 0.0.0.0, bet we only open the firewall for wg0
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

    # Open firewall ports on the wireguard interface
    networking.firewall.interfaces.wg0.allowedTCPPorts =
      lib.optional cfg.blackbox.enable 9115
      ++ lib.optional cfg.node.enable 9100;
  };
}
