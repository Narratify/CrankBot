# CrankBot プロモーション計画

**最終更新**: 2026-02-27
**調査レポート**: `outputs/2026-02-27-marketing-platform-research-UTR.md`

## 核心戦略: DIYハードウェアとしてフレーミングする

> Show HNで「AIプロジェクト」は死の象限。「DIY Hardwareプロジェクト」が全カテゴリ1位。
> CrankBotは**AIチャットボットではなく、クランク付きゲーム機で動くAI**として見せる。

---

## ターゲットコミュニティ & 投稿方法

| プラットフォーム | 投稿方法 | 状態 | 優先度 |
|------------------|----------|------|--------|
| **Twitter/X** (@_null) | API (tweepy) | ✅ API準備完了 | 最優先 |
| **Hacker News** (Enchan) | Playwright | karma 1（要蓄積） | 最優先 |
| **Dev.to** (enchan) | 手動 or API | ✅ 作成済み | 高 |
| **Hashnode** (@enchan) | 手動 | ✅ 作成済み | 高（canonical元） |
| **Zenn** (enchan) | 手動 | ✅ 作成済み | 高（日本語最優先） |
| **Substack** (@aimynoawai) | 手動 | ✅ 作成済み（AI-MY名義） | 高 |
| **Playdate DevForum** (enchan) | Playwright | ✅ 作成済み | 高 |
| **Playdate Squad Discord** | 手動（参加後） | 未参加・後回し | 中 |
| **Reddit** | Playwright | API事前審査制で断念 | 中 |
| **Qiita** | 手動 | 未確認 | 中 |
| **Medium** | 手動 | 未確認 | 低 |
| **note** | 手動 | 未確認 | 低 |
| **itch.io** | 手動 | 未確認 | 中（PDX配布） |

### API不要のプラットフォームはPlaywrightで自動化
Reddit / Discord / DevForum / HN など、API提供がないか制限のあるプラットフォームはPlaywrightで操作する。

---

## ローンチスケジュール

### Phase 0: 事前準備（D-7〜D-1）

- [x] 動画撮影済み
- [x] 英語ブログ記事公開済み (shura.ai-my.net/pub/blog/crankbot.html)
- [x] 日本語ブログ記事公開済み (shura.ai-my.net/pub/blog/crankbot-ja.html)
- [x] Twitter API設定完了 (@_null)
- [x] HNアカウント作成 (Enchan)
- [ ] README完成（GIF/動画、バッジ、Quick Start、アーキテクチャ図）
- [ ] デモGIF作成（クランク操作の実機映像、10秒以内）
- [ ] HN karmaを最低30+まで蓄積（コメント活動）
- [x] Hashnodeアカウント作成 (@enchan)
- [x] Dev.toアカウント作成 (enchan)
- [x] Zennアカウント作成 (enchan)
- [x] DevForumアカウント作成 (enchan)
- [x] Substackアカウント作成 (@aimynoawai, AI-MY名義)
- [x] テクニカル記事の英語版執筆（Dev.to/Hashnode用、writingスキル適用済み）
- [x] テクニカル記事の日本語版執筆（Zenn用、writingスキル+kisha校閲済み）
- [ ] Hashnodeカスタムドメイン設定 → canonical元
- [ ] DevForumコミュニティ参加（投稿前に数件コメント）
- [ ] 各プラットフォームのプロフィール設定（social-accounts.md参照）

### Phase 1: ローンチ日（D-Day、火〜木）

| 順序 | 時間 | プラットフォーム | 形式 |
|------|------|-----------------|------|
| 1 | 15:00-21:00 JST (6AM-12PM UTC) | **Show HN** | ブログ記事URL + 背景コメント |
| 2 | 同時 | **X/Twitter** | GIF/動画付きスレッド（英語） |
| 3 | 同日 | **Dev.to** | クロスポスト（canonical→Hashnode） |

**Show HNタイトル候補**:
```
Show HN: CrankBot – An AI chatbot for the Playdate handheld (crank to scroll responses)
```

### Phase 2: 拡張（D+1〜D+3）

| 順序 | プラットフォーム | 形式 |
|------|-----------------|------|
| 4 | Playdate DevForum | Show & Tell 長文 + 動画 |
| 5 | X/Twitter 日本語 | 日本語スレッド + 動画 |
| 6 | Reddit r/PlaydateConsole | 動画投稿 + テキスト（手動/Playwright） |
| 7 | Reddit r/IndieGaming, r/programming | クロスポスト |

### Phase 3: 日本語展開（D+3〜D+7）

| 順序 | プラットフォーム | 切り口 |
|------|-----------------|--------|
| 8 | **Zenn** | テクニカル記事（日本語、canonical元） |
| 9 | **Qiita** | クロスポスト |
| 10 | Medium | 英語ストーリー記事 |
| 11 | note | カジュアル読み物（日本語） |

### Phase 4: 継続（D+7〜）

