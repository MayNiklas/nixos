{ lib, pkgs, config, flake-self, home-manager, ... }:
with lib;
let cfg = config.mayniklas.server;
in {

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

    services.postgresql.package = pkgs.postgresql_11;

    environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

    mayniklas = {
      user = {
        nik.enable = true;
        nik.home-manager.headless = true;
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

