#!/bin/bash
set -e

HOOK_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "╔════════════════════════════════════════╗"
echo "║       slack-spinner-verbs install      ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "This will update your Slack status with whimsical"
echo "Claude spinner verbs while Claude Code is working."
echo ""

# ── Step 1: Slack token ──────────────────────────────────────────────────────
echo "Get your Slack user token at:"
echo "  https://api.slack.com/apps"
echo "  → OAuth & Permissions → User Token Scopes → add: users.profile:write"
echo "  → copy the token that starts with xoxp-"
echo ""
read -rp "Paste your Slack token: " SLACK_TOKEN

if [[ -z "$SLACK_TOKEN" ]]; then
  echo "✗ No token entered. Aborting."
  exit 1
fi

if [[ "$SLACK_TOKEN" != xoxp-* ]]; then
  echo ""
  echo "⚠  That doesn't look like a user token (expected xoxp-...)."
  read -rp "   Continue anyway? [y/N] " CONFIRM
  [[ "$CONFIRM" =~ ^[Yy]$ ]] || exit 1
fi

echo ""

# ── Step 2: Copy hook scripts ────────────────────────────────────────────────
echo "Installing hooks to $HOOK_DIR ..."
mkdir -p "$HOOK_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for SCRIPT in slack-status.sh slack-status-clear.sh; do
  DEST="$HOOK_DIR/$SCRIPT"
  sed "s|__SLACK_TOKEN__|$SLACK_TOKEN|g" "$SCRIPT_DIR/hooks/$SCRIPT" > "$DEST"
  chmod +x "$DEST"
  echo "  ✓ $SCRIPT"
done

echo ""

# ── Step 3: Wire into settings.json ─────────────────────────────────────────
echo "Wiring into $SETTINGS ..."

python3 - "$SETTINGS" "$HOOK_DIR" <<'PYEOF'
import json, os, sys

settings_path = sys.argv[1]
hook_dir = sys.argv[2]

config = {}
if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        config = json.load(f)

already = any(
    'slack-status.sh' in h.get('command', '')
    for entry in config.get('hooks', {}).get('PreToolUse', [])
    for h in entry.get('hooks', [])
)

if already:
    print("  ✓ Hooks already present — nothing to change.")
    sys.exit(0)

if 'hooks' not in config:
    config['hooks'] = {}

config['hooks'].setdefault('PreToolUse', []).append({
    "matcher": "",
    "hooks": [{"type": "command", "command": f"{hook_dir}/slack-status.sh", "timeout": 5}]
})
config['hooks'].setdefault('Stop', []).append({
    "matcher": "",
    "hooks": [{"type": "command", "command": f"{hook_dir}/slack-status-clear.sh", "timeout": 5}]
})

with open(settings_path, 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')

print("  ✓ PreToolUse hook added (fires on every Claude action)")
print("  ✓ Stop hook added (clears status when Claude finishes)")
PYEOF

echo ""
echo "╔════════════════════════════════════════╗"
echo "║           All done!                    ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Restart Claude Code and watch your Slack status spin."
echo ""
