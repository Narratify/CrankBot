# CrankBot

> AI chatbot for [Playdate](https://play.date/) — talk to AI with the crank.

CrankBot lets you have conversations with an AI directly on your Playdate handheld. Type a message using the on-screen keyboard, and get AI-powered responses on the 400x240 1-bit display.

## How It Works

```
Playdate (Lua) ──HTTPS──▶ API Server (Python/FastAPI) ──▶ LLM API
```

1. **Playdate app** — Sends your message to the API server over HTTPS
2. **API server** — Receives the request, queries the LLM API, returns the response
3. **Playdate app** — Displays the AI response with crank-based scrolling

The server uses the OpenAI-compatible chat completions format, so it works with many providers:
- **Anthropic** (Claude) — via API key
- **OpenAI** (GPT)
- **Google** (Gemini)
- **Groq**, **OpenRouter**, **Qwen**, and others

## Project Structure

```
CrankBot/
├── app/                # Playdate app (Lua)
│   └── source/
│       ├── main.lua    # Main application
│       └── pdxinfo     # Game metadata
├── api/                # API server (Python)
│   ├── server.py       # FastAPI server
│   ├── requirements.txt
│   └── crankbot-api.service  # systemd unit
├── LICENSE
└── README.md
```

## Setup

### API Server

1. Install dependencies:
   ```bash
   pip install -r api/requirements.txt
   ```

2. Set environment variables:
   ```bash
   export API_TOKEN="your-secret-token"
   export LLM_API_KEY="your-api-key"

   # Anthropic (default)
   export LLM_BASE_URL="https://api.anthropic.com/v1"
   export LLM_MODEL="claude-sonnet-4-20250514"

   # Or: OpenAI
   export LLM_BASE_URL="https://api.openai.com/v1"
   export LLM_MODEL="gpt-4o-mini"

   # Or: any OpenAI-compatible provider
   export LLM_BASE_URL="https://your-provider.com/v1"
   export LLM_MODEL="model-name"
   ```

3. Run:
   ```bash
   uvicorn api.server:app --host 127.0.0.1 --port 8000
   ```

### Playdate App

1. Edit `app/source/main.lua` — set your `HOST`, `PORT`, and `AUTH_TOKEN`
2. Build with the [Playdate SDK](https://play.date/dev/):
   ```bash
   pdc app/source app/CrankBot.pdx
   ```
3. Sideload `CrankBot.pdx` to your Playdate

## Controls

| Input | Action |
|-------|--------|
| **A** | Open keyboard / send message |
| **B** | Clear conversation |
| **Crank** | Scroll through responses |
| **D-pad** | Scroll (alternative) |

## Requirements

- [Playdate](https://play.date/) with firmware supporting `playdate.network.http`
- A server running the API with an LLM API key (Anthropic, OpenAI, etc.)
- HTTPS endpoint accessible from Playdate (e.g., via reverse proxy)

## Note

This project requires [Playdate SDK](https://play.date/dev/) to build the app. The SDK itself is not included and cannot be redistributed per Panic's terms.

## License

MIT — see [LICENSE](LICENSE)
