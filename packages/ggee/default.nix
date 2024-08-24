{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:
let
  base = (
    import ../pd-lib-builder.nix {
      pname = "ggee";
      inherit puredata;
    }
  );
in
stdenv.mkDerivation (
  lib.mergeAttrs base {
    version = "master";

    src = fetchFromGitHub {
      owner = "pd-externals";
      repo = "ggee";
      rev = "8d6e7f28e6c97456cfd9a2edf99c0658909c6367";
      hash = "sha256-ItLLQEO/XZ54U5dpT01EcBgg5lCG1Zbi4qOLpzUS0lU=";
    };

    meta = with lib; {
      license = licenses.tcltk;
      maintainers = with maintainers; [ enzohideo ];
    };
  }
)
