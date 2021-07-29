{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.transmission;
in {

  options.mayniklas.transmission = {
    enable = mkEnableOption "activate transmission";
    port = mkOption {
      type = types.port;
      default = 51413;
      description = ''
        Port being used for peers to connect
      '';
    };
    web-port = mkOption {
      type = types.port;
      default = 9091;
      description = ''
        Port being used for web-gui
      '';
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.web-port ];

    systemd.services.transmission.serviceConfig = {
      Restart = "always";
      RestartSec = 10;
    };

    services.transmission = {
      enable = true;
      openFirewall = true;

      settings = {
        cache-size-mb = 32;
        download-dir = "/var/lib/transmission/Downloads";
        incomplete-dir = "/var/lib/transmission/.incomplete";
        incomplete-dir-enabled = true;
        message-level = 1;
        peer-port = cfg.port;
        peer-port-random-high = 65535;
        peer-port-random-low = 49152;
        peer-port-random-on-start = false;
        script-torrent-done-enabled = false;
        script-torrent-done-filename = "";
        umask = 2;
        watch-dir = "/var/lib/transmission/watchdir";
        watch-dir-enabled = false;

        dht-enabled = false;
        encryption = 1;
        idle-seeding-limit-enabled = false;
        lpd-enabled = false;
        max-peers-global = 100;
        utp-enabled = false;
        peer-limit-global = 100;
        peer-limit-per-torrent = 25;
        pex-enabled = false;
        port-forwarding-enabled = false;
        preallocation = 1;
        prefetch-enabled = true;
        ratio-limit-enabled = false;
        rename-partial-files = true;

        rpc-bind-address = "0.0.0.0";
        rpc-port = cfg.web-port;
        rpc-whitelist-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*";

        speed-limit-down = 20000;
        speed-limit-down-enabled = true;
        speed-limit-up = 3000;
        speed-limit-up-enabled = true;

        alt-speed-down = 12500;
        alt-speed-up = 1500;
        alt-speed-time-begin = 480;
        alt-speed-time-end = 120;
        alt-speed-time-day = 127;
        alt-speed-time-enabled = false;
      };
    };
  };
}
