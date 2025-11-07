# Custom FFmpeg Build

This repository contains build configurations for FFmpeg 7.1.2+ with extensive audio and video codec support.

## What's Included

### Audio Codecs
- **MP3** (LAME encoder)
- **AAC** (native FFmpeg encoder)
- **Opus** (modern, high-quality)
- **Vorbis** (Ogg Vorbis)
- **TwoLAME** (MPEG-1 Layer II)
- **SoXR** (high-quality audio resampling)

### Video Codecs
- **H.264** (x264)
- **H.265/HEVC** (x265)
- **VP8/VP9** (libvpx)
- **AV1** (libaom + SVT-AV1)

### Media Container Support
- Blu-ray (libbluray)
- DVD (libdvdnav, libdvdread)
- Audio CD (libcdio)

## Building with Nix/Flox

This repo uses **Nix expressions** to build FFmpeg - the FFmpeg source code is **NOT** checked into this repo. Instead, builds automatically fetch the source from the upstream FFmpeg GitHub repo.

### Using Nix Flakes

```bash
# Build with nix
nix build

# Or build and run
nix run . -- -version

# Use in your own flake
{
  inputs.ffmpeg-custom.url = "github:barstoolbluz/ffmpeg";
  # ...
  ffmpeg-custom.packages.${system}.default
}
```

### Using Flox

```bash
# Build the package
flox build ffmpeg-custom

# Run the built binary
./result-ffmpeg-custom/bin/ffmpeg -version

# Publish to Flox catalog (requires auth)
flox auth login
flox publish -o <your-org> ffmpeg-custom
```

## Build Configuration

The build is defined in `.flox/pkgs/ffmpeg-custom.nix`. To update to a newer FFmpeg version:

1. Edit `.flox/pkgs/ffmpeg-custom.nix`
2. Update the `version = "X.Y.Z"` field
3. Update the `sha256` hash (or set to empty string and let Nix tell you the correct hash)
4. Rebuild: `flox build ffmpeg-custom` or `nix build`

## Tracking Upstream

This repo tracks the upstream FFmpeg project. To see what version is currently being built:

```bash
grep "version = " .flox/pkgs/ffmpeg-custom.nix
```

Upstream FFmpeg: https://github.com/FFmpeg/FFmpeg

## License

FFmpeg is licensed under GPL v3+ (due to enabled GPL codecs). See upstream FFmpeg documentation for details.
