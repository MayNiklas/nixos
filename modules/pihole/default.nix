{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.pihole;
in
{

  options.mayniklas.pihole = {
    enable = mkEnableOption "activate pihole";
    port = mkOption {
      type = types.str;
      default = "80";
      description = ''
        Documentation placeholder
      '';
    };
    timezone = mkOption {
      type = types.str;
      default = "Europe/Berlin";
      description = ''
        Documentation placeholder
      '';
    };
    path = mkOption {
      type = types.str;
      default = "/docker/pihole";
      description = ''
        Documentation placeholder
      '';
    };
    DNS1 = mkOption {
      type = types.str;
      default = "1.1.1.1";
      description = ''
        Documentation placeholder
      '';
    };
    DNS2 = mkOption {
      type = types.str;
      default = "8.8.8.8";
      description = ''
        Documentation placeholder
      '';
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

