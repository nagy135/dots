with (import <nixpkgs> { });

stdenvNoCC.mkDerivation rec {
  pname = "subtube";
  version = "2022-02-10";

  src = fetchFromGitHub {
    owner = "nagy135";
    repo = "subtube";
    rev = "8212de442afeb044a68b68a1c41905da219088f7";
    sha256 = "0xcqkijh8azid6vxw518sjzyvfw16ifgh4ha8k2ii40axsm7x5mp";
  };

  strictDeps = true;
  buildInputs = [ dash sxiv mpv youtube-dl jq curl gnused gnugrep ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
}
