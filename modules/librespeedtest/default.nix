{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.librespeedtest;
in
{

  options.mayniklas.librespeedtest = {
    enable = mkEnableOption "activate librespeedtest";
    port = mkOption {
      type = types.str;
      default = "8080";
      description = ''
        Documentation placeholder
      '';
    };
    title = mkOption {
      type = types.str;
      default = "LibreSpeed";
      description = ''
        Documentation placeholder
      '';
    };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.librespeedtest = {
      autoStart = true;
      image = "adolfintel/speedtest";
      environment = {
        TITLE = "${cfg.title}";
        ENABLE_ID_OBFUSCATION = "true";
        WEBPORT = "${cfg.port}";
        MODE = "standalone";
      };
      ports = [ "${cfg.port}:${cfg.port}/tcp" ];
    };

    systemd.services.docker-librespeedtest = {
      preStop = "${pkgs.docker}/bin/docker kill librespeedtest";
    };

  };
}
