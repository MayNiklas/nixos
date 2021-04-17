{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.youtube-dl;
in {

  options.mayniklas.youtube-dl = {
    enable = mkEnableOption "activate youtube-dl";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.youtube-dl-webfrontend = {
      image = "mayniki/youtube-dl-webfrontend";
      ports = [ "80:80" ];
      autoStart = true;
    };
  };
}
