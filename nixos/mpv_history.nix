with (import <nixpkgs> { });

stdenvNoCC.mkDerivation rec {
  pname = "mpv_history";
  version = "2022-05-15";

  src = fetchFromGitHub {
    owner = "nagy135";
    repo = "mpv_history";
    rev = "2c502f1e93f8686fc433ebe8d95705731c3ba584";
    sha256 = "sha256-SI0AbbSwVDd8CkoDbkuay9iqZliBuRkwwNe47dQTqMk=";
  };

  strictDeps = true;
  buildInputs = [ wl-clipboard bash mpv youtube-dl gnused gnugrep rofi ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
}
