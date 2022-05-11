{ lib, stdenv, fetchFromGitHub, coreutils, hugo, ... }:

stdenv.mkDerivation rec {

  pname = "niki-store";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "MayNiklas";
    repo = "niki-store";
    rev = "e141011c20a66d461575134afcbede70222c7b5c";
    hash = "sha256-EMwJPWNNou+RDa19bWbmO+gkWpy1X31XVHBejx7p+eY=";
  };

  installPhase = let
    hugo-theme = fetchFromGitHub {
      owner = "kishaningithub";
      repo = "hugo-creative-portfolio-theme";
      rev = "9f7bec1fdde75b5fa31144dca05083b02b51dbbd";
      hash = "sha256-4nNr2B5pZhYxFikKooNPGHmuQy+V/TEz0Z1k/OHEGBY=";
    };
  in ''
    ${coreutils}/bin/rm -rf themes/hugo-creative-portfolio-theme
    ${coreutils}/bin/ln -s ${hugo-theme}/ themes/hugo-creative-portfolio-theme
    ${coreutils}/bin/mkdir -p $out/www
    ${hugo}/bin/hugo --minify --baseURL https://shop.the-framework.de
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
