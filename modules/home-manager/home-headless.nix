{ lib, pkgs, config, home-manager, ... }:
with lib;
let cfg = config.mayniklas.user.nik.home-manager;

in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.mayniklas.user.nik.home-manager = {
    headless = mkEnableOption "activate headless home-manager profile for nik";
  };

  config = mkIf cfg.headless {

    # DON'T set useGlobalPackages! It's not necessary in newer
    # home-manager versions and does not work with configs using
    # nixpkgs.config`
    home-manager.useUserPackages = true;

    home-manager.users.nik = {

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      programs.command-not-found.enable = true;
      home.username = "nik";
      home.homeDirectory = "/home/nik";

      # Allow "unfree" licenced packages
      nixpkgs.config = { allowUnfree = true; };

      mayniklas = {
        programs = {
          git.enable = true;
          vim.enable = true;
          zsh.enable = true;
        };
      };

      # Install these packages for my user
      home.packages = with pkgs; [
        htop
        iperf3
        unzip
        (pkgs.callPackage ../../packages/drone-gen { })
        (pkgs.callPackage ../../packages/vs-fix { })
      ];

      imports = [
        ../../home-manager/git
        ../../home-manager/vim
        ../../home-manager/zsh
      ];

      home.stateVersion = "22.05";
    };

  };
}
