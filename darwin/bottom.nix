{ rustPlatform, stdenv, fetchFromGitHub, darwin, pkgs }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "ac3709e5717b2f5dcc299f3f278b180fe52a0be1e466fc51b43918f4854b1f9d";
  };

  cargoSha256 = "10z3ycl36sfhb2d1zdxrylcygw021ackavdaf4k6zsqsrm0gmrax";
  verifyCargoDeps = true;

  buildInputs = pkgs.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Yet another cross-platform graphical process/system monitor";
    homepage = https://github.com/ClementTsang/bottom;
    license = licenses.mit;
    maintainers = [ maintainers.sullvn ];
    platforms = platforms.all;
  };
}
