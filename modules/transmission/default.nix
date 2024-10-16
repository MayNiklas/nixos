{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.transmission;
  transmission_pkgs = import (builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
    sha256 = "sha256:0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
  }) { system = "${pkgs.system}"; };
in {

  options.mayniklas.transmission = {
    enable = mkEnableOption "activate transmission";
    smb = mkEnableOption "activate smb";
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

    services.samba = mkIf cfg.smb {
      enable = true;
      settings = {
        global = {
          "invalid users" = [ "root" ];
          "passwd program" = "/run/wrappers/bin/passwd %u";
          security = "user";
          workgroup = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "hosts allow" = "192.168.5.0/24";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        public = {
          path = "/var/lib/transmission/Downloads";
          "read only" = true;
          browseable = "yes";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "root";
          "force group" = "root";
          comment = "Public samba share.";
        };
      };
    };

    networking.firewall = (if cfg.smb then {
      allowedTCPPorts = [ 139 445 cfg.web-port ];
      allowedUDPPorts = [ 137 138 ];
    } else {
      allowedTCPPorts = [ cfg.web-port ];
    });

    systemd.services.transmission.serviceConfig = {
      Restart = "always";
      RestartSec = 10;
    };

    services.transmission = {
      enable = true;
      package = transmission_pkgs.transmission_4;
      webHome = transmission_pkgs.flood-for-transmission;
      openFirewall = true;

      settings = {
        cache-size-mb = 32;
        download-dir = "/var/lib/transmission/Downloads";
        incomplete-dir = "/var/lib/transmission/.incomplete";
        incomplete-dir-enabled = false;
        message-level = 1;
        peer-port = cfg.port;
        peer-port-random-high = 65535;
        peer-port-random-low = 49152;
        peer-port-random-on-start = false;
        script-torrent-done-enabled = false;
        script-torrent-done-filename = null;
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

        speed-limit-down = 50000;
        speed-limit-down-enabled = true;
        speed-limit-up = 15000;
        speed-limit-up-enabled = true;

        alt-speed-down = 12500;
        alt-speed-up = 1000;
        alt-speed-time-begin = 480;
        alt-speed-time-end = 120;
        alt-speed-time-day = 127;
        alt-speed-time-enabled = false;
      };
    };
  };
}
