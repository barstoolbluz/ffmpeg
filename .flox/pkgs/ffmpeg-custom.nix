{
  pkgs,
  lib,
  ffmpeg-full,
}:

# Audio-focused FFmpeg: nixpkgs ffmpeg-full with video codecs/hardware accel disabled
# Includes FDK-AAC (non-free), comprehensive audio codecs, album art support

(ffmpeg-full.override {
  # Core
  withGPL = true;
  withVersion3 = true;
  withUnfree = true;        # FDK-AAC

  # Audio codecs
  withMp3lame = true;
  withOpus = true;
  withVorbis = true;
  withSpeex = true;
  withSoxr = true;          # High-quality resampling
  withFdkAac = true;
  withTwolame = true;
  withGsm = true;
  withIlbc = true;
  withOpencoreAmrnb = true;
  withOpencoreAmrwb = true;
  withVoAmrwbenc = true;
  withCodec2 = true;
  withShine = true;
  withCelt = true;

  # Audio processing
  withRubberband = true;
  withBs2b = true;
  withLadspa = true;
  withChromaprint = true;
  withMysofa = true;

  # Tracker/game music
  withModplug = true;
  withGme = true;
  withOpenmpt = true;

  # Media containers
  withBluray = true;
  withCdio = true;
  withDvdnav = true;
  withDvdread = true;

  # Images (album art)
  withOpenjpeg = true;
  withWebp = true;
  withJxl = true;

  # Metadata
  withFreetype = true;
  withFontconfig = true;
  withHarfbuzz = true;
  withXml2 = true;

  # Audio I/O
  withAlsa = true;
  withPulse = true;
  withJack = true;
  withOpenal = true;

  # Network
  withNetwork = true;
  withRist = true;
  withGnutls = true;

  # Compression
  withZlib = true;
  withBzlib = true;
  withLzma = true;
  withSnappy = true;
  withIconv = true;

  # DISABLE video codecs
  withX264 = false;
  withX265 = false;
  withVpx = false;
  withAom = false;
  withDav1d = false;
  withRav1e = false;
  withSvtav1 = false;
  withXvid = false;
  withTheora = false;
  withOpenh264 = false;
  withKvazaar = false;
  withXavs = false;

  # DISABLE hardware accel
  withNvenc = false;
  withNvdec = false;
  withCuda = false;
  withCudaLLVM = false;
  withCuvid = false;
  withVaapi = false;
  withVdpau = false;
  withMfx = false;
  withAmf = false;

  # DISABLE video processing
  withZimg = false;
  withVidStab = false;
  withFrei0r = false;
  withPlacebo = false;
  withVulkan = false;
  withOpengl = false;

  # DISABLE display
  withSdl2 = false;
  withCaca = false;
  withXlib = false;
  withXcb = false;
  withXcbShape = false;      # Depends on Xcb
  withXcbShm = false;        # Depends on Xcb
  withXcbxfixes = false;     # Depends on Xcb
  withV4l2 = false;

  # DISABLE subtitles
  withAss = false;
  withZvbi = false;

  # DISABLE misc
  withSrt = false;
  withRtmp = false;
  withSsh = false;
  withSamba = false;
  withSvg = false;
  withOpencl = false;
  withTensorflow = false;
  withAvisynth = false;
  withFlite = false;
  withFribidi = false;

  # Build opts
  withSmallBuild = false;
  withRuntimeCPUDetection = true;
  withMultithread = true;
  withDebug = false;
  withOptimisations = true;
}).overrideAttrs (oldAttrs: {
  pname = "ffmpeg-audio-only";

  meta = oldAttrs.meta // {
    description = "Audio-focused FFmpeg build with comprehensive codec support and minimal video capabilities. Extensive audio codecs (MP3, Opus, Vorbis, FLAC, WavPack, AAC, etc.), physical media support (Blu-ray, DVD, CD audio extraction), and image formats for album art. Heavy video codecs and hardware acceleration disabled.";
    longDescription = ''
      FFmpeg ${oldAttrs.version} configured for audio processing workflows.

      Audio Codecs: MP3 (LAME), Opus, Vorbis, Speex, TwoLAME, GSM, iLBC,
      AMR-NB/WB, Codec2, Shine, CELT, plus built-in FLAC/WavPack/AAC/AC3/DTS
      support.

      Audio Processing: Rubberband, bs2b, LADSPA, Chromaprint, libmysofa,
      SoXR resampling.

      Tracker Formats: ModPlug, GME, OpenMPT for game/demoscene music.

      Media Support: Blu-ray (libbluray), DVD (libdvdnav/read), CD audio
      extraction (libcdio).

      Image Formats: JPEG, PNG, WebP, JPEG XL, JPEG 2000 (for album art).

      Video Support: Built-in lightweight codecs only (BMP, PNG, MJPEG).
      Heavy external video libraries disabled (no x264, x265, vpx, AOM,
      SVT-AV1, hardware acceleration).

      Licensed under GPL v3+ (includes GPL codecs).
    '';
  };
})
