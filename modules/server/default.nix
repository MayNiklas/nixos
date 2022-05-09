{ lib, pkgs, config, flake-self, home-manager, ... }:
with lib;
let cfg = config.mayniklas.server;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.mayniklas.server = {
    enable = mkEnableOption "Enable the default server configuration";
    home-manager = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable home-manager for this server
      '';
    };
    git = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable git for this server
      '';
    };
    vim = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable vim for this server
      '';
    };
    vs-fix = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable vs-fix for this server
      '';
    };
  };

  config = mkIf cfg.enable {

    services.postgresql.package = pkgs.postgresql_11;

    # DON'T set useGlobalPackages! It's not necessary in newer
    # home-manager versions and does not work with configs using
    # nixpkgs.config`
    home-manager.useUserPackages = true;

    home-manager.users.nik = mkIf cfg.home-manager {

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      programs.command-not-found.enable = true;
      home.username = "nik";
      home.homeDirectory = "/home/nik";
      # Allow "unfree" licenced packages
      nixpkgs.config = { allowUnfree = true; };

      mayniklas = {
        programs = {
          git.enable = mkIf cfg.git true;
          vim.enable = mkIf cfg.vim true;
          vs-fix.enable = mkIf cfg.vs-fix true;
          zsh.enable = true;
        };
      };

      # Install these packages for my user
      home.packages = with pkgs; [ gcc htop iperf3 nmap unzip ];

      imports = [
        ../../home-manager/modules/git
        ../../home-manager/modules/vim
        ../../home-manager/modules/vs-fix
        ../../home-manager/modules/zsh
      ];
      home.stateVersion = "21.05";
    };

    environment.systemPackages = with pkgs; [
      bash-completion
      drone-gen
      git
      nixfmt
      vs-fix
      wget
    ];

    mayniklas = {
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

