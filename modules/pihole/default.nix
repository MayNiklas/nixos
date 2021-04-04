{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.pihole;
in {

  options.mayniklas.pihole = {
    enable = mkEnableOption "activate pihole";
    port = mkOption {
      type = types.str;
      default = "80";
    };
    timezone = mkOption {
      type = types.str;
      default = "Europe/Berlin";
    };
    path = mkOption {
      type = types.str;
      default = "/docker/pihole";
    };
    DNS1 = mkOption {
      type = types.str;
      default = "1.1.1.1";
    };
    DNS2 = mkOption {
      type = types.str;
      default = "8.8.8.8";
    };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.pihole = {
      autoStart = true;
      image = "pihole/pihole:latest";
      environment = {
        TZ = "${cfg.timezone}";
        DNS1 = "${cfg.DNS1}";
        DNS2 = "${cfg.DNS2}";
      };
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "67:67/udp"
        "${cfg.port}:80/tcp"
        "443:443/tcp"
      ];
      volumes = [
        "${cfg.path}/etc-pihole:/etc/pihole:rw"
        "${cfg.path}/etc-dnsmasq.d:/etc/dnsmasq.d:rw"
      ];
    };

  };
}

