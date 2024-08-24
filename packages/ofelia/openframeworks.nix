# This is not being used at the moment because I decided to patch ofelia's
# binary instead.

{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkgs,
}:

stdenv.mkDerivation rec {
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
    # OF_ROOT = builtins.toString ./src;
    LIBSPATH = "linux64";
    CXXFLAGS = "-Wall -Wno-error -Wno-format-security";
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
    # make
    pkg-config
    # gcc
  ];

  buildPhase = ''
    cd libs/openFrameworksCompiled/project

    # make -s Debug -j $NIX_BUILD_CORES
    make -s Release -j 3

    cd -
    cd apps/projectGenerator/commandLine

    make -s Release -j 3

    cd -
    cd libs/openFrameworksCompiled/project

    make -s Release -j 3

    cd -
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt
    cp apps/projectGenerator/commandLine/bin/projectGenerator $out/bin/projectGenerator
    cp -R ./ $out/opt/openFrameworks
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ enzohideo ];
  };
}
