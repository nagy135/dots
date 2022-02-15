with (import <nixpkgs> { });

stdenvNoCC.mkDerivation rec {
  pname = "mpv_history";
  version = "2022-02-12";

  src = fetchFromGitHub {
    owner = "nagy135";
    repo = "mpv_history";
    rev = "fa46f780ad461c247fbf740b1d6b21ac5c3920dd";
    sha256 = "0bjwna0988z16qbs2bbiynj555r6ajnxfy3yr4i6m5808wzqlr3q";
  };

  strictDeps = true;
  buildInputs = [ wl-clipboard bash mpv youtube-dl gnused gnugrep fuzzel ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
}
