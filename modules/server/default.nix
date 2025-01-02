{ lib, pkgs, config, flake-self, ... }:
with lib;
let cfg = config.mayniklas.server;
in
{

  options.mayniklas.server = {
    enable = mkEnableOption "Enable the default server configuration";
    home-manager = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable home-manager for this server
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      bash-completion
      file
      git
      nixfmt-classic
      wget
    ];

    mayniklas = {
      home-manager = {
        enable = true;
        profile = "server";
      };
      user = {
        nik.enable = true;
        root.enable = true;
      };
      locale.enable = true;
      nix-common = {
        enable = true;
        # disable-cache = true;
      };
      openssh.enable = true;
      zsh.enable = true;
    };

  };
}

