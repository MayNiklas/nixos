{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.sonarr;
in {

  options.mayniklas.sonarr = { enable = mkEnableOption "activate sonarr"; };

  config = mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      user = "sonarr";
      group = "sonarr";
      dataDir = "/var/lib/sonarr/.config/NzbDrone";
      openFirewall = true;
    };
  };
}
