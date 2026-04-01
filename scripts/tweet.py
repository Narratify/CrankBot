#!/usr/bin/env python3
"""CrankBot Twitter auto-posting script.

Usage:
    # Post a single tweet
    python tweet.py post "Your tweet text here"

    # Post a thread (from file, one tweet per paragraph separated by blank lines)
    python tweet.py thread path/to/thread.txt

    # Post a tweet with media
    python tweet.py post "Tweet text" --media path/to/image.gif

    # Dry run (print without posting)
    python tweet.py post "Test" --dry-run
"""

import argparse
import os
import sys
import time
from pathlib import Path

import tweepy

SECRETS_PATH = Path(__file__).parent.parent / ".secrets" / "twitter.env"


def load_credentials(path: Path = SECRETS_PATH) -> dict:
    """Load Twitter API credentials from .env file."""
    creds = {}
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            key, _, value = line.partition("=")
            creds[key.strip()] = value.strip()
    return creds


def get_client(creds: dict) -> tweepy.Client:
    """Create authenticated Twitter API v2 client."""
    return tweepy.Client(
        consumer_key=creds["TWITTER_API_KEY"],
        consumer_secret=creds["TWITTER_API_SECRET"],
        access_token=creds["TWITTER_ACCESS_TOKEN"],
        access_token_secret=creds["TWITTER_ACCESS_TOKEN_SECRET"],
    )


def get_api_v1(creds: dict) -> tweepy.API:
    """Create authenticated Twitter API v1.1 (needed for media upload)."""
    auth = tweepy.OAuth1UserHandler(
        creds["TWITTER_API_KEY"],
        creds["TWITTER_API_SECRET"],
        creds["TWITTER_ACCESS_TOKEN"],
        creds["TWITTER_ACCESS_TOKEN_SECRET"],
    )
    return tweepy.API(auth)


def post_tweet(client: tweepy.Client, text: str, media_ids: list = None,
               reply_to: int = None) -> int:
    """Post a single tweet. Returns tweet ID."""
    kwargs = {}
    if media_ids:
        kwargs["media_ids"] = media_ids
    if reply_to:
        kwargs["in_reply_to_tweet_id"] = reply_to
    resp = client.create_tweet(text=text, **kwargs)
    tweet_id = resp.data["id"]
    print(f"  Posted: {tweet_id} | {text[:60]}...")
    return int(tweet_id)


def upload_media(api_v1: tweepy.API, filepath: str) -> int:
    """Upload media file. Returns media ID."""
    media = api_v1.media_upload(filename=filepath)
    print(f"  Uploaded media: {media.media_id} ({filepath})")
    return media.media_id


def parse_thread_file(filepath: str) -> list[str]:
    """Parse a thread file into individual tweets.

    Format: tweets separated by lines containing only '---'.
    Blank lines within a tweet are preserved.
    """
    tweets = []
    current = []
    with open(filepath) as f:
        for line in f:
            line = line.rstrip("\n")
            if line.strip() == "---":
                if current:
                    tweets.append("\n".join(current).strip())
                    current = []
            else:
                current.append(line)
    if current:
        tweets.append("\n".join(current).strip())
    return [t for t in tweets if t]


def post_thread(client: tweepy.Client, tweets: list[str],
                media_ids_first: list = None) -> list[int]:
    """Post a thread (chain of tweets). Returns list of tweet IDs."""
    ids = []
    for i, text in enumerate(tweets):
        m = media_ids_first if i == 0 and media_ids_first else None
        reply_to = ids[-1] if ids else None
        tweet_id = post_tweet(client, text, media_ids=m, reply_to=reply_to)
        ids.append(tweet_id)
        if i < len(tweets) - 1:
            time.sleep(2)  # rate limit buffer
    return ids


def main():
    parser = argparse.ArgumentParser(description="CrankBot Twitter poster")
    parser.add_argument("action", choices=["post", "thread"],
                        help="Action: post a single tweet or a thread")
    parser.add_argument("content", help="Tweet text or path to thread file")
    parser.add_argument("--media", help="Path to media file (image/video/gif)")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print without posting")
    args = parser.parse_args()

    creds = load_credentials()

    if args.action == "post":
        text = args.content
        if len(text) > 280:
            print(f"ERROR: Tweet too long ({len(text)} chars, max 280)")
            sys.exit(1)

        if args.dry_run:
            print(f"[DRY RUN] Would post: {text}")
            if args.media:
                print(f"[DRY RUN] With media: {args.media}")
            return

        client = get_client(creds)
        media_ids = None
        if args.media:
            api_v1 = get_api_v1(creds)
            mid = upload_media(api_v1, args.media)
            media_ids = [mid]

        tweet_id = post_tweet(client, text, media_ids=media_ids)
        print(f"Done. https://twitter.com/_null/status/{tweet_id}")

    elif args.action == "thread":
        filepath = args.content
        if not os.path.exists(filepath):
            print(f"ERROR: File not found: {filepath}")
            sys.exit(1)

        tweets = parse_thread_file(filepath)
        print(f"Thread: {len(tweets)} tweets")
        for i, t in enumerate(tweets):
            print(f"  [{i+1}] ({len(t)} chars) {t[:60]}...")

        if args.dry_run:
            print("[DRY RUN] Would post above thread")
            return

        client = get_client(creds)
        media_ids = None
        if args.media:
            api_v1 = get_api_v1(creds)
            mid = upload_media(api_v1, args.media)
            media_ids = [mid]

        ids = post_thread(client, tweets, media_ids_first=media_ids)
        print(f"Done. Thread: https://twitter.com/_null/status/{ids[0]}")


if __name__ == "__main__":
    main()
