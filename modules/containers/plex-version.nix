{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.plex-version-bot;
in {

  options.mayniklas.plex-version-bot = {
    enable = mkEnableOption "activate plex-version-bot";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.plex-version = {
      autoStart = true;
      image = "mayniki/plex-version";
      extraOptions = [ "--env-file=/docker/plex-version/envfile" ];
      volumes = [ "/docker/plex-version/data:/app/data:rw" ];
    };
  };
}
