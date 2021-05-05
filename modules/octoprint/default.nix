{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.octoprint;
in {

  options.mayniklas.octoprint = {
    enable = mkEnableOption "activate octoprint";
  };

  config = mkIf cfg.enable {

    services.octoprint = {
      enable = true;
      host = "0.0.0.0";
      port = 5000;
      plugins = plugins:
        with plugins; [
          telegram
          themeify
          stlviewer
          octoprint-dashboard
        ];
    };

    networking.firewall.allowedTCPPorts = [ 5000 ];
    users.extraUsers.octoprint.extraGroups = [ "dialout" "video" ];

  };
}

