{
  lib,
  stdenv,
  fetchFromGitHub,
  removeReferencesTo,
  addDriverRunpath,
  pkg-config,
  perl,
  texinfo,
  yasm,
  nasm,

  # External libraries - matching your original requirements
  expat,
  bzip2,
  zlib,
  xz,
  glib,
  pcre,
  libxml2,
  numactl,
  x264,
  x265,
  libvpx,
  libaom,
  svt-av1,
  lame,
  libopus,
  libvorbis,
  soxr,
  twolame,
  libass,
  fontconfig,
  freetype,
  fribidi,
  harfbuzz,
  libbluray,
  libcdio,
  libcdio-paranoia,
  libdvdnav,
  libdvdread,

  # Darwin-specific
  apple-sdk_15,
}:

stdenv.mkDerivation rec {
  pname = "ffmpeg-custom";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "FFmpeg";
    repo = "FFmpeg";
    rev = "n${version}";
    sha256 = "sha256-6bcTxMt0rH/Nso3X7zhrFNkkmWYtxsbUqVQKh25R1Fs=";
  };

  postPatch = ''
    patchShebangs .
  '';

  configurePlatforms = [ ];
  setOutputFlags = false;

  configureFlags = [
    "--target_os=${if stdenv.hostPlatform.isMinGW then "mingw64" else stdenv.hostPlatform.parsed.kernel.name}"
    "--arch=${stdenv.hostPlatform.parsed.cpu.name}"
    "--pkg-config=${pkg-config.targetPrefix}pkg-config"
    
    # Licensing flags
    "--enable-gpl"
    "--enable-version3"
    
    # Build flags
    "--enable-shared"
    "--disable-static"
    "--enable-pic"
    "--enable-runtime-cpudetect"
    "--enable-pthreads"
    "--enable-network"
    "--enable-pixelutils"

    # Program flags
    "--enable-ffmpeg"
    "--enable-ffprobe"
    "--disable-ffplay"  # No need for GUI player

    # Library flags
    "--enable-avcodec"
    "--enable-avdevice"
    "--enable-avfilter"
    "--enable-avformat"
    "--enable-avutil"
    "--enable-postproc"
    "--enable-swresample"
    "--enable-swscale"

    # External libraries matching your original requirements
    "--enable-libx264"
    "--enable-libx265" 
    "--enable-libvpx"
    "--enable-libaom"
    "--enable-libsvtav1"
    "--enable-libmp3lame"
    "--enable-libopus"
    "--enable-libvorbis"
    "--enable-libsoxr"
    "--enable-libtwolame"
    "--disable-libass"  # Disabled as per your original manifest
    "--enable-libbluray"
    "--enable-libcdio"
    "--enable-libdvdnav"
    "--enable-libdvdread"
    "--enable-fontconfig"
    "--enable-libfreetype"
    "--enable-libfribidi"
    "--enable-libharfbuzz"
    "--enable-bzlib"
    "--enable-lzma"
    "--enable-zlib"
    "--enable-libxml2"
    "--enable-iconv"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-asm"  # Disable inline assembly that can cause linker issues on Darwin
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--enable-cross-compile"
    "--host-cc=${stdenv.cc}/bin/cc"
  ] ++ lib.optionals stdenv.cc.isClang [
    "--cc=${stdenv.cc.targetPrefix}clang"
    "--cxx=${stdenv.cc.targetPrefix}clang++"
  ];

  # Remove references to build paths from config.h
  postConfigure = "remove-references-to -t ${placeholder "out"} config.h";

  strictDeps = true;

  nativeBuildInputs = [
    removeReferencesTo
    addDriverRunpath
    perl
    pkg-config
    yasm
    nasm
    texinfo
  ];

  buildInputs = [
    # System libraries
    expat
    bzip2
    zlib
    xz
    glib
    pcre
    libxml2
    # Video codecs
    x264
    x265
    libvpx
    libaom
    svt-av1
    # Audio codecs
    lame
    libopus
    libvorbis
    soxr
    twolame
    # Text/subtitle support
    fontconfig
    freetype
    fribidi
    harfbuzz
    # Media libraries
    libbluray
    libcdio
    libcdio-paranoia
    libdvdnav
    libdvdread
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    numactl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  enableParallelBuilding = true;

  # Platform-specific post-install handling
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Create RPATH entries for runtime libraries on Linux
    for f in $out/bin/*; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$out/lib" "$f" || true
      fi
    done
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix dynamic library paths on Darwin
    for f in $out/bin/*; do
      if [ -f "$f" ] && [ -x "$f" ]; then
        install_name_tool -add_rpath "$out/lib" "$f" 2>/dev/null || true
        for libpath in ${lib.makeLibraryPath buildInputs}; do
          install_name_tool -add_rpath "$libpath" "$f" 2>/dev/null || true
        done
      fi
    done
  '';

  meta = with lib; {
    description = "FFmpeg with rich codec support for video processing";
    longDescription = ''
      Custom build of FFmpeg ${version} with extensive codec support including:
      - Video: H.264 (x264), H.265 (x265), VP8/VP9, AV1 (libaom, SVT-AV1)
      - Audio: MP3 (LAME), AAC (native), Opus, Vorbis, TwoLAME
      - Media: Blu-ray, DVD support
      Built with GPL codecs enabled.
    '';
    homepage = "https://ffmpeg.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "ffmpeg";
  };
}
