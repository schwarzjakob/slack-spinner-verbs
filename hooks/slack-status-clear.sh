#!/bin/bash
# Clears the Slack status when Claude Code stops — but only once the LAST
# actively-working session has stopped (see slack-status.sh for the registry).
# Installed by install.sh — do not edit the token here directly; re-run install.sh.

SLACK_TOKEN="__SLACK_TOKEN__"

REG="$HOME/.cache/claude-slack-status/active"
TTL_MIN=30
mkdir -p "$REG"

# Identify this session from the hook's stdin JSON; fall back to a PID if absent.
# The `-t 0` guard reads stdin only when it's piped in, so a manual TTY run can't
# hang — and it avoids depending on `timeout` (not installed by default on macOS).
INPUT=""
[ -t 0 ] || INPUT="$(cat)"
if [[ "$INPUT" =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
  SID="${BASH_REMATCH[1]}"
else
  SID="pid-$PPID"
fi

# This session is done: drop its marker and prune any that died without a Stop.
rm -f "$REG/$SID"
find "$REG" -type f -mmin +"$TTL_MIN" -delete 2>/dev/null

# Only clear the Slack status once no sessions remain active.
[ -n "$(ls -A "$REG" 2>/dev/null)" ] && exit 0

curl -s -X POST "https://slack.com/api/users.profile.set" \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"profile":{"status_text":"","status_emoji":"","status_expiration":0}}' \
  > /dev/null 2>&1 &

exit 0
