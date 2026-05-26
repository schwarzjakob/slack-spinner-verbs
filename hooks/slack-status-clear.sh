#!/bin/bash
# Clears the Slack status when Claude Code stops.
# Installed by install.sh — do not edit the token here directly; re-run install.sh.

SLACK_TOKEN="__SLACK_TOKEN__"

curl -s -X POST "https://slack.com/api/users.profile.set" \
  -H "Authorization: Bearer $SLACK_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"profile":{"status_text":"","status_emoji":"","status_expiration":0}}' \
  > /dev/null 2>&1 &

exit 0
