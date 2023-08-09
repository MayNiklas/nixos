{ stdenv
, writeShellScriptBin
, nixFlakes
, ...
}:
let

  # build system script
  build-push-skript = writeShellScriptBin "build-push" ''
    # build hosts
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.aida.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.daisy.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.deke.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.kora.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.simmons.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.snowflake.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.the-bus.config.system.build.toplevel
    ${nixFlakes}/bin/nix build ${../../.}#nixosConfigurations.the-hub.config.system.build.toplevel

    # add push to binary cache
  '';

in
stdenv.mkDerivation
{

  pname = "build-push";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${build-push-skript} $out
  '';
}
