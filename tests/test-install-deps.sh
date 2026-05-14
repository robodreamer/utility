#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

fake_bin="$tmp_dir/bin"
log_file="$tmp_dir/commands.log"
mkdir -p "$fake_bin"

cat > "$fake_bin/apt-get" <<'EOF'
#!/usr/bin/env bash
printf 'apt-get %s\n' "$*" >> "$TEST_INSTALL_DEPS_LOG"
EOF
chmod +x "$fake_bin/apt-get"

cat > "$fake_bin/sudo" <<'EOF'
#!/usr/bin/env bash
printf 'sudo %s\n' "$*" >> "$TEST_INSTALL_DEPS_LOG"
if [ "$1" = "apt-get" ] && [ "${2:-}" = "install" ]; then
  cat > "$(dirname -- "$0")/fzf" <<'FZF'
#!/usr/bin/env bash
exit 0
FZF
  chmod +x "$(dirname -- "$0")/fzf"
fi
"$@"
EOF
chmod +x "$fake_bin/sudo"

TEST_INSTALL_DEPS_LOG="$log_file" PATH="$fake_bin:/usr/bin:/bin" "$repo_root/install-deps" > "$tmp_dir/output.log"

expected="$tmp_dir/expected.log"
cat > "$expected" <<'EOF'
sudo apt-get update
apt-get update
sudo apt-get install -y fzf
apt-get install -y fzf
EOF

diff -u "$expected" "$log_file"
grep -F "fzf installed: $fake_bin/fzf" "$tmp_dir/output.log" >/dev/null
