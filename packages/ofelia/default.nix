{ pkgs
, lib
, stdenv
, fetchFromGitHub
, puredata
, boost
, glew
, pkg-config
}: let
  openframeworks = (pkgs.callPackage ./openframeworks.nix {});
in stdenv.mkDerivation rec {
  pname = "ofelia-unstable";
  version = "v4.0.0";

  src = fetchFromGitHub {
    owner = "cuinjune";
    repo = "Ofelia";
    rev = version;
    hash = "sha256-h5QVV7lx0PxBRqnIOhnoxLRe0uEqjJGC+Aqixv9z4fI=";
  };

  buildPhase = ''
    runHook preBuild

    cp --no-preserve=mode,ownership -R ${openframeworks}/opt/openFrameworks ./OF

    shopt -s extglob dotglob
    mkdir -p OF/addons/ofxOfelia
    mv !(OF) OF/addons/ofxOfelia
    shopt -u dotglob

    make -j $NIX_BUILD_CORES -C OF/addons/ofxOfelia/LinuxExternal

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv OF/addons/ofxOfelia/LinuxExternal/bin $out/ofelia
    mv OF/addons/ofxOfelia/ofelia/* $out/ofelia

    runHook postInstall
  '';

  env.NIX_CFLAGS_COMPILE = "-Wall -Wno-error -Wno-unused-function -Wno-format-security";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = with pkgs; [
    puredata

    systemd
    poco
    openal
    glfw
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
    gtk3
    (pugixml.override {
      shared = true;
    })
  ] ++ [
    boost
    glew
  ];

  meta = with lib; {
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ enzohideo ];
  };
}
