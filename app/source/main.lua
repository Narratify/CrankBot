-- CrankBot — AI Chatbot for Playdate
-- Talk to Claude from your Playdate

import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/keyboard"

local gfx <const> = playdate.graphics

-- ============================================================
-- Config
-- ============================================================

local HOST <const> = "your-server.example.com"  -- Replace with your API server hostname
local PORT <const> = 443
local USE_SSL <const> = true
local API_PATH <const> = "/chat"
local AUTH_TOKEN <const> = "YOUR_TOKEN_HERE"  -- Replace with your API token

-- ============================================================
-- Display constants
-- ============================================================

local SCREEN_W <const> = 400
local SCREEN_H <const> = 240
local MARGIN <const> = 6
local TEXT_W <const> = SCREEN_W - MARGIN * 2 - 6  -- room for scrollbar
local MAX_HISTORY <const> = 6  -- keep last N exchanges for context

-- ============================================================
-- Font setup
-- ============================================================

local fontBody = gfx.font.new("fonts/Roobert-11-Medium")
local fontBold = gfx.font.new("fonts/Roobert-11-Bold")
if not fontBody then
    fontBody = gfx.getSystemFont(gfx.font.kVariantNormal)
end
if not fontBold then
    fontBold = gfx.getSystemFont(gfx.font.kVariantBold)
end
local LINE_HEIGHT = fontBody:getHeight() + 2

-- ============================================================
-- State
-- ============================================================

local STATE_INPUT    <const> = 1
local STATE_SENDING  <const> = 2
local STATE_RESPONSE <const> = 3

local state = STATE_INPUT
local inputText = ""
local scrollY = 0
local maxScroll = 0
local dotCount = 0
local dotTimer = 0

-- Conversation history: array of {role="user"/"assistant", content="..."}
local history = {}
-- Display text built from full conversation
local displayText = ""
-- Latest response for adding to history
local latestResponse = ""

-- ============================================================
-- JSON helpers
-- ============================================================

local function jsonEscape(s)
    s = s:gsub('\\', '\\\\')
    s = s:gsub('"', '\\"')
    s = s:gsub('\n', '\\n')
    s = s:gsub('\r', '\\r')
    s = s:gsub('\t', '\\t')
    s = s:gsub('[\x00-\x1f]', function(c)
        return string.format('\\u%04x', string.byte(c))
    end)
    return s
end

