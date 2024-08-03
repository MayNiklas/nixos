{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.vscode;
in
{
  options.mayniklas.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.vscode.keybindings
      keybindings = [ ];

      # ~/.config/Code/User/settings.json
      userSettings = {
        # privacy
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;

        # style
        "terminal.integrated.fontFamily" = "source code pro";
        "workbench.colorTheme" = "GitHub Dark Default";

        # Copilot
        "github.copilot.enable" = {
          # enabled
          "*" = true;
          "markdown" = true;
          # disabled
          "plaintext" = false;
          "scminput" = false;
        };

        # jnoortheen.nix-ide
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "nixd";
          "serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "nixpkgs-fmt" ]; # consider moving to nixfmt-rfc-style
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake .#nixosConfigurations.daisy.options";
                };
                "home-manager" = {
                  "expr" = "(builtins.getFlake .#homeConfigurations.desktop.options";
                };
              };
            };
          };
        };

        # Markdown
        "[markdown]" = {
          "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
        };

        # Go
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "go.toolsManagement.checkForUpdates" = "off";
      };

      extensions = with pkgs.vscode-extensions; [
        davidanson.vscode-markdownlint
        github.copilot
        github.github-vscode-theme
        github.vscode-github-actions
        github.vscode-pull-request-github
        golang.go
        james-yu.latex-workshop
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        redhat.vscode-xml
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        yzhang.markdown-all-in-one
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

    };
  };
}
