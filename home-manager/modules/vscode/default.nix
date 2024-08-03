{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.mayniklas.programs.vscode;
in
{
  options.mayniklas.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      nil
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
        "nix.enableLanguageServer" = true;
        # "serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings" = {
          # "nil" = {
          #   "diagnostics" = {
          #     "ignored" = [ "unused_binding" "unused_with" ];
          #   };
          #   "formatting" = {
          #     "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          #   };
          # };
          "nixd" = {
            # "eval" = { };
            "formatting" = {
              "command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = "(builtins.getFlake \"/home/l/nix\").nixosConfigurations.fn.options";
              };
              "home-manager" = {
                "expr" = "(builtins.getFlake \"/home/l/nix\").homeConfigurations.laptop.options";
              };
              # "target" = {
              #   "args" = [ ];
              #   "installable" = "(builtins.getFlake \"\${workspaceFolder}\")#nixosConfigurations.<name>.options";
              # };
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

      extensions =
        with pkgs.vscode-extensions;
        [
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
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

    };
  };
}