- Playdate Squad Discord 参加・投稿
- itch.io にPDX配布
- フィードバック反映 → 更新告知

---

## クロスポスト戦略（canonical URL管理）

**原則: 1記事を複数プラットフォームに、canonical URLで重複ペナルティ回避**

### 英語記事
```
Hashnode（自ドメイン）← canonical元
  ├→ Dev.to（クロスポスト、canonical→Hashnode）
  └→ Medium（クロスポスト、canonical→Hashnode）
```

### 日本語記事
```
Zenn ← canonical元
  └→ Qiita（クロスポスト、canonical→Zenn）
note は切り口を変えて別記事（カジュアル読み物）
```

---

## コンテンツ戦略: 1ネタ3バリエーション

**A. テクニカル記事**（Dev.to / Hashnode / Zenn / Qiita向け）
- タイトル例: "Building an AI chatbot for Playdate's 400x240 1-bit display"
- 内容: アーキテクチャ、Lua実装、FastAPI連携、LLM API最適化

**B. ストーリー記事**（Medium / note向け）
- タイトル例: "I put ChatGPT on a tiny crank-powered game console"
- 内容: なぜ作ったか、制約の面白さ、Lo-Fi AIの思想

**C. Show HN/Twitter向け**
- 短く、ビジュアル重視、GIF必須
- フレーミング: ハードウェア × 制約 × 意外性

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
Title: Show HN: CrankBot – An AI chatbot for the Playdate handheld (crank to scroll responses)

URL: shura.ai-my.net/pub/blog/crankbot.html

Text:
Every AI interface converges on the same design. CrankBot goes the other way — it's an AI chatbot on Playdate, a $229 handheld with a 400x240 1-bit display and a mechanical crank.

Type a message, the Playdate sends it to a self-hosted FastAPI server, the server queries any OpenAI-compatible LLM, and you crank through the response one line at a time. No streaming. No regenerate. You actually read every word.

~500 lines of Lua + ~80 lines of Python. Bring your own API key.

GitHub: https://github.com/Narratify/CrankBot
License: MIT
```

### 6. Reddit クロスポスト用

```
Title (r/IndieGaming): Lo-Fi AI — chatbot on a 400x240 1-bit crank-powered handheld

Title (r/programming): Every AI interface looks the same. I put one on a 400x240 1-bit screen with a crank (~500 lines of Lua + Python)

[動画]

[r/PlaydateConsole版をベースに、r/IndieGamingではLo-Fi体験の面白さを、r/programmingでは技術的制約との戦いを強調]
```

---

## アカウント情報

**詳細は `/home/agent/narratify/core/marketing/` を参照**（ペルソナ別分類・認証情報・導線設計・プロフィール設定）

| プラットフォーム | 名義 | アカウント | 投稿方法 | 状態 |
|-----------------|------|-----------|---------|------|
| Twitter/X | えんちゃん | @_null | API (tweepy) | ✅ 稼働中 |
| Hacker News | えんちゃん | Enchan | Playwright | ✅ karma 1 |
| Dev.to | えんちゃん | enchan | 手動/API | ✅ 作成済み |
| Hashnode | えんちゃん | @enchan | 手動 | ✅ 作成済み |
| Zenn | えんちゃん | enchan | 手動 | ✅ 作成済み |
| DevForum | えんちゃん | enchan | Playwright | ✅ 作成済み |
| Substack | AI-MY | @aimynoawai | 手動 | ✅ 作成済み |
| Reddit | えんちゃん | — | Playwright | 🔶 後回し |
| Discord | えんちゃん | — | 手動 | 🔶 後回し |

---

## KPI目標

| プラットフォーム | 現実的目標 | 上振れ期待値 |
|-----------------|-----------|-------------|
| **Show HN** | 20-50 points | 100+ (フロントページ → 10K-30K visitors) |
| Twitter/X | 50-200 いいね、20-50 RT | 500+ (バイラル時) |
| Reddit r/PlaydateConsole | 30-100 upvotes | 200+ |
| Playdate DevForum | 10-30 リプライ | Panic社員からの言及 |
| GitHub Stars (初週) | 30-100 | 289+ (HNフロントページ到達時) |
| Discord | 5-15 リアクション | — |
| Dev.to | 1,500-5,000 views | — |
| Zenn | SEO経由で長期的な流入 | 日本語Playdate記事でSEO独占 |

---

## リスク & 注意点

1. **HN AI疲れ**: タイトルに「AI」を入れるなら、必ず「Playdate」「crank」など物理要素とセット
2. **HN投票リング検出**: アップボートを絶対に他人に頼まない
3. **Reddit API制限**: Responsible Builder Policy（2025年11月〜）により自動投稿困難
4. **canonical忘れ**: クロスポスト時に必ずcanonical URLを設定（SEOペナルティ回避）
5. **Playdate市場規模**: 70,000台。ニッチチャネルだけではリーチに限界。一般テック層へのリーチが重要
