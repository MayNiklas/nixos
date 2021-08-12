{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.sonarr;
in {

  options.mayniklas.sonarr = { enable = mkEnableOption "activate sonarr"; };

  config = mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      user = "transmission";
      group = "transmission";
      dataDir = "/var/lib/sonarr/.config/NzbDrone";
    };
    networking.firewall = { allowedTCPPorts = [ 8989 ]; };
  };
}
