#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
exec .tools/Godot.app/Contents/MacOS/Godot --editor --path prototype
