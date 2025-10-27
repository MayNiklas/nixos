{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.virtualisation;
in
{

  options.mayniklas.virtualisation = {
    enable = mkEnableOption "activate virtualisation";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ virt-manager ];

    # The libvirtd module currently requires Polkit to be enabled ('security.polkit.enable = true').
    security.polkit.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      # allowedBridges = [ "br0" ];
      qemu = {
        # ovmf.enable = true;
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
