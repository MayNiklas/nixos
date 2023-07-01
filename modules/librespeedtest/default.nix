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

    # this is just a stupid experiment to see,
    # if I can use docker-compose in my NixOS configuration

    # reasons to do so:
    # - I can use the docker-compose.yml file from the original project
    # - I can define networking between containers in the docker-compose.yml file

    systemd.services.librespeedtest =
      let
        compose-file = builtins.toFile "docker-compose.yml" ''
          version: '3.7'
          services:
            librespeed:
              image: adolfintel/speedtest
              container_name: librespeed
              environment:
                - TITLE=${cfg.title}
                - ENABLE_ID_OBFUSCATION=true
                - WEBPORT=${cfg.port}
                - MODE=standalone
              ports:
                - ${cfg.port}:${cfg.port}/tcp
        '';
      in
      {
        description = "a docker compose app.";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = mkMerge [
          {
            User = "root";
            Group = "root";
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${compose-file} up";
            Restart = "on-failure";
          }
        ];
      };

    # virtualisation.oci-containers.containers.librespeedtest = {
    #   autoStart = true;
    #   image = "adolfintel/speedtest";
    #   environment = {
    #     TITLE = "${cfg.title}";
    #     ENABLE_ID_OBFUSCATION = "true";
    #     WEBPORT = "${cfg.port}";
    #     MODE = "standalone";
    #   };
    #   ports = [ "${cfg.port}:${cfg.port}/tcp" ];
    # };

    # systemd.services.docker-librespeedtest = {
    #   preStop = "${pkgs.docker}/bin/docker kill librespeedtest";
    # };

  };
}
