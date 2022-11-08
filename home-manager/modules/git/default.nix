{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.git;
in
{
  options.mayniklas.programs.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        ignores = [
          "tags"
          "*.swp"
          # Nix builds
          "result"
          # Core latex/pdflatex auxiliary files
          "*.aux"
          "*.lof"
          "*.log"
          "*.lot"
          "*.fls"
          "*.out"
          "*.toc"
          "*.fmt"
          "*.fot"
          "*.cb"
          "*.cb2"
          ".*.lb"
          # Python
          "__pycache__/"
          "*.py[cod]"
          "*$py.class"
          ".Python"
          "build/"
          "develop-eggs/"
          "dist/"
        ];
        extraConfig = { pull.rebase = false; };
        userEmail = "info@niklas-steffen.de";
        userName = "MayNiklas";
      };
    };
    home.packages = [ pkgs.pre-commit ];
  };
}
