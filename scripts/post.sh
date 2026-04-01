#!/usr/bin/env bash
# CrankBot unified posting orchestrator
# Usage:
#   post.sh twitter-en [--dry-run]    Post English launch thread
#   post.sh twitter-ja [--dry-run]    Post Japanese launch tweet
#   post.sh status                    Show posting status for all platforms

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THREADS_DIR="$SCRIPT_DIR/threads"
SECRETS_DIR="$SCRIPT_DIR/../.secrets"
STATUS_FILE="$SCRIPT_DIR/../.post-status.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"; }
ok()  { log "${GREEN}✓${NC} $1"; }
err() { log "${RED}✗${NC} $1"; }
warn(){ log "${YELLOW}!${NC} $1"; }

# Initialize or read status
init_status() {
    if [[ ! -f "$STATUS_FILE" ]]; then
        cat > "$STATUS_FILE" << 'JSONEOF'
{
  "twitter_en": {"posted": false, "tweet_id": null, "timestamp": null},
  "twitter_ja": {"posted": false, "tweet_id": null, "timestamp": null},
  "show_hn": {"posted": false, "url": null, "timestamp": null},
  "devforum": {"posted": false, "url": null, "timestamp": null},
  "reddit": {"posted": false, "url": null, "timestamp": null},
  "devto": {"posted": false, "url": null, "timestamp": null},
  "hashnode": {"posted": false, "url": null, "timestamp": null},
  "zenn": {"posted": false, "url": null, "timestamp": null},
  "qiita": {"posted": false, "url": null, "timestamp": null}
}
JSONEOF
    fi
}

# Check prerequisites
check_prereqs() {
    local platform="$1"
    case "$platform" in
        twitter-en|twitter-ja)
            if [[ ! -f "$SECRETS_DIR/twitter.env" ]]; then
                err "Twitter credentials not found: $SECRETS_DIR/twitter.env"
                return 1
            fi
            if ! python3 -c "import tweepy" 2>/dev/null; then
                err "tweepy not installed: pip install tweepy"
                return 1
            fi
            ;;
        *)
            warn "Platform '$platform' not yet automated"
            return 1
            ;;
    esac
    return 0
}

# Post English Twitter thread
post_twitter_en() {
    local dry_run="${1:-}"
    local thread_file="$THREADS_DIR/en-launch.txt"

    if [[ ! -f "$thread_file" ]]; then
        err "Thread file not found: $thread_file"
        return 1
    fi

    log "Posting English launch thread to Twitter/X (@_null)..."

    local args="thread $thread_file"
    if [[ "$dry_run" == "--dry-run" ]]; then
        args="$args --dry-run"
    fi

    python3 "$SCRIPT_DIR/tweet.py" $args

    if [[ "$dry_run" != "--dry-run" ]]; then
        # Update status (basic — full JSON update would need jq)
        ok "English thread posted successfully"
    fi
}

# Post Japanese Twitter tweet
post_twitter_ja() {
    local dry_run="${1:-}"
    local thread_file="$THREADS_DIR/ja-launch.txt"

    if [[ ! -f "$thread_file" ]]; then
        err "Thread file not found: $thread_file"
        return 1
    fi

    log "Posting Japanese launch thread to Twitter/X (@_null)..."

    local args="thread $thread_file"
    if [[ "$dry_run" == "--dry-run" ]]; then
        args="$args --dry-run"
    fi

    python3 "$SCRIPT_DIR/tweet.py" $args

    if [[ "$dry_run" != "--dry-run" ]]; then
        ok "Japanese thread posted successfully"
    fi
}

# Show status
show_status() {
    echo ""
    echo "=== CrankBot Posting Status ==="
    echo ""
    printf "%-20s %-10s %-15s %s\n" "PLATFORM" "STATUS" "AUTOMATION" "NOTES"
    printf "%-20s %-10s %-15s %s\n" "--------" "------" "----------" "-----"
    printf "%-20s %-10s %-15s %s\n" "Twitter/X (EN)" "ready" "tweet.py" "Thread: threads/en-launch.txt"
    printf "%-20s %-10s %-15s %s\n" "Twitter/X (JA)" "ready" "tweet.py" "Thread: threads/ja-launch.txt"
    printf "%-20s %-10s %-15s %s\n" "Show HN" "blocked" "—" "karma 1 (need 30+)"
    printf "%-20s %-10s %-15s %s\n" "Playdate DevForum" "blocked" "—" "Account not created"
    printf "%-20s %-10s %-15s %s\n" "Reddit" "blocked" "—" "API restricted (Playwright TBD)"
    printf "%-20s %-10s %-15s %s\n" "Dev.to" "blocked" "—" "Account not created"
    printf "%-20s %-10s %-15s %s\n" "Hashnode" "blocked" "—" "Account not created (canonical)"
    printf "%-20s %-10s %-15s %s\n" "Zenn" "blocked" "—" "Account not created (JP canonical)"
    printf "%-20s %-10s %-15s %s\n" "Qiita" "blocked" "—" "Account not confirmed"
    echo ""
    echo "Blocker: Demo GIF needed for visual-first platforms"
    echo "Blocker: HN karma needs to be built up before Show HN post"
    echo ""
}

# Main
init_status

case "${1:-status}" in
    twitter-en)
        check_prereqs "twitter-en" && post_twitter_en "${2:-}"
        ;;
    twitter-ja)
        check_prereqs "twitter-ja" && post_twitter_ja "${2:-}"
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: post.sh {twitter-en|twitter-ja|status} [--dry-run]"
        exit 1
        ;;
esac
