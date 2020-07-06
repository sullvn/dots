{ stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "signal-desktop";
  version = "1.34.3";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      mkdir -p "$out/Applications"
      mv Signal.app "$out/Applications/Signal.app"

      # install_name_tool -add_rpath "$out/Applications/Signal.app/Contents/Frameworks" "$out/Applications/Signal.app/Contents/MacOS/Signal"
    '';

  src = fetchurl {
    name = "signal-desktop-${version}.dmg";
    url = "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
    sha256 = "1j9gcr7812rdg03p91hippjycfdzhg2y8mafa8pv2r58xr4z1i19";
  };

  meta = with stdenv.lib; {
    description = "Signal messenger for MacOS";
    homepage = "https://signal.org/download/macos/";
    maintainers = [ maintainers.sullvn ];
    platforms = platforms.darwin;
  };
}
