{ pkgs
, lib
, stdenv
, fetchurl
, puredata
, autoPatchelfHook
, boost
, glew
}:

# Compiled with openFrameworks 0.11.2
# https://github.com/cuinjune/Ofelia/issues/79#issuecomment-1399175597
stdenv.mkDerivation rec {
  pname = "ofelia-unstable";
  version = "update/v4.1.0";

  src = fetchurl {
    url = "https://github.com/cuinjune/Ofelia/files/10471494/ofelia_Linux.tar.gz";
    hash = "sha256-YVrlMNFeLPs0rAJTjoMfE6GsMgb9gY/gjqzvdU2nZ6U=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
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
    puredata
    boost
    glew
  ];

  installPhase = ''
    mkdir -p $out/ofelia
    cp -R ./ $out/ofelia
  '';

  meta = with lib; {
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ enzohideo ];
  };
}
