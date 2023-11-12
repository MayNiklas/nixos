{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.jitsi;
in
{

  options.mayniklas.jitsi = {
    enable = mkEnableOption "activate jitsi";
    hostname = mkOption {
      type = types.str;
      default = "meet.your-domain.com";
      description = ''
        Documentation placeholder
      '';
    };
  };

  config = mkIf cfg.enable {

    # enable common NGINX settings
    mayniklas.nginx.enable = true;

    services = {
      jitsi-videobridge.openFirewall = true;
      jitsi-meet = {
        enable = true;
        hostName = "${cfg.hostname}";
        config = {
          defaultLang = "en";
          enableWelcomePage = true;
          requireDisplayName = true;
          analytics.disabled = true;
          startAudioOnly = true;
          channelLastN = 4;
          stunServers = [
            { urls = "turn:turn.matrix.org:3478?transport=udp"; }
            { urls = "turn:turn.matrix.org:3478?transport=tcp"; }
          ];
          constraints.video.height = {
            ideal = 720;
            max = 1080;
            min = 240;
          };
        };
        interfaceConfig = {
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
          DISABLE_PRESENCE_STATUS = true;
          GENERATE_ROOMNAMES_ON_WELCOME_PAGE = false;
        };
      };
    };

  };
}
