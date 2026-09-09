#!/usr/bin/env bash
#
# One-step installer for the sw-agiledevelopment ZCode plugin.
#
# Usage:
#   bash scripts/install-zcode.sh
#
# This script will:
# 1. Clone (or update) the plugin source from GitHub.
# 2. Register the clone directory in ~/.zcode/cli/config.json under plugins.dirs.
# 3. Verify the SessionStart hook emits valid JSON.
#
# After the script finishes, fully restart ZCode so the plugin is loaded.
#
# Note: the preferred install path is the ZCode marketplace
# (Settings → Plugin Management → Discover → + → vaycentsun/sw-agiledevelopment).
# This script remains as a UI-free fallback. Upgrading means running it again
# (it pulls the latest main).

set -euo pipefail

REPO_URL="https://github.com/vaycentsun/sw-agiledevelopment.git"
SRC_DIR="${HOME}/.zcode/cli/plugins/cache/sw-agiledevelopment-src/sw-agiledevelopment"
CONFIG_FILE="${HOME}/.zcode/cli/config.json"

# 1. Clone or update the source repository.
if [ -d "${SRC_DIR}/.git" ]; then
  echo "Updating existing source clone..."
  git -C "${SRC_DIR}" pull --ff-only
else
  echo "Cloning plugin source..."
  rm -rf "${SRC_DIR}"
  git clone "${REPO_URL}" "${SRC_DIR}"
fi

VERSION=$(cat "${SRC_DIR}/VERSION" | tr -d '[:space:]')

# 2. Register the clone directory in ZCode's plugin configuration.
# The clone is a complete plugin directory: .zcode-plugin/plugin.json declares
# the skills directory and the hooks file, so no staging cache is needed.
echo "Registering plugin in ${CONFIG_FILE}..."
mkdir -p "$(dirname "${CONFIG_FILE}")"
python3 - "${SRC_DIR}" "${CONFIG_FILE}" <<'PY'
import json, os, sys
src_dir = sys.argv[1]
config_path = sys.argv[2]

cfg = {}
if os.path.exists(config_path):
    with open(config_path, "r", encoding="utf-8") as f:
        cfg = json.load(f)
if not isinstance(cfg, dict):
    cfg = {}

cfg.setdefault("plugins", {})
cfg["plugins"]["enabled"] = True
# Keep any existing dirs and add ours at the front so the latest version wins.
existing = cfg["plugins"].get("dirs", [])
if not isinstance(existing, list):
    existing = []
# Remove any previous sw-agiledevelopment entries (old versioned caches too).
existing = [d for d in existing if "sw-agiledevelopment" not in d]
cfg["plugins"]["dirs"] = [src_dir] + existing

with open(config_path, "w", encoding="utf-8") as f:
    json.dump(cfg, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY

# 3. Verify the SessionStart hook runs and emits valid JSON.
echo "Verifying SessionStart hook..."
bash "${SRC_DIR}/.zcode-plugin/hooks/session-start" | python3 -m json.tool > /dev/null && echo "hook OK"

cat <<EOF

sw-agiledevelopment ${VERSION} has been staged for ZCode.

Next step: fully restart ZCode (Cmd + Q, then reopen).
After restart, open the /plugins panel and look for sw-agiledevelopment
(marketplace shown as "inline"). New sessions will auto-inject the
sw-using-agiledevelopment bootstrap.
EOF
