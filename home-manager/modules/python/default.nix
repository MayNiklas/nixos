{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mayniklas.programs.python;
  my-python-packages = python-packages:
    with python-packages; [
      requests
    ];
  python-with-packages = pkgs.unstable.python3.withPackages my-python-packages;

in
{

  options.mayniklas.programs.python.enable = mkEnableOption "enable python3 with libs";

  config = mkIf cfg.enable {
    home.packages = with pkgs.unstable; [ python-with-packages ];
  };

}
