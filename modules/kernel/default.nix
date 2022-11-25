{ config, pkgs, lib, ... }:
with lib;
let cfg = config.mayniklas.kernel;
in
{

  options.mayniklas.kernel = {
    enable = mkEnableOption "activate prefered kernel";
  };

  config = mkIf cfg.enable {

    # # just for fun, I want to use Kernel 6.0 on some of my machines
    # # update: I had some issues with my filesystem during nixos-rebuild,
    # # so I disabled this for now
    # boot.kernelPackages = lib.mkIf
    #   (lib.versionOlder pkgs.linux.version "6.0")
    #   (lib.mkDefault pkgs.linuxPackages_6_0);

    boot.kernelPackages = pkgs.linuxPackages;

  };
}
