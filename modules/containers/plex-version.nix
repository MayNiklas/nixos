{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.plex-version = {
    autoStart = true;
    image = "mayniki/plex-version";
    extraOptions = [ "--env-file=/docker/plex-version/envfile" ];
    volumes = [ "/docker/plex-version/data:/app/data:rw" ];
  };
}
