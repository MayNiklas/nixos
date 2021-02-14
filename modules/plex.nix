{ config, pkgs, lib, ... }: {
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
  fileSystems."/mnt/plex-media" = {
    device = "${config.nasIP}:/volume1/plex-media";
    options = [ "nolock" "soft" "ro" ];
    fsType = "nfs";
  };
  fileSystems."/mnt/media" = {
    device = "${config.nasIP}:/volume1/media";
    options = [ "nolock" "soft" "ro" ];
    fsType = "nfs";
  };
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "plexmediaserver" ];
  };
}
