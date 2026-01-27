#!/bin/bash

# ALIVE v2 Status Line
# Minimal by default, information appears when relevant
#
# Shows: session:ID | Model | ctx% | $cost | [subdomain] | [🔥urgent] | [📥inbox]
# Brackets = only shows when relevant

input=$(cat)

# ANSI colors
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
ORANGE="\033[38;5;208m"

# Extract from JSON
session_id=$(echo "$input" | jq -r '.session_id // ""')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
usage=$(echo "$input" | jq -r '.context_window.current_usage // null')

# Shorten model name
model_short=$(echo "$model" | sed 's/Claude //' | sed 's/ (new)//')

# Shorten session ID to first 8 characters
session_short=$(echo "$session_id" | cut -c1-8)

components=()

# 1. Session ID (always)
if [ -n "$session_short" ]; then
  components+=("${DIM}session:${RESET}${session_short}")
fi

# 2. Model (always)
components+=("${BOLD}${model_short}${RESET}")

# 3. Context usage % (always, color-coded)
if [ "$usage" != "null" ]; then
  input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
  cache_creation=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
  cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
  total_tokens=$((input_tokens + cache_creation + cache_read))
  percent=$((total_tokens * 100 / context_size))

  if [ "$percent" -ge 80 ]; then
    color="$RED"
  elif [ "$percent" -ge 60 ]; then
    color="$ORANGE"
  elif [ "$percent" -ge 40 ]; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi
  components+=("${color}ctx:${percent}%${RESET}")
fi

# 4. Cost (always)
if [ "$(echo "$cost > 0" | bc -l 2>/dev/null)" = "1" ]; then
  cost_formatted=$(printf "%.2f" "$cost")
  components+=("${DIM}\$${cost_formatted}${RESET}")
fi

# --- CONDITIONAL COMPONENTS (only when relevant) ---

# ALIVE root - configurable, defaults to iCloud
ALIVE_ROOT="${ALIVE_ROOT:-$HOME/Library/Mobile Documents/com~apple~CloudDocs/alive}"

# 5. Subdomain (only if detected from path)
subdomain=""
if [[ "$dir" == *"/alive/ventures/"* ]]; then
  subdomain=$(echo "$dir" | sed 's|.*/ventures/||' | cut -d'/' -f1)
elif [[ "$dir" == *"/alive/experiments/"* ]]; then
  subdomain=$(echo "$dir" | sed 's|.*/experiments/||' | cut -d'/' -f1)
fi

if [ -n "$subdomain" ]; then
  components+=("📂 ${CYAN}${subdomain}${RESET}")
fi

# 6. Urgent tasks (only if >0)
urgent_count=0
shopt -s nullglob
for tasks_file in "$ALIVE_ROOT"/ventures/*/_brain/tasks.md; do
  if [ -f "$tasks_file" ]; then
    urgent_in_file=$(grep -c -E "^\- \[ \].*@urgent" "$tasks_file" 2>/dev/null || echo 0)
    urgent_count=$((urgent_count + urgent_in_file))
  fi
done

if [ "$urgent_count" -gt 0 ]; then
  components+=("🔥 ${RED}${urgent_count}${RESET}")
fi

# 7. Inbox (only if >0)
inbox_count=0
if [ -d "$ALIVE_ROOT/inbox" ]; then
  inbox_count=$(find "$ALIVE_ROOT/inbox" -type f -not -name ".*" 2>/dev/null | wc -l | tr -d ' ')
fi

if [ "$inbox_count" -gt 0 ]; then
  components+=("📥 ${YELLOW}${inbox_count}${RESET}")
fi

# Join with " | "
output=""
for i in "${!components[@]}"; do
  if [ $i -eq 0 ]; then
    output="${components[$i]}"
  else
    output="${output} ${DIM}|${RESET} ${components[$i]}"
  fi
done

printf "%b" "$output"
