# slack-status-claude-code-spinner-verbs

A Claude Code hook that updates your Slack status in real time with Claude's whimsical spinner verbs — "Architecting...", "Razzle-dazzling...", "Combobulating..." — one of 187 picked at random every time Claude does something. Clears automatically when Claude stops.

## Install

```bash
git clone https://github.com/schwarzjakob/slack-status-claude-code-spinner-verbs.git
cd slack-status-claude-code-spinner-verbs
bash install.sh
```

The script will ask for your Slack token and wire everything up. Restart Claude Code when done.

## Getting your Slack token

1. Go to https://api.slack.com/apps
2. Create a new app (or use an existing one) → **OAuth & Permissions**
3. Under **User Token Scopes**, add `users.profile:write`
4. Install the app to your workspace and copy the **User OAuth Token** (starts with `xoxp-`)

## How it works

Two shell scripts live in `~/.claude/hooks/`:

- `slack-status.sh` — fires on every Claude tool use, picks a random verb, sets your Slack status for 2 minutes
- `slack-status-clear.sh` — fires when Claude stops, clears your status

The installer registers both as hooks in `~/.claude/settings.json`.

## Credits

Spinner verbs sourced from [deepakness.com/raw/claude-spinner-verbs](https://deepakness.com/raw/claude-spinner-verbs/).

## Uninstall

Remove the two entries from `~/.claude/settings.json` under `hooks.PreToolUse` and `hooks.Stop`, then delete `~/.claude/hooks/slack-status.sh` and `~/.claude/hooks/slack-status-clear.sh`.
