{ pkgs
, lib
, stdenv
, fetchFromGitHub
, puredata
}:

stdenv.mkDerivation rec {
  pname = "windowing";
  version = "v0.3.0";

  src = fetchFromGitHub {
    owner = "electrickery";
    repo = "pd-windowing";
    rev = version;
    hash = "sha256-KsLhXec9qOBHe4MQIbKdXmYEXFd+YAwR80thaS42dl0=";
  };

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/windowing" "$out/"
    rm -rf $out/lib
  '';

  buildInputs = with pkgs; [
    puredata
  ];

  meta = with lib; {
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ enzohideo ];
  };
}
