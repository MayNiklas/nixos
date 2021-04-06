{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.scene-extractor;
in {

  options.mayniklas.scene-extractor = {
    enable = mkEnableOption "activate scene-extractor";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.scene-extractor-AOS = {
      image = "mayniki/scene-extractor";
      volumes = [
        "/mnt/plex-media/plex/shows/(2013) Marvel's Agents of S.H.I.E.L.D:/source:ro"
        "/docker/scene-extractor/AOS:/var/www/html/dl:rw"
      ];
      ports = [ "81:80" ];
      autoStart = true;
    };
    fileSystems."/mnt/plex-media" = {
      device = "${config.nasIP}:/volume1/plex-media";
      options = [ "nolock" "soft" "ro" ];
      fsType = "nfs";
    };
    systemd.services.docker-scene-extractor-AOS = {
      after = [ "mnt-plexx2dmedia.mount" ];
    };
  };
}
