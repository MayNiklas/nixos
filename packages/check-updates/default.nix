{ writeShellScriptBin
, maintainer ? "MayNiklas"
, ...
}:

writeShellScriptBin "check-updates" ''
  cd ~/code/github.com/MayNiklas/nixpkgs
  git checkout master
  git pull
  nix-shell maintainers/scripts/update.nix --argstr maintainer ${maintainer}
''
