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
    device = "192.168.5.10:/volume1/plex-media/plex";
    options = [ "nolock" "soft" "ro" ];
    fsType = "nfs";
  };
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "plexmediaserver" ];
  };
}
