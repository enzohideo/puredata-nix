{ pkgs
, lib
, stdenv
, fetchgit
, puredata
}:

stdenv.mkDerivation rec {
  pname = "iemguts";
  version = "v0.4.3";

  src = fetchgit {
    url = "https://git.iem.at/pd/iemguts";
    hash = "sha256-ib0qmx2TkXHxDR2RD7snC5xV3F9kNlFbJSOLLrLeS6o=";
    rev = version;
  };

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/iemguts" "$out/"
    rm -rf $out/lib
  '';

  buildInputs = with pkgs; [
    puredata
  ];

  meta = with lib; {
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ enzohideo ];
  };
}
