{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.kubernetes; in
{

  options.mayniklas.programs.kubernetes.enable = mkEnableOption "enable kubernetes dev stuff";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      kompose
      kubectl
      kubectl-convert
    ];

    programs.vscode = mkIf config.programs.vscode.enable {
      userSettings = { };
      extensions = with pkgs.vscode-extensions; [
        ms-kubernetes-tools.vscode-kubernetes-tools
      ];
    };

  };

}


