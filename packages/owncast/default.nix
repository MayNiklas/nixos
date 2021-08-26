{ lib, buildGoModule, fetchFromGitHub, ffmpeg }:

buildGoModule rec {

  pname = "owncast";
  version = "0.0.6";
  
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    sha256 = "0vkh4lb5qp20y476j3w0wrshg0bp8kn496bbhdygw8yv3yra45c6";
  };
  
  vendorSha256 = "0m4xqqpxprbgipwg9ixbjl73zbmlwynmzb1hbgrcgnv02g9mzicf";
  
  propagatedBuildInputs = [ ffmpeg ];
  
  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
  };
  
}

