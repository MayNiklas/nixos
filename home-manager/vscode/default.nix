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
        bbenoist.nix
        brettm12345.nixfmt-vscode
        james-yu.latex-workshop
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
      ];
    };
  };
}
