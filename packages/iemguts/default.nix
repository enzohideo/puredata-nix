{
  lib,
  stdenv,
  fetchgit,
  puredata,
}:
let
  base = (
    import ../pd-lib-builder.nix {
      pname = "iemguts";
      inherit puredata;
    }
  );
in
stdenv.mkDerivation (
  lib.mergeAttrs base rec {
    version = "v0.4.3";

    src = fetchgit {
      url = "https://git.iem.at/pd/iemguts";
      hash = "sha256-ib0qmx2TkXHxDR2RD7snC5xV3F9kNlFbJSOLLrLeS6o=";
      rev = version;
    };

    meta = with lib; {
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ enzohideo ];
    };
  }
)
