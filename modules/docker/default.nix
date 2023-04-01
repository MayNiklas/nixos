{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.docker;
in
{

  options.mayniklas.docker = { enable = mkEnableOption "activate docker"; };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ docker-compose ];

    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.oci-containers = {
      backend = "docker";
    };

    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups =
      [ "docker" ];

  };
}
