{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ docker-compose virt-manager ];

  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

}
