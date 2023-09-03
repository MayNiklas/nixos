{ config, pkgs, lib, ... }: {

  # Install these packages for my user
  home.packages =
    let
      build-system = pkgs.callPackage ../../packages/build-system { };
      drone-gen = pkgs.callPackage ../../packages/drone-gen { };
      update-input = pkgs.callPackage ../../packages/update-input { };
      vs-fix = pkgs.callPackage ../../packages/vs-fix { };
    in
    with pkgs; [
      dnsutils
      h
      htop
      iperf3
      nil
      nix-top
      nixfmt
      nixpkgs-fmt
      unzip

      build-system
      drone-gen
      update-input
      vs-fix
    ];

  mayniklas = {
    programs = {
      git.enable = true;
      tmux.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };
  };

  # Imports
  imports = [
    ../modules/git
    ../modules/tmux
    ../modules/nvim
    ../modules/zsh
  ];

  # Include man-pages
  manual.manpages.enable = true;

  programs.command-not-found.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
