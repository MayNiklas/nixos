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

    user = mkOption {
      type = types.str;
      default = "owncast";
      example = "owncast";
      description = "User to run owncast as";
    };

    group = mkOption {
      type = types.str;
      default = "owncast";
      example = "owncast";
      description = "Group to run owncast as";
    };

    port = mkOption {
      type = types.port;
      default = 80;
      description = ''
        Port being used for owncast web-gui
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.services.owncast = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {

        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = "${cfg.dataDir}";
        ExecStart =
          "${pkgs.owncast}/bin/owncast -webserverport ${toString cfg.port}";
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

    networking.firewall.allowedTCPPorts = [ cfg.port ];

  };
}
