{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ docker-compose ];

  virtualisation.docker.enable = true;

  users.extraUsers.${config.mainUser}.extraGroups = [ "docker" ];

}
