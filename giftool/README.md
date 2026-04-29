# ClipFlip Studio

ClipFlip Studio is a local `ffmpeg` app for trimming, converting, annotating, and comparing GIF/video clips.

## Contents

- `bin/giftool`: GIF output CLI with palette generation
- `bin/videotool`: MP4 output CLI with H.264 output, text overlays, and side-by-side comparison renders
- `bin/converttool`: headless GIF/MP4 conversion CLI
- `bin/giftool-ui`: NiceGUI ClipFlip Studio UI for trimming, conversion, video annotation, and before/after comparison clips
- `bin/giftool-gui`: legacy Tk GIF-only desktop UI
- `assets/clipflip-logo.svg`: app logo
- `packaging/`: desktop entry and release bundle helpers
- `install-deps`: setup helper for system checks, Python UI dependencies, and command links

## Project Info

- Developer: Andy Park <andypark.purdue@gmail.com>
- Built with Codex
- License: MIT

## Setup

From this directory:

```bash
./install-deps
```

On a fresh apt-based Linux machine, this can also install `ffmpeg`, `pip`, `venv`, and Tk support:

```bash
./install-deps --system
```

To keep Python packages isolated:

```bash
./install-deps --venv .venv
```

To enable the standalone native window mode:

```bash
./install-deps --native
```

The installer links `clipflip`, `clipflip-convert`, `giftool`, `videotool`, `converttool`, and `giftool-ui` into `~/.local/bin`. If needed, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Modern UI

Launch:

```bash
clipflip
clipflip --browser
clipflip --native --window-size 1280x900
```

By default `clipflip` opens in a standalone pywebview window. Use `clipflip --browser` or `giftool-ui` to run the local NiceGUI browser app at `http://127.0.0.1:8080/`. It supports:

- loading a GIF or video with the `Load File` picker or a typed server-side path
- trimming with start/end sliders and numeric fields
- tabbed source/second-video previews with nearby trim and scrub controls, playback tracking, and trim-range looping
- cached MP4 previews for responsive GIF scrubbing and trim-range playback, with frame-preview fallback
- proportional resizing with width/height fields and a scale slider, plus FPS conversion
- output format selection for local GIF-to-MP4 and MP4-to-GIF conversion
- rendering GIF output through `giftool`
- rendering MP4 output through `videotool`
- adding one subtitle-style text overlay to MP4 output
- loading a second video or GIF, trimming it independently, and rendering side-by-side before/after MP4 output with optional panel labels
- previewing muted source and rendered output in the browser, with optional `ffplay` output preview

Optional desktop integration:

```bash
./packaging/install-desktop-entry
```

Useful environment overrides:

```bash
GIFTOOL_UI_PORT=8090 clipflip
GIFTOOL_UI_CACHE=/tmp/giftool-ui-cache clipflip
GIFTOOL_UI_SHOW=0 clipflip
GIFTOOL_UI_NATIVE=1 clipflip
GIFTOOL_UI_WINDOW_SIZE=1280x900 clipflip --native
```

## Conversion CLI

```bash
clipflip-convert -i input.mp4 -o output.gif -s 1 -d 3 -w 480
clipflip-convert -i input.gif -o output.mp4 --fps 30
clipflip-convert -i input.mov -o output --format gif
```

The converter infers `gif` or `mp4` from the output extension unless `--format` is provided.

## GIF Output CLI

```bash
giftool -i input.gif -o output.gif -s 1.2 -d 2.5 -w 480
giftool -i input.mp4 -o output.gif -s 1.0 -d 3.0 -w 480
giftool -i input.gif -o output.gif -e 3.0 -h 240 -f 12
```

Supported options:

- trim by `--start`, `--end`, or `--duration`
- resize by `--width` and/or `--height`
- frame rate control with `--fps`
- loop count with `--loop`

The GIF CLI uses a palette generation pass to keep quality acceptable after trimming or resizing.

## MP4 Output CLI

Trim and resize:

```bash
videotool -i input.mp4 -o output.mp4 -s 4.2 -d 8.0
videotool -i input.gif -o output.mp4 --fps 30
videotool -i input.mp4 -o output.mp4 -e 12.0 -w 1280 --crf 22
```

Fast keyframe-aligned copy when no filters are needed:

```bash
videotool -i input.mp4 -o clip.mp4 -s 30 -d 10 --copy
```

Add minimal subtitle-style annotation:

```bash
videotool -i run.mp4 -o annotated.mp4 --text "model=v2, seed=42" --text-position bottom
```

Create a before/after comparison video:

```bash
videotool \
  -i before.mp4 \
  --compare after.mp4 \
  -o side-by-side.mp4 \
  -s 2 \
  -d 10 \
  --compare-start 1 \
  --compare-duration 10 \
  --label-left Before \
  --label-right After \
  --text "experiment 17"
```

In comparison mode, `--start`/`--duration` trim the left input and `--compare-start`/`--compare-duration` trim the right input. The side-by-side render automatically uses the shorter of the two selected ranges so both panels end together. `--width` and `--height` set the final output size; if omitted, the output defaults to `1920x1080`.

## Legacy Tk GUI

Launch the older GIF-only GUI:

```bash
giftool-gui
```

This remains useful when you only need the lightweight Tk GIF workflow.

## Packaging

Build a source release bundle:

```bash
./packaging/build-release
```

Install from the project directory with Python packaging tools:

```bash
python3 -m pip install --user .
python3 -m pip install --user '.[native]'
```

The release keeps compatibility commands (`giftool-ui`, `giftool`, `videotool`, and `converttool`) and adds friendlier app commands (`clipflip` and `clipflip-convert`).

## Dependencies

- `ffmpeg` and `ffprobe`
- optional: `ffplay` for external preview
- Python 3
- NiceGUI for the modern UI
- optional: pywebview and WebKit/GStreamer packages for `clipflip --native`
- Pillow for GIF metadata handling and the legacy Tk GUI
- `tkinter` only for `giftool-gui`
