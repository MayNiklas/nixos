{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.git;
in {
  options.mayniklas.programs.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        ignores = [ "tags" "*.swp" ];
        extraConfig = { pull.rebase = false; };
        userEmail = "info@niklas-steffen.de";
        userName = "MayNiklas";
      };
    };
    home.packages = [ pkgs.pre-commit ];
  };
}
