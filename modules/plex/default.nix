{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.plex;
in
{

  options.mayniklas.plex = { enable = mkEnableOption "activate plex"; };

  config = mkIf cfg.enable {
    services = {
      plex = {
        enable = true;
        package = pkgs.plex;
        openFirewall = true;
        dataDir = "/var/lib/plex";
      };
      tautulli = {
        enable = true;
        package = pkgs.tautulli;
        port = 8181;
        dataDir = "/var/lib/plexpy";
      };
    };
    networking.firewall.allowedTCPPorts = [ 8181 ];
    nixpkgs = {
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "plexmediaserver" ];
    };
  };
}
