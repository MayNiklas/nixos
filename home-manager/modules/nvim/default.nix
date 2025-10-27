{ lib, pkgs, config, ... }:
with lib;
let cfg = config.mayniklas.programs.vim;
in
{
  options.mayniklas.programs.vim.enable = mkEnableOption "Setup neovim";

  config = mkIf cfg.enable {

    xdg = {
      enable = true;
      configFile = {
        nvim_lua_config = {
          target = "nvim/lua/config";
          source = ./lua/config;
        };
      };
    };

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      viAlias = true;
      vimAlias = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        nixpkgs-fmt
        tree-sitter
        yaml-language-server
      ];

      plugins = with pkgs.vimPlugins;[
        ansible-vim
        vim-better-whitespace
        vim-nix
      ];
    };

  };
}
