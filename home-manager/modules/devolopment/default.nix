{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.devolopment;
in
{
  options.mayniklas.programs.devolopment.enable =
    mkEnableOption "enable devolopment applications";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Programming languages / compiler
      cargo
      gcc
      go
      # Formatter
      nixfmt
      nixpkgs-fmt
      # Jetbrains Software
      jetbrains.clion
      jetbrains.goland
      jetbrains.pycharm-professional
    ];
  };
}
