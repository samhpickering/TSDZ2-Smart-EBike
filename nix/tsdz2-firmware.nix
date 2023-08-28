{ binutils-stm8-gdb, sdcc, stdenvNoCC  }:
stdenvNoCC.mkDerivation rec {
  pname = "tsdz2-firmware";
  version = "1.1.2";

  src = ../src;

  installPhase = ''
    runHook preInstall

    make -f Makefile_linux
    cp main.hex "$out"

    runHook postInstall
  '';

  nativeBuildInputs = [ binutils-stm8-gdb sdcc ];
}
