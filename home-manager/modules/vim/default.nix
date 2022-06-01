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
      viAlias = true;
      vimAlias = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        ansible-vim
        i3config-vim
        vim-better-whitespace
        vim-nix
      ];

    };

  };
}
