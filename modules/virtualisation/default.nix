{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.virtualisation;
in {

  options.mayniklas.virtualisation = {
    enable = mkEnableOption "activate virtualisation" // { default = true; };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ virt-manager ];

    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;

    users.extraUsers.${config.mainUser}.extraGroups = [ "libvirtd" ];

  };

}
