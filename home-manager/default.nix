{ config, pkgs, lib, flake-self, home-manager, ... }:
with lib;
let cfg = config.mayniklas.home-manager;
in
{

  options.mayniklas.home-manager = {

    enable = mkEnableOption "home-manager configuration";

    profile = mkOption {
      type = types.str;
      default = "server";
      description = "Profile to use";
      example = "desktop";
    };

    username = mkOption {
      type = types.str;
      default = "nik";
      description = "Main user";
      example = "lisa";
    };
  };

  imports = [ home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {

    # DON'T set useGlobalPackages! It's not necessary in newer
    # home-manager versions and does not work with configs using
    # nixpkgs.config`
    home-manager.useUserPackages = true;

    home-manager.users."${cfg.username}" = {

      imports = [
        { nixpkgs.overlays = [ flake-self.overlays.default ]; }
        ./profiles/${cfg.profile}.nix
      ];
    };
  };
}
