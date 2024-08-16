{ lib
, stdenv
, fetchgit
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "libtess2";
  version = "v1.0.2";

  src = fetchgit {
    url = "https://github.com/memononen/libtess2";
    rev = version;
    hash = "sha256-mDxvfaLvFhLO1drw7f+KX97i+3dJCxFvXyxze5HsW4U=";
  };

  buildInputs = with pkgs; [
    glfw
    libGL
    libGLU
    glew
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
    premake
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-unused-variable -fPIC";

  makeFlags = [
    "-C Build"
    "tess2"
    "config=release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include
    mv Build/libtess2.a $out/lib
    mv Include/tesselator.h $out/include

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.sgi-b-20;
    maintainers = with maintainers; [ enzohideo ];
  };
}
