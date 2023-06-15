{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.smokeping;
in
{

  options.mayniklas.smokeping = {
    enable = mkEnableOption "activate smokeping";
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.smokeping = {
      image = "linuxserver/smokeping";
      autoStart = true;
      ports = [ "80:80" ];
      environment = {
        TZ = "Etc/UTC";
        PUID = "1000";
        PGID = "1000";
      };
      volumes = [
        "/docker/smokeping/data:/data:rw"
        "/docker/smokeping/config:/config:rw"
      ];
    };

  };
}
