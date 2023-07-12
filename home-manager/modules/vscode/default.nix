{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.vscode;
in
{
  options.mayniklas.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.vscode.keybindings
      keybindings = [ ];

      extensions = with pkgs.vscode-extensions; [
        b4dm4n.vscode-nixpkgs-fmt
        bbenoist.nix
        github.copilot
        github.github-vscode-theme
        github.vscode-github-actions
        github.vscode-pull-request-github
        golang.go
        james-yu.latex-workshop
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        rust-lang.rust-analyzer
      ];

    };
  };
}
