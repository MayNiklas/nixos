{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.vscode;
in
{
  options.mayniklas.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {

    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.vscode.keybindings
      keybindings = [ ];

      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.fontFamily" = "source code pro";
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
        };
        "nix.enableLanguageServer" = "true";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
      };

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
        redhat.vscode-xml
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        yzhang.markdown-all-in-one
      ];

    };
  };
}
