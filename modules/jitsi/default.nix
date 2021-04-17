{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.jitsi;
in {

  options.mayniklas.jitsi = {
    enable = mkEnableOption "activate jitsi";
    hostname = mkOption {
      type = types.str;
      default = "meet.your-domain.com";
    };
  };

  config = mkIf cfg.enable {

    services.jitsi-videobridge.openFirewall = true;
    services.jitsi-meet = {
      enable = true;
      hostName = "${cfg.hostname}";

      jicofo.enable = true;
      nginx.enable = true;

      config = { defaultLang = "en"; };

      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
      };

    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 10000 ];
    };
    
    mayniklas.nginx.enable = true;

  };
}
