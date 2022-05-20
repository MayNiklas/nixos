{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.user.nik.home-manager;

in {

  imports = [
    (mkRenamedOptionModule [
      "mayniklas"
      "user"
      "nik"
      "home-manager"
      "headless"
    ] [ "mayniklas" "user" "nik" "home-manager" "enable" ])
  ];

  options.mayniklas.user.nik.home-manager = {
    enable = mkEnableOption "activate headless home-manager profile for nik";
  };

  config = mkIf cfg.enable {

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
        nixfmt
        unzip
        (pkgs.callPackage ../packages/drone-gen { })
        (pkgs.callPackage ../packages/vs-fix { })
      ];

      imports = [ ./modules/git ./modules/vim ./modules/zsh ];

      home.stateVersion = "21.03";

    };

  };
}
