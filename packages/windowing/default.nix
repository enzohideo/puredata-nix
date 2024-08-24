{
  lib,
  stdenv,
  fetchFromGitHub,
  puredata,
}:
let
  base = (
    import ../pd-lib-builder.nix {
      pname = "windowing";
      inherit puredata;
    }
  );
in
stdenv.mkDerivation (
  lib.mergeAttrs base rec {
    version = "v0.3.0";

    src = fetchFromGitHub {
      owner = "electrickery";
      repo = "pd-windowing";
      rev = version;
      hash = "sha256-KsLhXec9qOBHe4MQIbKdXmYEXFd+YAwR80thaS42dl0=";
    };

    meta = with lib; {
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ enzohideo ];
    };
  }
)
