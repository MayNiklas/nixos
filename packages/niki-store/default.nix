{ lib, stdenv, fetchFromGitHub, coreutils, hugo, ... }:

stdenv.mkDerivation rec {

  pname = "niki-store";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "MayNiklas";
    repo = "niki-store";
    rev = "fe8bd3e1a51ce795a05d306dad08439b4e23c532";
    hash = "sha256-lk7SRge6nbAZsF1ylHc2/eMH5XcGhGU4yw65g9ia+Oc=";
  };

  installPhase =
    let
      hugo-theme = fetchFromGitHub {
        owner = "kishaningithub";
        repo = "hugo-creative-portfolio-theme";
        rev = "9f7bec1fdde75b5fa31144dca05083b02b51dbbd";
        hash = "sha256-4nNr2B5pZhYxFikKooNPGHmuQy+V/TEz0Z1k/OHEGBY=";
      };
    in
    ''
      ${coreutils}/bin/rm -rf themes/hugo-creative-portfolio-theme
      ${coreutils}/bin/ln -s ${hugo-theme}/ themes/hugo-creative-portfolio-theme
      ${coreutils}/bin/mkdir -p $out/www
      ${hugo}/bin/hugo --minify
      ${coreutils}/bin/cp -ra public/. $out/www
    '';

  meta = with lib; {
    description = "TODO";
    homepage = "https://github.com/MayNiklas/niki-store";
    license = licenses.gpl3;
    maintainers = with maintainers; [ MayNiklas ];
    platforms = platforms.unix;
  };

}
