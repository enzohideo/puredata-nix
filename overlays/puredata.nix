{ pkgs
, puredata
, makeWrapper
, plugins
, settings ? ""
}: let
  externals = pkgs.callPackage ./externals.nix { inherit plugins; };
  pdsettings = pkgs.writeText "default.pdsettings" ''
    ${settings}
  '';
in puredata.overrideAttrs (prevAttrs: {
  postInstall = prevAttrs.postInstall + ''
    cp ${pdsettings} $out/lib/pd/default.pdsettings
    cd ${externals}
    for external_name in ./*; do
      ln -s "${externals}/$external_name" "$out/lib/pd/extra/$external_name"
    done
    cd -
  '';
})
