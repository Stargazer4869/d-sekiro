#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p reports
exec "builds/DuelTrial.app/Contents/MacOS/Duel — Toolchain Trial" --resolution 1920x1080 -- --benchmark
