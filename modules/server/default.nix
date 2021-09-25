{ lib, pkgs, config, inputs, self-overlay, overlay-unstable, ... }:
with lib;
let cfg = config.mayniklas.server;
in {

  imports = [ ../../users/nik.nix ../../users/root.nix ];

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

    home-manager.users.nik = mkIf cfg.home-manager {

      # Pass inputs to home-manager modules
      _module.args.flake-inputs = inputs;

      imports = [
        ../../home-manager/home-server.nix
        { nixpkgs.overlays = [ self-overlay overlay-unstable ]; }
      ];

    };

    environment.systemPackages = with pkgs; [ bash-completion git nixfmt wget ];

    mayniklas = {
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

