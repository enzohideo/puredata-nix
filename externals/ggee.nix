{ pkgs
, lib
, stdenv
, fetchFromGitHub
, puredata
}:

stdenv.mkDerivation rec {
  pname = "ggee";
  version = "master";

  src = fetchFromGitHub {
    owner = "pd-externals";
    repo = "ggee";
    rev = "8d6e7f28e6c97456cfd9a2edf99c0658909c6367";
    hash = "sha256-ItLLQEO/XZ54U5dpT01EcBgg5lCG1Zbi4qOLpzUS0lU=";
  };

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/ggee" "$out/"
    rm -rf $out/lib
  '';

  buildInputs = with pkgs; [
    puredata
  ];

  meta = with lib; {
    license = licenses.tcltk;
    maintainers = with maintainers; [ enzohideo ];
  };
}
