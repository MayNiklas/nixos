{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.in-stock-bot = {
    autoStart = true;
    image = "mayniki/in-stock-bot";
    extraOptions = [ "--env-file=/docker/in-stock-bot/envfile" ];
    volumes = [ "/docker/in-stock-bot/data:/app/data:rw" ];
  };
}
