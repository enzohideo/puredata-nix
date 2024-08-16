# This is not being used at the moment because I decided to patch ofelia's
# binary instead.

{ lib
, stdenv
, fetchurl
, fetchpatch
, pkgs
}: let
  libtess2 = (pkgs.callPackage ./libtess2.nix {});
  kissfft = (pkgs.kissfft.override {
    datatype = "float";
    enableStatic = true;
  });
in stdenv.mkDerivation rec {
  pname = "openframeworks";
  version = "0.11.2";

  src = fetchurl {
    url = "https://github.com/openframeworks/openFrameworks/releases/download/${version}/of_v${version}_linux64gcc6_release.tar.gz";
    hash = "sha256-mQe+rmx4Z1FHD1pV8ScygPPCQLSpPODEoyxKYrQBRww=";
    # hash = "sha256-lCzSmckD4K7qXwXkKauBNwLguk+ZpaPQ58IeYb6bOys="; # 0.12.0
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/openframeworks/openFrameworks/pull/6932.patch";
      hash = "sha256-JMR3tpnhs8p9FHYaPfCX6IEBAmuq5VA7muuFGh8O8f4=";
    })
  ];

  env = {
    # LIBSPATH = "linux64";
    NIX_CFLAGS_COMPILE = "-Wno-error -Wno-format-security";
  };

  buildInputs = with pkgs; [
    systemd
    poco
    openal
    glew
    glfw
    pugixml
    freeglut
    freeimage
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    opencv
    assimp
    boost
    mpg123
    rtaudio
    uriparser
    xorg.libXcursor
    xorg.libXinerama
    (python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
      python-pkgs.lxml
    ]))
    cairo
    libsndfile
    curl
    libpressureaudio
    alsa-lib
    xorg.libXi
    xorg.libXrandr
    xorg.libXxf86vm
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  postPatch = ''
    cp ${libtess2}/lib/libtess2.a libs/tess2/lib/linux64/libtess2.a
    cp ${kissfft}/lib/libkissfft-float.a libs/kiss/lib/linux64/libkiss.a
  '';

  buildPhase = ''
    runHook preBuild

    make -s Debug -j $NIX_BUILD_CORES -C libs/openFrameworksCompiled/project
    make -s Release -j $NIX_BUILD_CORES -C libs/openFrameworksCompiled/project
    make -s Release -j $NIX_BUILD_CORES -C apps/projectGenerator/commandLine

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt
    cp apps/projectGenerator/commandLine/bin/projectGenerator $out/bin/projectGenerator
    cp -R ./ $out/opt/openFrameworks

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ enzohideo ];
  };
}
