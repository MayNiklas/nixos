{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.in-stock-bot;
in {

  options.mayniklas.in-stock-bot = {
    enable = mkEnableOption "activate in-stock-bot" // { default = true; };
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.in-stock-bot = {
      autoStart = true;
      image = "mayniki/in-stock-bot";
      extraOptions = [ "--env-file=/docker/in-stock-bot/envfile" ];
      volumes = [ "/docker/in-stock-bot/data:/app/data:rw" ];
    };

  };
}
