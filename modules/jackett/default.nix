{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.jackett;
in
{

  options.mayniklas.jackett = { enable = mkEnableOption "activate jackett"; };

  config = mkIf cfg.enable {
    services.jackett = {
      enable = true;
      user = "jackett";
      group = "jackett";
      dataDir = "/var/lib/jackett/.config/Jackett";
    };
    networking.firewall = { allowedTCPPorts = [ 9117 ]; };
  };
}
