<p align="center">
  <img src="https://img.shields.io/badge/platform-Playdate-yellow?style=flat-square" alt="Playdate">
  <img src="https://img.shields.io/badge/language-Lua-blue?style=flat-square" alt="Lua">
  <img src="https://img.shields.io/badge/server-Python%2FFastAPI-green?style=flat-square" alt="Python/FastAPI">
  <img src="https://img.shields.io/badge/license-MIT-brightgreen?style=flat-square" alt="MIT License">
</p>

# CrankBot

**AI chatbot on a crank-powered 400×240 1-bit handheld.**

![CrankBot Demo](docs/demo.gif)

Type a message on the on-screen keyboard. The Playdate sends it to your self-hosted server, which queries any LLM. Crank through the response, one line at a time. No streaming. No regenerate. You actually read every word.

~500 lines of Lua + ~80 lines of Python. Bring your own API key.

## Architecture

```
┌──────────────┐        HTTPS        ┌──────────────┐        API        ┌──────────────┐
│              │  ──────────────────▶ │              │  ───────────────▶ │              │
│   Playdate   │   POST /chat        │  FastAPI     │   Chat           │   LLM API    │
│   (Lua)      │   Bearer token      │  Server      │   Completions    │   (Any)      │
│              │ ◀────────────────── │  (Python)    │ ◀─────────────── │              │
└──────────────┘    JSON response    └──────────────┘    Response       └──────────────┘
  400×240 1-bit                        Self-hosted                       Claude / GPT /
  Crank scroll                         Your server                       Gemini / Groq
```

## Quick Start

### 1. Set up the API server

```bash
git clone https://github.com/Narratify/CrankBot.git
cd CrankBot
pip install -r api/requirements.txt
```

```bash
# Set your credentials
export API_TOKEN="your-secret-token"
export LLM_API_KEY="your-api-key"
export LLM_BASE_URL="https://api.anthropic.com/v1"   # or any OpenAI-compatible endpoint
export LLM_MODEL="claude-sonnet-4-20250514"           # or gpt-4o-mini, gemini-pro, etc.

# Run
uvicorn api.server:app --host 127.0.0.1 --port 8000
```

You'll need HTTPS for the Playdate to connect (e.g., via nginx reverse proxy with Let's Encrypt).

### 2. Build the Playdate app

Edit `app/source/main.lua` — set your `HOST`, `PORT`, and `AUTH_TOKEN`:

```lua
local HOST <const> = "your-server.example.com"
local PORT <const> = 443
local USE_SSL <const> = true
local AUTH_TOKEN <const> = "your-secret-token"
```

Build with the [Playdate SDK](https://play.date/dev/):

```bash
pdc app/source app/CrankBot.pdx
```

### 3. Sideload and chat

Copy `CrankBot.pdx` to your Playdate and start chatting.

## Controls

| Input | Action |
|-------|--------|
| **A** | Open keyboard / send message |
| **B** | Clear conversation |
| **Crank** | Scroll through responses |
| **D-pad** | Scroll (alternative) |

## Supported LLM Providers

The server uses the OpenAI-compatible chat completions format. Any provider that supports it works:

| Provider | Base URL | Example Model |
|----------|----------|---------------|
| **Anthropic** | `https://api.anthropic.com/v1` | `claude-sonnet-4-20250514` |
| **OpenAI** | `https://api.openai.com/v1` | `gpt-4o-mini` |
| **Google** | `https://generativelanguage.googleapis.com/v1beta/openai` | `gemini-pro` |
| **Groq** | `https://api.groq.com/openai/v1` | `llama-3.1-8b-instant` |
| **OpenRouter** | `https://openrouter.ai/api/v1` | Any model |

## Server Configuration

All settings are environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `API_TOKEN` | — | Bearer token for Playdate auth |
| `LLM_API_KEY` | — | Your LLM provider API key |
| `LLM_BASE_URL` | `https://api.anthropic.com/v1` | OpenAI-compatible endpoint |
| `LLM_MODEL` | `claude-sonnet-4-20250514` | Model to use |
| `MAX_TOKENS` | `256` | Max response tokens |
| `TIMEOUT` | `120` | Request timeout (seconds) |
| `SYSTEM_PROMPT` | *(built-in)* | Custom system prompt |

## Project Structure

```
CrankBot/
├── app/                    # Playdate app (Lua)
│   └── source/
│       ├── main.lua        # Main application (~500 lines)
│       ├── pdxinfo         # Game metadata
│       └── fonts/          # Display fonts
├── api/                    # API server (Python)
│   ├── server.py           # FastAPI server (~80 lines)
│   ├── requirements.txt
│   └── crankbot-api.service  # systemd unit (optional)
├── LICENSE
└── README.md
```

## How It Works

**On the Playdate** (`main.lua`):
- On-screen keyboard for text input
- JSON encoding of messages + conversation history (last 6 exchanges)
- HTTPS POST to your server with Bearer token auth
- Word-wrap rendering for the 400×240 display
- Crank-based and D-pad scrolling

**On the server** (`server.py`):
- FastAPI with Bearer token authentication
- Forwards messages to any OpenAI-compatible LLM API
- Always returns HTTP 200 (Playdate SDK quirk: non-200 breaks callbacks)
- Health check endpoint at `/health`

## Requirements

- [Playdate](https://play.date/) handheld
- [Playdate SDK](https://play.date/dev/) to build the app
- Python 3.8+ for the API server
- An LLM API key (Anthropic, OpenAI, etc.)
- HTTPS endpoint accessible from the Playdate

## About

CrankBot is made by [AI-MY](https://ai-my.net) under the theme of *anti-innovation / rediscovery* — using technology to rediscover what progress has overlooked.

Every AI interface converges on the same design. CrankBot goes the other way: a 400×240 1-bit screen, a mechanical crank, and every word read deliberately.

## License

MIT — see [LICENSE](LICENSE)
