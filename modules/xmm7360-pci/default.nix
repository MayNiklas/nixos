{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.mayniklas.xmm7360;
  xmm7360-pci = config.boot.kernelPackages.callPackage ./package.nix { };
  # script to get the modem into a working state
  start-modem = pkgs.writeShellScriptBin "start-modem" ''
    # load needed kernel module
    ${pkgs.kmod}/bin/modprobe xmm7360 || true

    # start script
    ${xmm7360-pci}/bin/open_xdatachannel.py -a internet.v6.telekom
  '';
in
{
  options.mayniklas.xmm7360 = {
    enable = mkEnableOption "Enable Fibocom L850-GL WWAN Modem.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ start-modem ];

    boot = {
      # 5.15 works with xmm7360-pci
      kernelPackages = pkgs.linuxPackages_5_15;
      blacklistedKernelModules = [ "iosm" ];
      # https://github.com/xmm7360/xmm7360-pci/
      extraModulePackages = [ xmm7360-pci ];
    };

  };
}
