{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.var;
in {

  options.mayniklas.var.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "nik";
  };

  options.mayniklas.var.nasIP = lib.mkOption {
    type = lib.types.str;
    default = "192.168.5.10";
  };

  options.mayniklas.system = lib.mkOption {
    type = lib.types.str;
    default = "x86_64-linux";
  };

}
