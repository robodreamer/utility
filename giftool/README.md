# ClipFlip Studio

![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)
![ffmpeg](https://img.shields.io/badge/ffmpeg-required-007808?logo=ffmpeg&logoColor=white)
![NiceGUI](https://img.shields.io/badge/UI-NiceGUI-2596be)
![Linux Desktop](https://img.shields.io/badge/Desktop-Linux-333333?logo=linux&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/robodreamer/utility?style=social)](https://github.com/robodreamer/utility/stargazers)

ClipFlip Studio is a local `ffmpeg` workbench for trimming, converting, annotating, and comparing GIF/video clips. It keeps media on your machine, exposes the common workflows through a native desktop-style UI, and keeps scriptable CLIs for repeatable conversion jobs.

## Preview

| App identity | Main workflows |
| --- | --- |
| ![ClipFlip Studio logo](assets/clipflip.svg) | Trim GIF/video clips, convert GIF to MP4 or MP4 to GIF, add subtitle-style annotations, and render side-by-side before/after comparison videos. |

## Overview

ClipFlip is built as a small local utility rather than a hosted media service. The UI wraps the repo's `giftool`, `videotool`, and `converttool` scripts, while the desktop launcher starts the same app in a standalone native window when `pywebview` support is installed.

The current app supports:

- GIF and video inputs, including `.gif`, `.mp4`, `.m4v`, `.mov`, and `.webm`.
- start/end trimming with preview playback and trim-range looping.
- GIF-to-MP4 and MP4-to-GIF conversion.
- width, height, scale, and FPS controls.
- subtitle-style MP4 text overlays.
- side-by-side comparison renders with independent trim ranges and panel labels.
- local browser mode, native window mode, and CLI-only usage.

## Quick Start

Install the native desktop app, command links, launcher, and icon:

```bash
./install-clipflip
```

On a fresh apt-based Linux machine, include system dependencies:

```bash
./install-clipflip --system
```

Launch the app:

```bash
clipflip
```

Use browser mode instead of the native window:

```bash
clipflip --browser
```

Use an isolated Python environment:

```bash
./install-clipflip --venv .venv
```

The installer links `clipflip`, `clipflip-convert`, `giftool`, `videotool`, `converttool`, and `giftool-ui` into `~/.local/bin`. If needed, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Install Options

The main dependency installer remains available for narrower setups:

```bash
./install-deps
./install-deps --system
./install-deps --native
./install-deps --desktop
./install-deps --app
```

`./install-deps --app` is the single-entry native install path used by `./install-clipflip`. It installs Python UI dependencies, optional native-window support, command links, and the desktop launcher.

The desktop installer writes:

- `~/.local/share/applications/clipflip.desktop`
- `~/.local/share/icons/hicolor/scalable/apps/clipflip.svg`

If the launcher appears without an icon, rerun:

```bash
./install-deps --desktop
```

## Launch Modes

```bash
clipflip
clipflip --browser
clipflip --native --window-size 1280x900
giftool-ui --host 127.0.0.1 --port 8080
```

Useful environment overrides:

```bash
GIFTOOL_UI_PORT=8090 clipflip
GIFTOOL_UI_CACHE=/tmp/giftool-ui-cache clipflip
GIFTOOL_UI_SHOW=0 clipflip
GIFTOOL_UI_NATIVE=1 clipflip
GIFTOOL_UI_WINDOW_SIZE=1280x900 clipflip --native
```

## CLI Examples

Convert between GIF and MP4:

```bash
clipflip-convert -i input.mp4 -o output.gif -s 1 -d 3 -w 480
clipflip-convert -i input.gif -o output.mp4 --fps 30
clipflip-convert -i input.mov -o output --format gif
```

Render GIF output with palette generation:

```bash
giftool -i input.gif -o output.gif -s 1.2 -d 2.5 -w 480
giftool -i input.mp4 -o output.gif -s 1.0 -d 3.0 -w 480
giftool -i input.gif -o output.gif -e 3.0 -h 240 -f 12
```

Render MP4 output:

```bash
videotool -i input.mp4 -o output.mp4 -s 4.2 -d 8.0
videotool -i input.gif -o output.mp4 --fps 30
videotool -i input.mp4 -o output.mp4 -e 12.0 -w 1280 --crf 22
```

Add a compact text annotation:

```bash
videotool -i run.mp4 -o annotated.mp4 --text "model=v2, seed=42" --text-position bottom
```

Create a before/after comparison:

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

In comparison mode, `--start` and `--duration` trim the left input, while `--compare-start` and `--compare-duration` trim the right input. The side-by-side render automatically uses the shorter selected range so both panels end together.

## Repository Layout

```text
giftool/
|-- README.md
|-- install-clipflip
|-- install-deps
|-- requirements.txt
|-- assets/
|   `-- clipflip.svg
|-- bin/
|   |-- clipflip
|   |-- clipflip-convert
|   |-- giftool-ui
|   |-- giftool
|   |-- videotool
|   |-- converttool
|   `-- giftool-gui
`-- packaging/
    |-- build-release
    |-- clipflip.desktop
    `-- install-desktop-entry
```

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
- Python 3.10+
- NiceGUI for the modern UI
- optional: pywebview and WebKit/GStreamer packages for `clipflip --native`
- Pillow for GIF metadata handling and the legacy Tk GUI
- `tkinter` only for `giftool-gui`

## Project Info

- Developer: Andy Park <andypark.purdue@gmail.com>
- Built with Codex
- License: MIT
