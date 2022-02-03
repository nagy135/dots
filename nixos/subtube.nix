{  fetchFromGitHub, bash, makeWrapper, maintainers
}:

rec {
  pname = "subtube";
  version = "git";

  src = fetchFromGitHub {
    owner = "nagy135";
    repo = "subtube";
  };

  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    ls -la
  '';

  meta =  {
    description = "Subtubeee";
    homepage = "https://github.com/nagy135/subtube";
    # license = licenses.mit;
    # platforms = platforms.all;
    maintainers = with maintainers; [ nagy135 ];
    mainProgram = "subtube";
  };
}
