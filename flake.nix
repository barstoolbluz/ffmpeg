{
  description = "FFmpeg with extensive audio/video codec support";

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

        # Build using our custom Nix expression
        ffmpeg-custom = pkgs.callPackage ./.flox/pkgs/ffmpeg-custom.nix { };
      in
      {
        packages = {
          default = ffmpeg-custom;
          ffmpeg = ffmpeg-custom;
          ffmpeg-custom = ffmpeg-custom;
        };

        # Also expose it as a legacy package for compatibility
        legacyPackages = {
          ffmpeg = ffmpeg-custom;
        };

        apps.default = {
          type = "app";
          program = "${ffmpeg-custom}/bin/ffmpeg";
        };

        # Provide an overlay so others can use this in their nixpkgs
        overlays.default = final: prev: {
          ffmpeg-custom = ffmpeg-custom;
        };
      });
}
