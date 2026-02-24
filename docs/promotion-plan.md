# CrankBot プロモーション計画

詳細な調査データは `marketing-research.md` を参照。

## ターゲットコミュニティ

| プラットフォーム | チャネル | 購読者/規模 | 特徴 |
|------------------|----------|-------------|------|
| Twitter/X | #playdate #playdatedev | 広域 | スレッド+動画必須。メディア・開発者へのリーチ |
| Reddit | r/PlaydateConsole | ~5,200人 | 動画/GIFが伸びやすい。Panic社員も参加 |
| Playdate DevForum | devforum.play.date | 開発者中心 | Show & Tell。技術詳細が好まれる |
| Discord | Playdate Squad | ~9,500人 | 最もフレンドリー。devlog形式 |
| Hacker News | Show HN | テック層 | AI×レトロのギャップが刺さる。ブログ記事必須 |
| 日本語圏 | Twitter/Zenn/Qiita | — | 日本語記事で技術者層にリーチ |

## 投稿スケジュール

### Phase 0: 事前準備

- [x] 動画撮影済み
- [x] 英語ブログ記事公開済み (shura.ai-my.net/pub/blog/crankbot.html)
- [x] 日本語ブログ記事公開済み (shura.ai-my.net/pub/blog/crankbot-ja.html)
- [ ] DevForumアカウント作成 + コミュニティ参加（数日コメント）
- [ ] HN karma確認（250+推奨）

### Phase 1: ローンチ日（火曜 or 水曜）

| 順序 | 時間 (EST/JST) | プラットフォーム | 形式 |
|------|---------------|-----------------|------|
| 1 | 9:00 AM EST / 23:00 JST | Twitter/X | 7ツイートスレッド + 動画 |
| 2 | 10:00-11:00 AM EST | Reddit r/PlaydateConsole | 動画投稿 + テキスト |
| 3 | 同日 | Playdate DevForum | 長文 + 動画 + 技術詳細 |

### Phase 2: 拡張（Day 2-5）

| 順序 | プラットフォーム | 切り口 |
|------|-----------------|--------|
| 4 | Reddit r/IndieGaming, r/indiegames | AI on retro hardware |
| 5 | Twitter 日本語スレッド | PlaydateからAIと会話 |
| 6 | Reddit r/programming | 技術的な側面 |

### Phase 3: Hacker News（Day 4-5、土曜推奨）

| 時間 | 形式 | 注意 |
|------|------|------|
| 土曜 11:00 AM Pacific / 日曜 4:00 JST | Show HN + ブログ記事URL | 投稿後2時間はHNに張り付く |

### Phase 4: Discord + 継続（Day 7-14）

| プラットフォーム | 形式 |
|-----------------|------|
| Playdate Squad Discord | devlogスレッド、フィードバック反映済み |
| Zenn/Qiita | 日本語技術記事 |

---

## 投稿最終稿

### 1. Twitter/X 英語スレッド（7ツイート + 動画）

```
1/ Every AI interface looks the same. Text box. Send button. Browser.

I went the other way — put AI on a 400x240 1-bit screen where you scroll with a mechanical crank.

[動画]

2/ How it works:
- Type on the on-screen keyboard
- Playdate sends it over HTTPS to a self-hosted server
- Server calls any LLM API (Claude, GPT, Gemini, etc.)
- You crank through the response, one line at a time

~500 lines of Lua + ~80 lines of Python.

3/ The crank changes everything.

No streaming tokens. No progress bars. You wait. The response arrives. You physically crank through it on a tiny monochrome screen.

You actually read every word. That almost never happens with AI anymore.

4/ Tech stack:
- Playdate app: Lua (Playdate SDK)
- API server: Python / FastAPI
- AI: Any OpenAI-compatible API (Claude, GPT, Gemini, Groq, etc.)
- Communication: HTTPS + Bearer token auth

Bring your own API key.

5/ We make products at AI-MY under the theme "anti-innovation / rediscovery" — using technology to rediscover what technology's progress has overlooked.

Our Lo-Fi Camera turns subjects into pixel art on thermal paper. CrankBot does the same for AI conversations — strips away everything, leaves only the words.

6/ Fully open source (MIT):
github.com/Narratify/CrankBot

Self-host your own API server. Works with any LLM provider.

Your Playdate, your AI, your server.

7/ What would you ask AI if you had to crank through every line of its answer?

Blog post: shura.ai-my.net/pub/blog/crankbot.html

#playdate #playdatedev #AI #opensource
```

### 2. Twitter/X 日本語（単体 + 動画）

```
どのAIインターフェースも同じ見た目をしている。テキストボックス、送信ボタン、ブラウザ。

逆に行ってみた。400×240、白黒1ビット、スクロールはクランクで。

AIの応答を一行ずつクランクで送ると、一語一語を読むようになる。流し読みも再生成もない。Lo-Fi AI。

OSS (MIT): github.com/Narratify/CrankBot

[動画]

#playdate #playdatedev #AI #opensource
```

### 3. Reddit r/PlaydateConsole

