{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ docker-compose ];

  virtualisation.docker.enable = true;

}
