{
  description = "FFmpeg-full with unfree codecs enabled";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        
        ffmpeg-unfree = pkgs.ffmpeg-full.override {
          withUnfree = true;
        };
      in
      {
        packages = {
          default = ffmpeg-unfree;
          ffmpeg = ffmpeg-unfree;
          ffmpeg-full-unfree = ffmpeg-unfree;
        };
        
        # Also expose it as a legacy package for compatibility
        legacyPackages = {
          ffmpeg = ffmpeg-unfree;
        };
        
        apps.default = {
          type = "app";
          program = "${ffmpeg-unfree}/bin/ffmpeg";
        };
        
        # Provide an overlay so others can use this in their nixpkgs
        overlays.default = final: prev: {
          ffmpeg-unfree = ffmpeg-unfree;
        };
      });
}
