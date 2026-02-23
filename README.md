# CrankBot

> AI chatbot for [Playdate](https://play.date/) — talk to Claude with the crank.

CrankBot lets you have conversations with an AI (Claude) directly on your Playdate handheld. Type a message using the on-screen keyboard, and get AI-powered responses on the 400x240 1-bit display.

## How It Works

```
Playdate (Lua) ──HTTPS──▶ API Server (Python/FastAPI) ──▶ Claude CLI
```

1. **Playdate app** — Sends your message to the API server over HTTPS
2. **API server** — Receives the request, calls `claude -p`, returns the response
3. **Playdate app** — Displays the AI response with crank-based scrolling

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
   export CLAUDE_PATH="/path/to/claude"  # defaults to "claude" (must be in PATH)
   export TIMEOUT=120  # seconds, optional
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
- A server running the API with [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) installed
- HTTPS endpoint accessible from Playdate (e.g., via reverse proxy)

## Note

This project requires [Playdate SDK](https://play.date/dev/) to build the app. The SDK itself is not included and cannot be redistributed per Panic's terms.

## License

MIT — see [LICENSE](LICENSE)