local function buildHistoryJson()
    if #history == 0 then return "[]" end
    local parts = {}
    -- Send last MAX_HISTORY entries
    local start = math.max(1, #history - MAX_HISTORY + 1)
    for i = start, #history do
        local h = history[i]
        parts[#parts + 1] = '{"role":"' .. h.role .. '","content":"' .. jsonEscape(h.content) .. '"}'
    end
    return "[" .. table.concat(parts, ",") .. "]"
end

local function buildRequestBody(message)
    return '{"message":"' .. jsonEscape(message) .. '","history":' .. buildHistoryJson() .. '}'
end

-- ============================================================
-- Build display text from conversation history
-- ============================================================

local function rebuildDisplayText()
    local parts = {}
    for _, h in ipairs(history) do
        if h.role == "user" then
            parts[#parts + 1] = "> " .. h.content
        else
            parts[#parts + 1] = h.content
        end
        parts[#parts + 1] = ""
    end
    displayText = table.concat(parts, "\n")
end

-- ============================================================
-- Text wrapping helper
-- ============================================================

local function wrapText(text, maxWidth, font)
    font = font or fontBody
    local lines = {}
    for segment in text:gmatch("([^\n]*)\n?") do
        if segment == "" then
            lines[#lines + 1] = ""
        else
            local line = ""
            for word in segment:gmatch("%S+") do
                local test = line == "" and word or (line .. " " .. word)
                if font:getTextWidth(test) > maxWidth and line ~= "" then
                    lines[#lines + 1] = line
                    line = word
                else
                    line = test
                end
            end
            if line ~= "" then
                lines[#lines + 1] = line
            end
        end
    end
    return lines
end

-- ============================================================
-- Networking
-- ============================================================

local conn = nil
local lastSentMessage = ""

local function sendMessage(message)
    state = STATE_SENDING
    dotCount = 0
    dotTimer = 0
    lastSentMessage = message
    scrollY = 0

    conn = playdate.network.http.new(HOST, PORT, USE_SSL, "Contacting CrankBot")
    if not conn then
        latestResponse = "[Error] Failed to create connection."
        history[#history + 1] = {role = "user", content = message}
        history[#history + 1] = {role = "assistant", content = latestResponse}
        rebuildDisplayText()
        state = STATE_RESPONSE
        return
    end

    local responseStatus = 0
    local body = ""

    conn:setHeadersReadCallback(function()
        responseStatus = conn:getResponseStatus()
    end)

    conn:setRequestCallback(function()
        local avail = conn:getBytesAvailable()
        if avail > 0 then
            body = body .. conn:read(avail)
        end
    end)

    conn:setRequestCompleteCallback(function()
        conn:close()
        conn = nil

        -- Extract response from JSON
        local resp = body:match('"response"%s*:%s*"(.-)"')
        if resp then
            resp = resp:gsub('\\n', '\n')
            resp = resp:gsub('\\r', '')
            resp = resp:gsub('\\"', '"')
            resp = resp:gsub('\\\\', '\\')
            latestResponse = resp
        else
            latestResponse = body
        end

        -- Add to history
        history[#history + 1] = {role = "user", content = message}
        history[#history + 1] = {role = "assistant", content = latestResponse}
        rebuildDisplayText()

        -- Auto-scroll to bottom
        local lines = wrapText(displayText, TEXT_W)
        local totalH = #lines * LINE_HEIGHT
        local contentH = SCREEN_H - MARGIN * 2 - LINE_HEIGHT - 4
        maxScroll = math.max(0, totalH - contentH)
        scrollY = maxScroll

        state = STATE_RESPONSE
    end)

    conn:setConnectionClosedCallback(function()
        if state == STATE_SENDING then
            latestResponse = "[Error] Connection closed."
            history[#history + 1] = {role = "user", content = message}
            history[#history + 1] = {role = "assistant", content = latestResponse}
            rebuildDisplayText()
            state = STATE_RESPONSE
            conn = nil
        end
    end)

    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. AUTH_TOKEN,
    }

    local reqBody = buildRequestBody(message)
    local ok, err = conn:post(API_PATH, headers, reqBody)
    if not ok then
        latestResponse = "[Error] " .. tostring(err)
        history[#history + 1] = {role = "user", content = message}
        history[#history + 1] = {role = "assistant", content = latestResponse}
        rebuildDisplayText()
        state = STATE_RESPONSE
        conn = nil
    end
end

-- ============================================================
-- Keyboard callbacks
-- ============================================================

local keyboardOpen = false

function playdate.keyboard.textChangedCallback()
    inputText = playdate.keyboard.text or ""
end

function playdate.keyboard.keyboardWillHideCallback(ok)
    keyboardOpen = false
    if ok and inputText ~= "" then
        sendMessage(inputText)
        inputText = ""
    end
end

-- ============================================================
-- Input handlers
-- ============================================================

local function handleInputState()
    -- A button: open keyboard
    if playdate.buttonJustPressed(playdate.kButtonA) and not keyboardOpen then
        keyboardOpen = true
        inputText = ""
        playdate.keyboard.show("")
    end
end

local function handleResponseState()
    -- A button: new message (continue conversation)
    if playdate.buttonJustPressed(playdate.kButtonA) and not keyboardOpen then
        keyboardOpen = true
        inputText = ""
        playdate.keyboard.show("")
    end

    -- B button: clear history and start fresh
    if playdate.buttonJustPressed(playdate.kButtonB) then
        history = {}
        displayText = ""
        inputText = ""
        scrollY = 0
        state = STATE_INPUT
        return
    end

    -- Crank scroll
    local change = playdate.getCrankChange()
    if change ~= 0 then
        scrollY = scrollY + change * 0.5
        if scrollY < 0 then scrollY = 0 end
        if scrollY > maxScroll then scrollY = maxScroll end
    end

    -- D-pad scroll
    if playdate.buttonIsPressed(playdate.kButtonUp) then
        scrollY = scrollY - 3
        if scrollY < 0 then scrollY = 0 end
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        scrollY = scrollY + 3
        if scrollY > maxScroll then scrollY = maxScroll end
    end
end

-- ============================================================
-- Drawing
-- ============================================================

local function drawInputScreen()
    gfx.setFont(fontBold)
    gfx.drawTextAligned("CrankBot", SCREEN_W / 2, 30, kTextAlignment.center)

    gfx.setFont(fontBody)
    if #history == 0 then
        gfx.drawTextAligned("Press A to start chatting", SCREEN_W / 2, 100, kTextAlignment.center)
    else
        gfx.drawTextAligned("Press A to continue", SCREEN_W / 2, 100, kTextAlignment.center)
    end
end

local function drawSendingScreen()
    dotTimer = dotTimer + 1
    if dotTimer >= 15 then
        dotTimer = 0
        dotCount = (dotCount + 1) % 4
    end
    local dots = string.rep(".", dotCount)

    gfx.setFont(fontBody)
    gfx.drawTextAligned("Sending" .. dots, SCREEN_W / 2, 105, kTextAlignment.center)
    gfx.drawTextAligned(lastSentMessage, SCREEN_W / 2, 125, kTextAlignment.center)
end

local function drawConversation()
    local lines = wrapText(displayText, TEXT_W)
    local totalHeight = #lines * LINE_HEIGHT
    local headerY = MARGIN
    local contentTop = headerY + LINE_HEIGHT + 4
    local contentH = SCREEN_H - contentTop - MARGIN

    maxScroll = math.max(0, totalHeight - contentH)

    -- Header
    gfx.setFont(fontBold)
    gfx.drawText("A:reply  B:new chat", MARGIN, headerY)

    -- Scroll info on right
    gfx.setFont(fontBody)
    if maxScroll > 0 then
        local pct = math.floor((scrollY / maxScroll) * 100)
        gfx.drawTextAligned(pct .. "%", SCREEN_W - MARGIN, headerY, kTextAlignment.right)
    end

    -- Separator line
    gfx.drawLine(MARGIN, contentTop - 2, SCREEN_W - MARGIN, contentTop - 2)

    -- Content area
    gfx.setClipRect(MARGIN, contentTop, TEXT_W + 6, contentH)
    gfx.setFont(fontBody)

    local y = contentTop - scrollY
    for _, line in ipairs(lines) do
        if y + LINE_HEIGHT > contentTop - LINE_HEIGHT and y < contentTop + contentH + LINE_HEIGHT then
            -- User lines start with "> "
            if line:sub(1, 2) == "> " then
                gfx.setFont(fontBold)
                gfx.drawText(line, MARGIN, y)
                gfx.setFont(fontBody)
            else
                gfx.drawText(line, MARGIN, y)
            end
        end
        y = y + LINE_HEIGHT
    end

    gfx.clearClipRect()

    -- Scrollbar
    if maxScroll > 0 then
        local barH = math.max(10, contentH * (contentH / totalHeight))
        local barY = contentTop + (scrollY / maxScroll) * (contentH - barH)
        gfx.fillRect(SCREEN_W - 3, barY, 2, barH)
    end
end

-- ============================================================
-- Draw input preview above keyboard
-- ============================================================

local function drawKeyboardPreview()
    -- Keyboard uses bottom ~half of screen. Top area is ~100px usable.
    local previewH = 90
    gfx.setClipRect(0, 0, SCREEN_W, previewH)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, SCREEN_W, previewH)
    gfx.setColor(gfx.kColorBlack)

    gfx.setFont(fontBold)
    gfx.drawText("Input:", MARGIN, MARGIN)

    gfx.setFont(fontBody)
    local txt = inputText
    if txt == "" then
        txt = "..."
    end
    local lines = wrapText(txt, TEXT_W)
    local y = MARGIN + LINE_HEIGHT + 2
    for i, line in ipairs(lines) do
        if y > previewH - 4 then break end
        gfx.drawText(line, MARGIN, y)
        y = y + LINE_HEIGHT
    end

    -- Bottom border
    gfx.drawLine(0, previewH - 1, SCREEN_W, previewH - 1)
    gfx.clearClipRect()
end

-- ============================================================
-- Main update loop
-- ============================================================

function playdate.update()
    gfx.clear()

    if keyboardOpen then
        drawKeyboardPreview()
    elseif state == STATE_INPUT then
        handleInputState()
        drawInputScreen()
    elseif state == STATE_SENDING then
        drawSendingScreen()
    elseif state == STATE_RESPONSE then
        handleResponseState()
        drawConversation()
    end

    playdate.timer.updateTimers()
end
