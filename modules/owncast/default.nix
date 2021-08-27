{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.owncast;
in {

  options.mayniklas.owncast = {

    enable = mkEnableOption "activate owncast";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/owncast";
      description = "The directory where owncast stores its data files.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for owncast.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "owncast";
      example = "my-own-user";
      description = "User to run owncast as";
    };

    group = mkOption {
      type = types.str;
      default = "owncast";
      example = "my-own-group";
      description = "Group to run owncast as";
    };

    webserver-ip = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "192.168.1.1";
      description = "Force owncast web server to listen on this IP address";
    };

    port = mkOption {
      type = types.port;
      default = 80;
      description = ''
        Port being used for owncast web-gui
      '';
    };

    rtmp-port = mkOption {
      type = types.port;
      default = 1935;
      description = ''
        Port being used for owncast rtmp
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.services.owncast = {
      path = [ pkgs.ffmpeg pkgs.bash pkgs.which ];
      wantedBy = [ "default.target" ];

      preStart = ''
        cp --no-preserve=mode -r ${pkgs.owncast.src}/static ${cfg.dataDir}/
        cp --no-preserve=mode -r ${pkgs.owncast.src}/webroot ${cfg.dataDir}/
      '';

      serviceConfig = {

        User = cfg.user;
        Group = cfg.group;

        Restart = "always";
        RestartSec = "10";

        WorkingDirectory = "${cfg.dataDir}";
        ExecStart = "${pkgs.owncast}/bin/owncast -webserverport ${toString cfg.port} -rtmpport ${toString cfg.rtmp-port} -webserverip ${cfg.webserver-ip}";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };

    };

    users = mkIf (cfg.user == "owncast") {
      groups."${cfg.group}" = { };
      users.owncast = {
        isSystemUser = true;
        group = "${cfg.group}";
        home = "${cfg.dataDir}";
        createHome = true;
        description = "owncast system user";
      };
    };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port cfg.rtmp-port ]; };

  };
}
