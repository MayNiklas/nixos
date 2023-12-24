{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.devolopment;
in
{
  options.mayniklas.programs.devolopment.enable =
    mkEnableOption "enable devolopment applications";

  config = mkIf cfg.enable {

    programs.go = {
      enable = true;
      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.go.packages
      packages = { };
    };

    home.packages = with pkgs; [

      ### Programming languages / compiler
      cargo
      rustc
      gcc

      ### Formatter
      nixfmt
      nixpkgs-fmt
      rustfmt

      ### Jetbrains Software
      jetbrains.clion
      jetbrains.goland
      jetbrains.pycharm-professional

      mayniklas.pycharm-fix

    ];

  };
}
