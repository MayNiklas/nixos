{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.matrix;
in {

  options.mayniklas.matrix = {
    enable = mkEnableOption "activate matrix";
    hostname = mkOption {
      type = types.str;
      default = "matrix.your-domain.com";
      description = ''
        Documentation placeholder
      '';
    };
  };

  config = mkIf cfg.enable {

    services.matrix-synapse = {
      enable = true;
      server_name = "${cfg.hostname}";
      listeners = [{
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
    };

    mayniklas.nginx.enable = true;

  };
}
