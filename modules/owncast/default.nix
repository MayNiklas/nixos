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

  };

  config = mkIf cfg.enable {

    systemd.services.owncast = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {

        User = cfg.user;
        Group = cfg.group;

        # this line only works, when cfg.dataDir allready exists
        # need to find another solution
        WorkingDirectory = "${cfg.dataDir}";

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "owncast-run-prestart" ''
            #!${pkgs.bash}/bin/bash
            # Create data directory if it doesn't exist
            if ! test -d ${cfg.dataDir}; then
              echo "Creating initial owncast data directory in: ${cfg.dataDir}"
              mkdir -p ${cfg.dataDir}
              chown -R "${cfg.user}":"${cfg.group}" ${cfg.dataDir}
            fi
          '';
        in "!${preStartScript}";

        ExecStart = "${pkgs.owncast}/bin/owncast";

      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };

    };

    users = {
      groups."${cfg.user}" = { };
      users."${cfg.group}" = {
        isSystemUser = true;
        group = "${cfg.group}";
      };
    };

  };
}
