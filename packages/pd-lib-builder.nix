{ puredata
, pname
}:

{
  inherit pname;

  buildInputs = [
    puredata
  ];

  makeFlags = [
    "pdincludepath=${puredata}/include/pd"
    "prefix=$(out)"
  ];

  postInstall = ''
    mv "$out/lib/pd-externals/${pname}" "$out/"
    rm -rf $out/lib
  '';
}
