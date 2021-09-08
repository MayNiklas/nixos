{ lib, pkgs, config, ... }:
with lib;
let cfg = config.services.owncast;
in {

  options.services.owncast = {

    enable = mkEnableOption "owncast";

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
      description = "User account under which owncast runs.";
    };

    group = mkOption {
      type = types.str;
      default = "owncast";
      description = "Group under which owncast runs.";
    };

    listen = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = "The IP address to bind owncast to.";
    };

    port = mkOption {
      type = types.port;
      default = 80;
      description = ''
        TCP port where owncast web-gui listens.
      '';
    };

    rtmp-port = mkOption {
      type = types.port;
      default = 1935;
      description = ''
        TCP port where owncast rtmp service listens.
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.services.owncast = {
      wantedBy = [ "default.target" ];
      preStart = ''
        cp --no-preserve=mode -r ${pkgs.owncast.src}/static ${cfg.dataDir}/
        cp --no-preserve=mode -r ${pkgs.owncast.src}/webroot ${cfg.dataDir}/
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${pkgs.owncast}/bin/owncast -webserverport ${toString cfg.port} -rtmpport ${toString cfg.rtmp-port} -webserverip ${cfg.listen}";
        Restart = "on-failure";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users.users = mkIf (cfg.user == "owncast") {
      owncast = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
        description = "owncast system user";
      };
    };

    users.groups = mkIf (cfg.group == "owncast") { ${cfg.group} = { }; };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port cfg.rtmp-port ]; };

  };
  meta = { maintainers = with lib.maintainers; [ mayniklas ]; };
}
