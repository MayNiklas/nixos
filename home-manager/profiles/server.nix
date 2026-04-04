{ config, pkgs, lib, flake-self, ... }: {

  # Install these packages for my user
  home.packages =
    with pkgs; [
      dnsutils
      file
      glances
      h
      htop
      iperf3
      nix-tree
      nixfmt
      nixpkgs-fmt
      pciutils
      unzip
      wget

      mayniklas.gen-module
      mayniklas.preview-update
      mayniklas.set-performance
      mayniklas.vs-fix

      (pkgs.writeShellScriptBin "ci" ''
        # echo link to woodpecker
        url=$(${pkgs.git}/bin/git config --get remote.origin.url | sed -e 's/\(.*\)git@\(.*\):[0-9\/]*/https:\/\/\2\//g')
        owner=$(echo $url | sed -e 's/.*github.com\/\(.*\)\/.*/\1/g')
        repo=$(echo $url | sed -e 's/.*github.com\/.*\/\(.*\).git/\1/g')
        echo "https://build.lounge.rocks/$owner/$repo"
      ''
      )
    ];

  mayniklas = {
    programs = {
      direnv.enable = true;
      git.enable = true;
      tmux.enable = true;
      vim.enable = true;
      zellij.enable = true;
      zsh.enable = true;
    };
  };

  services.vscode-server.enable = true;

  # Imports
  imports = [
    ./common.nix
    ../colorscheme.nix
    flake-self.homeManagerModules.direnv
    flake-self.homeManagerModules.git
    flake-self.homeManagerModules.nixos-vscode-claude
    flake-self.homeManagerModules.nvim
    flake-self.homeManagerModules.tmux
    flake-self.homeManagerModules.zellij
    flake-self.homeManagerModules.zsh
  ];

}
