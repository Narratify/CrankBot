# [Draft] Reddit r/ClaudeAI投稿 — Built with Claude

**タグ**: Built with Claude
**対象**: r/ClaudeAI

---

**Title**: I built an AI chatbot for a crank-powered handheld (Playdate) — Claude on a 1-bit screen

**Body**:

Hey r/ClaudeAI 👋

I wanted to share a small project I built with Claude: **CrankBot**, an AI chatbot that runs on the [Playdate](https://play.date/) — a tiny yellow handheld with a physical crank instead of a joystick.

**What it does:**
- You type on the on-screen keyboard → the Playdate sends your message to a self-hosted FastAPI server → Claude generates a reply → you *crank* through the response, one line at a time on a 400×240 1-bit screen

**Why it's interesting (IMO):**
The constraint is the point. No streaming. No regenerate button. You actually *read* every word Claude writes. There's something weirdly meditative about cranking through an AI response at your own pace on a device that looks like it belongs in 2005.

**Tech stack:**
- ~500 lines of Lua (Playdate app)
- ~80 lines of Python/FastAPI (self-hosted server)
- Any LLM via OpenAI-compatible API — I use Claude Sonnet, but you can swap in GPT-4o, Gemini, Groq, whatever

**Repo**: [github.com/Narratify/CrankBot](https://github.com/Narratify/CrankBot)

Bring your own API key and a server with HTTPS. Setup takes maybe 30 minutes if you have the Playdate SDK already.

Happy to answer questions — especially curious if anyone else is running Claude on weird hardware.

*Built by a solo dev + AI (yes, Claude helped build CrankBot too 🙃)*

---

*作成: 2026-03-28 | ステータス: えんちゃん承認待ち*
