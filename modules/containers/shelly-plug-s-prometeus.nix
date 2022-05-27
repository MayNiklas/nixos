{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.shelly-plug-s;
in
{

  options.mayniklas.shelly-plug-s = {
    enable = mkEnableOption "activate shelly-plug-s";
  };

  config = mkIf cfg.enable {

    virtualisation.oci-containers.containers.shelly-plug-s-prometeus = {
      autoStart = true;
      ports = [ "9924:80" ];
      image = "mayniki/shelly-plug-prometeus";
      extraOptions = [ "--env-file=/docker/shelly-plug-prometeus/envfile" ];
    };

  };
}
