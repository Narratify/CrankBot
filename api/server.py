#!/usr/bin/env python3
"""
CrankBot API Server
Receives HTTP requests from Playdate and queries an LLM.
Supports: claude -p (CLI), OpenAI-compatible APIs (OpenAI, Gemini, Groq, OpenRouter, Qwen, etc.)
Always returns HTTP 200 (Playdate SDK bug: non-200 breaks callback).
"""

from fastapi import FastAPI, Request, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import JSONResponse
import asyncio
import os
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

app = FastAPI()
security = HTTPBearer()

# Auth
TOKEN = os.environ.get("API_TOKEN", "")

# LLM config
LLM_PROVIDER = os.environ.get("LLM_PROVIDER", "claude-cli")  # claude-cli | openai
LLM_BASE_URL = os.environ.get("LLM_BASE_URL", "https://api.openai.com/v1")
LLM_API_KEY = os.environ.get("LLM_API_KEY", "")
LLM_MODEL = os.environ.get("LLM_MODEL", "gpt-4o-mini")
CLAUDE_PATH = os.environ.get("CLAUDE_PATH", "claude")
TIMEOUT = int(os.environ.get("TIMEOUT", "120"))
MAX_TOKENS = int(os.environ.get("MAX_TOKENS", "256"))

SYSTEM_PROMPT = os.environ.get("SYSTEM_PROMPT",
    "You are CrankBot, a friendly AI chatbot living inside a Playdate game console. "
    "Keep responses concise: UNDER 300 characters, because the screen is very small (400x240 pixels). "
    "Be casual, witty, and fun. Use only ASCII characters."
)

# OpenAI client (lazy init)
_client = None

def get_openai_client():
    global _client
    if _client is None:
        from openai import OpenAI
        _client = OpenAI(base_url=LLM_BASE_URL, api_key=LLM_API_KEY)
    return _client


def verify(creds: HTTPAuthorizationCredentials = Depends(security)):
    if not TOKEN or creds.credentials != TOKEN:
        raise HTTPException(status_code=401, detail="Unauthorized")


@app.exception_handler(HTTPException)
async def always_200(request: Request, exc: HTTPException):
    if exc.status_code == 401:
        return JSONResponse(status_code=200, content={"response": "[Auth Error] Invalid token", "error": True})
    return JSONResponse(status_code=200, content={"response": f"[Error {exc.status_code}] {exc.detail}", "error": True})


def build_messages(history, current_message):
    """Build OpenAI-format messages array."""
    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    for entry in history:
        role = entry.get("role", "")
        content = entry.get("content", "")
        if role in ("user", "assistant"):
            messages.append({"role": role, "content": content})
    messages.append({"role": "user", "content": current_message})
    return messages


def build_prompt_text(history, current_message):
    """Build plain text prompt for claude -p."""
    lines = []
    for entry in history:
        role = entry.get("role", "")
        content = entry.get("content", "")
        if role == "user":
            lines.append(f"User: {content}")
        elif role == "assistant":
            lines.append(f"Assistant: {content}")
    lines.append(f"User: {current_message}")
    lines.append("Assistant:")
    return "\n".join(lines)


async def query_openai(history, message):
    """Query OpenAI-compatible API."""
    client = get_openai_client()
    messages = build_messages(history, message)

    loop = asyncio.get_event_loop()
    response = await loop.run_in_executor(None, lambda: client.chat.completions.create(
        model=LLM_MODEL,
        messages=messages,
        max_tokens=MAX_TOKENS,
    ))
    return response.choices[0].message.content.strip()


async def query_claude_cli(history, message):
    """Query via claude -p subprocess."""
    full_prompt = build_prompt_text(history, message)
    proc = await asyncio.create_subprocess_exec(
        CLAUDE_PATH, "-p", full_prompt, "--system-prompt", SYSTEM_PROMPT,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await asyncio.wait_for(proc.communicate(), timeout=TIMEOUT)
    if proc.returncode != 0:
        err = stderr.decode().strip()
        raise RuntimeError(err[:200])
    return stdout.decode().strip()


@app.post("/chat")
async def chat(req: Request, _=Depends(verify)):
    try:
        body = await req.json()
    except Exception:
        return {"response": "[Error] JSON parse failed", "error": True}

    message = body.get("message", "").strip()
    if not message:
        return {"response": "[Error] Empty message", "error": True}

    history = body.get("history", [])
    logging.info(f"Request: {message[:80]}... (provider={LLM_PROVIDER}, model={LLM_MODEL}, history={len(history)})")

    try:
        if LLM_PROVIDER == "openai":
            response_text = await asyncio.wait_for(query_openai(history, message), timeout=TIMEOUT)
        else:
            response_text = await query_claude_cli(history, message)

        logging.info(f"Response: {len(response_text)} chars")
        return {"response": response_text}

    except asyncio.TimeoutError:
        logging.error(f"Timeout after {TIMEOUT}s")
        return {"response": f"[Timeout] exceeded {TIMEOUT}s", "error": True}
    except Exception as e:
        logging.error(f"LLM error: {e}")
        return {"response": f"[Error] {str(e)[:200]}", "error": True}


@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "provider": LLM_PROVIDER,
        "model": LLM_MODEL if LLM_PROVIDER == "openai" else "claude-cli",
    }
