# giftool

Small local media helpers for trimming GIFs and MP4s with `ffmpeg`.

## Contents

- `bin/giftool`: GIF trimming/resizing CLI with palette generation
- `bin/videotool`: MP4 trimming/resizing CLI with H.264 output, text overlays, and side-by-side comparison renders
- `bin/giftool-ui`: NiceGUI browser UI for GIF/MP4 trimming, video annotation, and before/after comparison clips
- `bin/giftool-gui`: legacy Tk GIF-only desktop UI
- `install-deps`: setup helper for system checks, Python UI dependencies, and command links

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

The installer links `giftool`, `videotool`, and `giftool-ui` into `~/.local/bin`. If needed, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Modern UI

Launch:

```bash
giftool-ui
```

The UI opens a local NiceGUI app at `http://127.0.0.1:8080/`. It supports:

- loading a GIF or video with the `Load File` picker or a typed server-side path
- trimming with start/end sliders and numeric fields
- scrubbing the source video preview, tracking playback position, and looping within the selected trim range
- resizing and FPS conversion
- rendering GIF output through `giftool`
- rendering MP4 output through `videotool`
- adding one subtitle-style text overlay to MP4 output
- loading a second video, trimming it independently, and rendering side-by-side before/after output with optional panel labels
- previewing muted source and rendered output in the browser, with optional `ffplay` output preview

Useful environment overrides:

```bash
GIFTOOL_UI_PORT=8090 giftool-ui
GIFTOOL_UI_CACHE=/tmp/giftool-ui-cache giftool-ui
GIFTOOL_UI_SHOW=0 giftool-ui
```

## GIF CLI

```bash
giftool -i input.gif -o output.gif -s 1.2 -d 2.5 -w 480
giftool -i input.gif -o output.gif -e 3.0 -h 240 -f 12
```

Supported options:

- trim by `--start`, `--end`, or `--duration`
- resize by `--width` and/or `--height`
- frame rate control with `--fps`
- loop count with `--loop`

The GIF CLI uses a palette generation pass to keep quality acceptable after trimming or resizing.

## MP4 CLI

Trim and resize:

```bash
videotool -i input.mp4 -o output.mp4 -s 4.2 -d 8.0
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

## Dependencies

- `ffmpeg` and `ffprobe`
- optional: `ffplay` for external preview
- Python 3
- NiceGUI for the modern UI
- Pillow for GIF metadata handling and the legacy Tk GUI
- `tkinter` only for `giftool-gui`
