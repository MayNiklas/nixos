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
        {
          nixpkgs.config.permittedInsecurePackages = [ ];
          nixpkgs.overlays = [
            flake-self.overlays.default
            (final: prev: {
              inherit (flake-self.inputs.nix-fast-build.packages.${pkgs.system}) nix-fast-build;
              inherit (flake-self.inputs.ondsel.packages.${pkgs.system}) ondsel;
              my-wallpaper = pkgs.callPackage
                ({ function ? "batman", width ? 3840, height ? 2160, extraArguments ? "", ... }:
                  pkgs.stdenv.mkDerivation {
                    name = "wallpaper";
                    dontUnpack = true;
                    phases = [ "installPhase" ];
                    installPhase = ''
                      mkdir $out
                      ${flake-self.inputs.wallpaper-generator.packages.${pkgs.system}.wp-gen}/bin/wallpaper-generator ${function} --width ${toString width} --height ${toString height} ${extraArguments} -o $out/wallpaper.png
                    '';
                  })
                { };
            })
          ];
        }
        ./profiles/${cfg.profile}.nix
      ];

      nixpkgs.config = import ./nixpkgs-config.nix;
      xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

    };
  };
}
