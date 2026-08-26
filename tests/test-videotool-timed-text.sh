#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=blue:s=480x270:r=24:d=2" \
  -c:v libx264 -pix_fmt yuv420p \
  "$tmp_dir/base.mp4"

"$repo_root/giftool/bin/videotool" \
  -i "$tmp_dir/base.mp4" \
  --timed-text "FIRST" --timed-text-start 0.4 --timed-text-end 0.9 \
  --timed-text-position top --timed-text-size 42 \
  --timed-text "SECOND" --timed-text-start 1.1 --timed-text-end 1.6 \
  --timed-text-position bottom --timed-text-size 42 \
  --crf 18 --preset ultrafast \
  -o "$tmp_dir/timed.mp4"

frame_hash() {
  ffmpeg -hide_banner -loglevel error -ss "$1" -i "$tmp_dir/timed.mp4" -frames:v 1 -f md5 -
}

before_hash="$(frame_hash 0.2)"
first_hash="$(frame_hash 0.6)"
second_hash="$(frame_hash 1.3)"
after_hash="$(frame_hash 1.8)"

test "$before_hash" = "$after_hash"
test "$before_hash" != "$first_hash"
test "$before_hash" != "$second_hash"
test "$first_hash" != "$second_hash"

if "$repo_root/giftool/bin/videotool" \
  -i "$tmp_dir/base.mp4" \
  --timed-text "invalid" --timed-text-start 1.2 --timed-text-end 0.8 \
  -o "$tmp_dir/invalid.mp4" 2>"$tmp_dir/error.log"; then
  echo "Invalid timed overlay range was accepted." >&2
  exit 1
fi

grep -F "end time must be greater than start time" "$tmp_dir/error.log" >/dev/null
