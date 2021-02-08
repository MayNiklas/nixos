{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  users.extraUsers.${config.mainUser}.extraGroups = [ "libvirtd" ];

}
