{ fetchurl, stdenv, texinfo }:
let
  binutils-src-filename = "binutils-2.30.tar.xz";
  binutils-src = fetchurl {
    url = "https://ftp.gnu.org/gnu/binutils/${binutils-src-filename}";
    sha256 = "sha256-bka4rq4vcno28L2VBeQFdopyIY8XlvDQl1fUUgmHGuY=";
  };

  gdb-src-filename = "gdb-8.1.tar.xz";
  gdb-src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gdb/${gdb-src-filename}";
    sha256 = "sha256-r2GgJjhY5pxdzlHqsmZi/z0q2apo2pWD6BQ7VCa+SzQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "stm8-binutils-gdb";
  version = "2021-07-18";

  src = fetchurl {
    url = "https://deac-ams.dl.sourceforge.net/project/stm8-binutils-gdb/stm8-binutils-gdb-sources-${version}.tar.gz";
    sha256 = "sha256-jvmmmd6xjsDy1Fex5Haxr9dRRG4zRLxUqWm31jk8kHo=";
  };

  installPhase = ''
    runHook preInstall

    cp "${binutils-src}" "${binutils-src-filename}"
    cp "${gdb-src}" "${gdb-src-filename}"

    ./patch_binutils.sh
    ./configure_binutils.sh

    mkdir -p install

    cd binutils-2.30
    make
    make install DESTDIR="$(pwd)/install"

    mkdir -p "$out/bin"
    cp -r install/usr/local/bin "$out"

    runHook postInstall
  '';

  patches = [
    ./0001-no-wget-sources.patch
  ];

  nativeBuildInputs = [ texinfo ];
}
