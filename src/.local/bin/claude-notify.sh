#!/usr/bin/env bash
# Display a macOS notification for the Claude Code notification hook:
# https://docs.anthropic.com/en/docs/claude-code/hooks
#
# Requires https://github.com/julienXX/terminal-notifier, with permission to send macOS notifications:
#
# brew install terminal-notifier
# terminal-notifier -title "Test" -message "This is a test notification" -sound default
#
# Install this script:
#
# chmod 755 claude-notify.sh
# cp claude-notify.sh ~/.local/bin/
#
# In ~/.claude/settings.json:
#
# {
#   "hooks": {
#     "Notification": [
#       {
#         "matcher": "",
#         "hooks": [
#           {
#             "type": "command",
#             "command": "~/.local/bin/claude-notify.sh"
#           }
#         ]
#       }
#     ]
#   }
# }

set -euo pipefail

# Sample hook content from Claude Code:
# {
#   "session_id": "6e0810cd-640e-422f-b339-a4419b76a528",
#   "transcript_path": "/Users/brianrutledge/.claude/projects/-Users-brianrutledge-Dev-demo-project/6e0810cd-640e-422f-b339-a4419b76a528.jsonl",
#   "hook_event_name": "Notification",
#   "message": "Claude needs your permission to use Bash",
#   "cwd": "/Users/brianrutledge/Dev/demo-project",
# }
input=$(cat)
subtitle=$(echo "$input" | jq -r --arg home "$HOME" '.cwd | sub($home; "~")')
message=$(echo "$input" | jq -r '.message')
terminal-notifier -title "Claude Code" -subtitle "$subtitle" -message "$message" -sound default
