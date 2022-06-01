{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.devolopment;
in
{
  options.mayniklas.programs.devolopment.enable =
    mkEnableOption "enable devolopment applications";

  config = mkIf cfg.enable {
    home.packages = with pkgs.jetbrains; [
      jdk
      clion
      idea-ultimate
      pycharm-professional
    ];
  };
}
