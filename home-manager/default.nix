{ config, pkgs, lib, flake-self, home-manager, wallpaper-generator, ... }:
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
        {
          nixpkgs.overlays = [ flake-self.overlays.default ];
        }
        ./profiles/${cfg.profile}.nix
      ];

      # Set wallpaper for all screens
      wayland.windowManager.sway.config.output = lib.mkIf config.home-manager.users."${cfg.username}".wayland.windowManager.sway.enable
        {
          "*" = {
            bg =
              let
                wallpaper = pkgs.stdenv.mkDerivation {
                  name = "wallpaper";
                  dontUnpack = true;
                  phases = [ "installPhase" ];
                  installPhase = ''
                    mkdir $out
                    ${wallpaper-generator.packages.${pkgs.system}.wp-gen}/bin/wallpaper-generator prisma --width 1920 --height 1080 -o $out/bg.png
                  '';
                };
              in
              "${wallpaper}/bg.png fill #000000";
          };
        };

      nixpkgs.config = import ./nixpkgs-config.nix;
      xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

    };
  };
}
