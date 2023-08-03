{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.grub;
in
{

  options.mayniklas.grub = { enable = mkEnableOption "activate grub"; };

  config = mkIf cfg.enable {

    boot = {
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
        };
      };
      cleanTmpDir = true;
    };
  };
}
