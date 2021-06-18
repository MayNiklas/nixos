{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.plex;
in {

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
        package = pkgs.unstable.tautulli;
        port = 8181;
        dataDir = "/var/lib/plexpy";
      };
    };
    networking.firewall.allowedTCPPorts = [ 8181 ];
    fileSystems."/mnt/plex-media" = {
      device = "${config.mayniklas.var.nasIP}:/volume1/plex-media";
      options = [ "nolock" "soft" "ro" ];
      fsType = "nfs";
    };
    fileSystems."/mnt/media" = {
      device = "${config.mayniklas.var.nasIP}:/volume1/media";
      options = [ "nolock" "soft" "ro" ];
      fsType = "nfs";
    };
    systemd.services.plex = {
      after = [ "mnt-media.mount mnt-plexx2dmedia.mount" ];
    };
    nixpkgs = {
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "plexmediaserver" ];
    };
  };
}
