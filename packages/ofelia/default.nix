{ pkgs
, lib
, stdenv
, fetchurl
, puredata
, autoPatchelfHook
, boost
, glew
}:

stdenv.mkDerivation rec {
  pname = "ofelia";
  version = "v4.0.0";

  src = fetchurl {
    url = "https://github.com/cuinjune/Ofelia/releases/download/${version}/ofelia-${version}-.Linux-amd64-64.-externals.tar.gz";
    hash = "sha256-IeU4GqNCXCo3/VEND03SF94lMCVmMKkf2AsFyC8Pa04=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
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

  installPhase = ''
    mkdir -p $out/ofelia
    cp -R ./ $out/ofelia
  '';

  meta = with lib; {
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ enzohideo ];
  };
}
