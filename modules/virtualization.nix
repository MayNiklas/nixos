{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

}
