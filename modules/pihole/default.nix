{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.pihole;
in {

  options.mayniklas.pihole = {
    enable = mkEnableOption "activate pihole" // { default = true; };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.pihole = {
      autoStart = true;
      image = "pihole/pihole:latest";
      environment = { TZ = "Europe/Berlin"; };
      ports =
        [ "53:53/tcp" "53:53/udp" "67:67/udp" "8080:80/tcp" "443:443/tcp" ];
      volumes = [
        "/docker/pihole/etc-pihole:/etc/pihole:rw"
        "/docker/pihole/etc-dnsmasq.d:/etc/dnsmasq.d:rw"
      ];
    };

  };
}

