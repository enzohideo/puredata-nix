{ pkgs
, lib
, stdenv
, fetchgit
, puredata
}: let
  base = (import ../pd-lib-builder.nix {
    pname = "iemlib";
    inherit puredata;
  });
in stdenv.mkDerivation (lib.mergeAttrs base rec {
  version = "v1.22-3";

  src = fetchgit {
    url = "https://git.iem.at/pd/iemlib";
    hash = "sha256-BzE09IVNONy34q2dpoRXzkvWEf0inYVcJK8OMareYJg=";
    rev = version;
  };

  meta = with lib; {
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ enzohideo ];
  };
})
