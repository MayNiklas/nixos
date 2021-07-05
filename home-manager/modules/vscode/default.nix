{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.vscode;
in {
  options.mayniklas.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
      ];
    };
  };
}
