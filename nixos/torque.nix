with (import <nixpkgs> { });

stdenvNoCC.mkDerivation rec {
  pname = "torque";
  version = "2022-02-10";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "torque";
    rev = "567a94bc4f483fb96b514190768a9e6012b94f0b";
    sha256 = "1jwx6z0iwx7ii13wknylmjy58j645nvrmfasgr325cffwqx51j7f";
  };

  strictDeps = true;
  buildInputs = [ bash transmission ];

  installPhase = ''
    OUT=${placeholder "out"}
    mkdir -p $OUT
    mkdir -p $OUT/bin
    cp -r ${src} $OUT
    cp ${src}/torque $OUT/bin/torque
  '';
}