```
Title: I put AI on the Playdate — you scroll the conversation with the crank (open source)

[動画投稿]

Every AI interface looks the same: text box, send button, browser. I wanted to see what happens when you strip all of that away.

CrankBot lets you chat with AI on the Playdate's 400x240 1-bit display. You type with the on-screen keyboard, and crank through the AI's response one line at a time. No streaming. No regenerate button. Just reading.

How it works:
- Playdate sends messages over HTTPS to a self-hosted Python/FastAPI server
- Server queries any OpenAI-compatible LLM API (Claude, GPT, Gemini, etc.)
- You bring your own API key — no cloud lock-in

There's something about the crank. Physically scrolling through an AI conversation on a tiny monochrome screen makes you actually read every word. It's a Lo-Fi AI experience.

~500 lines of Lua + ~80 lines of Python.
MIT licensed: github.com/Narratify/CrankBot

Happy to answer any questions!
```

### 4. Playdate DevForum (Show & Tell)

```
Title: CrankBot — Lo-Fi AI Chatbot for Playdate (Open Source)

[動画]

Hi everyone! I built CrankBot — an AI chatbot that runs on your Playdate via a self-hosted API server.

I work on products at AI-MY (ai-my.net) under the theme of "anti-innovation / rediscovery." We recently won 3rd place + Anthropic Award at the Claude Hackathon with a Lo-Fi Camera that prints pixel art on thermal paper. CrankBot comes from the same impulse — what happens when you put AI on the most constrained screen possible?

## How it works

Playdate (Lua) ──HTTPS──▶ API Server (Python/FastAPI) ──▶ LLM API

The Playdate app sends user messages over HTTPS to a Python/FastAPI server, which queries any OpenAI-compatible LLM API (Claude, GPT, Gemini, Groq, etc.) and returns the response.

## Technical details

- On-screen keyboard for text input
- Conversation history with sliding window (last 6 exchanges)
- Crank-based scrolling for long responses
- Bearer token authentication
- Response buffering and word-wrap for the 400x240 display
- ~500 lines of Lua, ~80 lines of Python
- Works with any LLM provider that supports the OpenAI chat completions format

## What surprised me

The crank scroll changes the whole experience. You physically turn through each line of the AI's response. You end up actually reading every word — something that almost never happens with AI in a browser. The deliberate slowness feels like a feature.

## Setup

You'll need:
1. A Playdate
2. A server running Python 3 with FastAPI
3. An API key from any LLM provider (Anthropic, OpenAI, etc.)

Full instructions in the README.

## Source code

Everything is MIT licensed:
https://github.com/Narratify/CrankBot

I'd love feedback on:
- The on-screen keyboard UX
- Text rendering on the 1-bit display
- Any ideas for cool features

Thanks for checking it out!
```

### 5. Hacker News (Show HN)

```
Title: Show HN: CrankBot – Lo-Fi AI on a crank-powered 400x240 1-bit handheld

URL: shura.ai-my.net/pub/blog/crankbot.html

Text:
Every AI interface converges on the same design. CrankBot goes the other way — it's an AI chatbot on Playdate, a $229 handheld with a 400x240 1-bit display and a mechanical crank.

Type a message, the Playdate sends it to a self-hosted FastAPI server, the server queries any OpenAI-compatible LLM, and you crank through the response one line at a time. No streaming. No regenerate. You actually read every word.

~500 lines of Lua + ~80 lines of Python. Bring your own API key.

GitHub: https://github.com/Narratify/CrankBot
License: MIT
```

### 6. Reddit クロスポスト用 (r/IndieGaming, r/programming)

```
Title (r/IndieGaming): Lo-Fi AI — chatbot on a 400x240 1-bit crank-powered handheld

Title (r/programming): Every AI interface looks the same. I put one on a 400x240 1-bit screen with a crank (~500 lines of Lua + Python)

[動画]

[r/PlaydateConsole版をベースに、r/IndieGamingではLo-Fi体験の面白さを、r/programmingでは技術的制約との戦いを強調]
```

---

## 必要なアカウント

| プラットフォーム | 必要？ | 備考 |
|-----------------|--------|------|
| Twitter/X | 要確認 | えんちゃんの既存アカウント or 新規 |
| Reddit | 要確認 | 新規の場合、投稿制限に注意 |
| Playdate DevForum | 新規作成 | 事前に数日コメントが必要 |
| Hacker News | 要確認 | karma 250+推奨 |
| Discord (Playdate Squad) | 要確認 | discord.com/invite/zFKagQ2 |

## KPI目標

| プラットフォーム | 現実的目標 | 上振れ期待値 |
|-----------------|-----------|-------------|
| Twitter/X | 50-200 いいね、20-50 RT | 500+ (バイラル時) |
| Reddit r/PlaydateConsole | 30-100 upvotes | 200+ |
| Playdate DevForum | 10-30 リプライ | Panic社員からの言及 |
| Hacker News | 20-50 points | 100+ (フロントページ到達) |
| GitHub Stars (初週) | 30-100 | 289+ (HNフロントページ到達時) |
| Discord | 5-15 リアクション | — |
