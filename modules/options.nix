{ config, lib, ... }: {

  options.mainUser = lib.mkOption { type = lib.types.str; };

  options.mainUserHome = lib.mkOption { type = lib.types.str; };

  options.nasIP = lib.mkOption { type = lib.types.str; };

}
