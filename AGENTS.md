# CLAUDE.md — CrankBot

## プロジェクト概要

**CrankBot** — Playdate向けAIチャットボット。小さなクランク付きハンドヘルドゲーム機からClaudeと会話できる。

## 構成

```
crankbot/
├── app/                    # Playdateアプリ（Lua）— Narratify/playdate-agent-app
│   └── source/
│       ├── main.lua        # メインコード
│       ├── pdxinfo         # ゲームメタデータ
│       └── fonts/          # フォントファイル
├── api/                    # APIサーバー（Python/FastAPI）— Narratify/playdate-agent-api
│   ├── server.py           # /chat エンドポイント、LLM API呼び出し
│   ├── requirements.txt    # fastapi, uvicorn
│   └── playdate-api.service # systemd設定
└── CLAUDE.md
```

## 技術スタック

- **アプリ**: Lua (Playdate SDK)
- **API**: Python 3 / FastAPI / Uvicorn
- **AI**: OpenAI互換API経由（Anthropic / OpenAI / Gemini等）
- **通信**: HTTPS (Playdate → API サーバー)
- **認証**: Bearer token

## 公開方針

- ライセンス: MIT（Playdate SDK自体の再配布は不可）
- プロジェクト名に「Playdate」は商標上使用不可 → **CrankBot** を採用
- bundleID: `net.ai-my.crankbot`

## 継続更新タスク

- README.mdの更新（機能追加時）
- セキュリティ: 認証トークンがコードにハードコードされていないか確認
