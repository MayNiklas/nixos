{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.ansible; in
{

  options.mayniklas.programs.ansible.enable = mkEnableOption "enable ansible dev stuff";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      ansible
      ansible-lint
    ];

    programs.vscode = mkIf config.programs.vscode.enable {
      userSettings = {
        "ansible.ansible.path" = "${pkgs.ansible}/bin/ansible";
        "ansible.ansibleLint.path" = "${pkgs.ansible-lint}/bin/ansible-lint";
        "ansible.python.interpreterPath" = "${pkgs.python3}/bin/python3";
      };
      extensions = with pkgs.vscode-extensions; [
        redhat.vscode-yaml
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ansible";
          publisher = "redhat";
          version = "2.9.118";
          sha256 = "sha256-N/hkx5gcugnQn9Xlql/yUhU2p8/u9RxdYf0LDrKQzXo=";
        }
      ];
    };

  };

}


