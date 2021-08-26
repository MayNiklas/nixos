{ lib, buildGoModule, fetchFromGitHub, ffmpeg }:

buildGoModule rec {

  pname = "owncast";
  version = "0.0.8";
  
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    sha256 = "0md4iafa767yxkwh6z8zpcjv9zd79ql2wapx9vzyd973ksvrdaw2";
  };
  
  vendorSha256 = "sha256-bH2CWIgpOS974/P98n0R9ebGTJ0YoqPlH8UmxSYNHeM=";
  
  propagatedBuildInputs = [ ffmpeg ];
  
  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
  };
  
}
