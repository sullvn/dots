{ stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "zoom-us";
  version = "5.1.28575.0629";

  buildInputs = [ unpkg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      mkdir -p "$out/Applications"
      mv zoom.us.app "$out/Applications"
    '';

  src = fetchurl {
    name = "Zoom.pkg";
    url = "https://d11yldzmag5yn.cloudfront.net/prod/${version}/Zoom.pkg";
    sha256 = "510f0c5be575886ed718635d46ce50b521de47c62815eded382349509515b086";
  };

  meta = with stdenv.lib; {
    description = "Zoom video conferencing for MacOS";
    homepage = "https://zoom.us/download";
    maintainers = [ maintainers.sullvn ];
    platforms = platforms.darwin;
  };
}
