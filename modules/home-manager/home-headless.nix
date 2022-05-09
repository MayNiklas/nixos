{ config, pkgs, lib, ... }:

with lib;
let cfg = config.mayniklas.user.nik.home-manager;

in {

  options.mayniklas.user.nik.home-manager = {
    headless = mkEnableOption "activate headless home-manager profile for nik";
  };

  config = mkIf cfg.headless {

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
        ../../home-manager/modules/git
        ../../home-manager/modules/vim
        ../../home-manager/modules/zsh
      ];

      home.stateVersion = "22.05";
    };

  };
}
