{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.github-runner;
in
{

  options.mayniklas.github-runner = {
    enable = mkEnableOption "activate github-runner";
    allowedUsers = mkEnableOption "add github-runner to nix.allowedUsers";
    url = mkOption {
      type = types.str;
      default = "https://github.com/MayNiklas/nixos";
      example = "https://github.com/MayNiklas/nixos";
      description =
        "Repository to add the runner to. Changing this option triggers a new runner registration.";
    };
    name = mkOption {
      type = types.str;
      default = "nixos-x64-1";
      example = "nixos-aarch64-1";
      description = ''
        Name of the runner to configure. Defaults to the hostname.
        Changing this option triggers a new runner registration.
      '';
    };
    path = mkOption {
      type = types.path;
      default = "/run/secrets/github-runner/nixos.token";
      description = ''
        The full path to a file which contains the runner registration token.
        The file should contain exactly one line with the token without any newline.
        The token can be used to re-register a runner of the same name but is time-limited.
        Changing this option or the file's content triggers a new runner registration.
      '';
    };
  };

  config = mkIf cfg.enable {

    # Enable the github-runner daemon.
    services.github-runner = {
      enable = true;
      name = cfg.name;
      extraLabels = [ "nixos" ];
      url = cfg.url;
      tokenFile = cfg.path;
    };

    nix.allowedUsers = mkIf cfg.allowedUsers [ "github-runner" ];

  };
}
