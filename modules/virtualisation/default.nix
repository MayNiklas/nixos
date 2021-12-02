{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.virtualisation;
in {

  options.mayniklas.virtualisation = {
    enable = mkEnableOption "activate virtualisation";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ virt-manager ];

    virtualisation.libvirtd = {
      enable = true;
      # allowedBridges = [ "br0" ];
      qemu = {
        ovmf.enable = true;
        runAsRoot = true;
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    programs.dconf.enable = true;

    users.extraUsers.${config.mayniklas.var.mainUser}.extraGroups =
      [ "libvirtd" ];

  };

}
