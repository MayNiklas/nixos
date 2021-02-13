{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.youtube-dl-webfrontend = {
    image = "mayniki/youtube-dl-webfrontend";
    ports = [ "80:80" ];
    autoStart = true;
  };
}