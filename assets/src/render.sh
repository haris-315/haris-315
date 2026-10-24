#!/bin/bash
# Renders each assets/src/<name>.html to assets/<name>.png at 2x with headless Chrome.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
profile="$(mktemp -d)"; trap 'rm -rf "$profile"' EXIT
for name in ${@:-banner glance flow}; do
  size=$(grep -o 'html, body { width:[0-9]*px; height:[0-9]*px' "$here/$name.html" | grep -o '[0-9]*' | paste -sd,)
  google-chrome-stable --headless=new --hide-scrollbars --user-data-dir="$profile" --allow-file-access-from-files \
    --force-device-scale-factor=2 --window-size="$size" --virtual-time-budget=6000 \
    --screenshot="$here/../$name.png" "file://$here/$name.html" 2>/dev/null
  echo "assets/$name.png ($size @2x)"
done
