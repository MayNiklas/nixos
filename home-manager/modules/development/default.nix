{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.development;
in
{
  options.mayniklas.programs.development.enable = mkEnableOption "enable development applications";

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

      ### Vibes
      claude-code

      ### Jetbrains Software
      # jetbrains.clion
      # jetbrains.goland
      # jetbrains.pycharm-professional

      # mayniklas.pycharm-fix

    ];

  };
}
