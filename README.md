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
- `slack-status-clear.sh` — fires when Claude stops, clears your status — **but only once your last active session has stopped**

The installer registers both as hooks in `~/.claude/settings.json`.

### Multiple sessions

If you run several Claude Code sessions at once, the status stays lit until the
**last** one finishes — a session stopping no longer switches the light off while
the others are still working. Each active session is tracked by a small marker
file under `~/.cache/claude-slack-status/active/`; the status clears only when
none remain. A session that exits without firing its `Stop` hook (e.g. a crash)
leaves a stale marker that is pruned automatically after 30 minutes, and Slack's
own 2-minute status expiry is the final backstop.

### Emoji style

By default each verb gets a matching emoji (💃 🍳 🚀 🧠 …). If you'd rather have a
single, constant emoji — so teammates instantly recognise "that means they're
coding" — open `~/.claude/hooks/slack-status.sh` and set:

```bash
EMOJI_STYLE="robot"   # was "verb"
```

### GitHub status (optional)

The same busy light can mirror to your **GitHub profile status** (the emoji +
message on your profile). It's off by default; `install.sh` asks whether to enable
it. It reuses the [`gh` CLI](https://cli.github.com/) for auth, which must be
logged in with the `user` scope:

```bash
gh auth refresh -h github.com -s user
```

Once enabled, each verb shows on GitHub too (a couple of emoji are translated to
their GitHub names), and it clears alongside Slack when your last session stops.
If `gh` is missing or lacks the scope, the GitHub calls are skipped and only Slack
updates. Note: a GitHub profile status is **public and account-wide**.

## Credits

Spinner verbs sourced from [deepakness.com/raw/claude-spinner-verbs](https://deepakness.com/raw/claude-spinner-verbs/).

## Uninstall

Remove the two entries from `~/.claude/settings.json` under `hooks.PreToolUse` and `hooks.Stop`, then delete `~/.claude/hooks/slack-status.sh` and `~/.claude/hooks/slack-status-clear.sh`.
