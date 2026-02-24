#!/usr/bin/env python3
"""
CrankBot API Server
Receives HTTP requests from Playdate and queries an LLM.
Supports any OpenAI-compatible API (Anthropic, OpenAI, Gemini, Groq, OpenRouter, Qwen, etc.)
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
LLM_BASE_URL = os.environ.get("LLM_BASE_URL", "https://api.anthropic.com/v1")
LLM_API_KEY = os.environ.get("LLM_API_KEY", "")
LLM_MODEL = os.environ.get("LLM_MODEL", "claude-sonnet-4-20250514")
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


async def query_llm(history, message):
    """Query LLM via OpenAI-compatible API."""
    client = get_openai_client()
    messages = build_messages(history, message)

    loop = asyncio.get_event_loop()
    response = await loop.run_in_executor(None, lambda: client.chat.completions.create(
        model=LLM_MODEL,
        messages=messages,
        max_tokens=MAX_TOKENS,
    ))
    return response.choices[0].message.content.strip()


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
    logging.info(f"Request: {message[:80]}... (model={LLM_MODEL}, history={len(history)})")

    try:
        response_text = await asyncio.wait_for(query_llm(history, message), timeout=TIMEOUT)
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
        "model": LLM_MODEL,
    }
