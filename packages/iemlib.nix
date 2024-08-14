{ pkgs
, lib
, stdenv
, fetchgit
, puredata
}:

stdenv.mkDerivation rec {
  pname = "iemlib";
  version = "v1.22-3";

  src = fetchgit {
    url = "https://git.iem.at/pd/iemlib";
    hash = "sha256-RMrFA0R794r9pXGt9khKtfbeZqEyYLj+wScaaMJwMfQ=";
    rev = version;
  };

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/iemlib" "$out/"
    rm -rf $out/lib
  '';

  buildInputs = with pkgs; [
    puredata
  ];

  meta = with lib; {
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ enzohideo ];
  };
}
