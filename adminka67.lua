--[[ ═══════════════════════════════════════════════════════
     🔥 АДМИНКА ВАНЬКА v2.1 PREMIUM 🔥
     Автопоиск логотипа: adminka.png
     Папка: vanya/  (можно менять в LOGO_PATHS)
     Хоткей: RightShift — скрыть/показать
     ═══════════════════════════════════════════════════════ ]]

if _G.VankaV2 and _G.VankaV2.destroy then pcall(_G.VankaV2.destroy) end

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UserInput    = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP     = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse  = LP:GetMouse()

_G.VankaV2 = { conns = {}, gui = nil, destroy = nil }
local V = _G.VankaV2
local function addConn(c) table.insert(V.conns, c) end

-- ══════════════════ ЛОГОТИП ИЗ ПАПКИ ══════════════════
local LOGO_PATHS = {
    "vanya/adminka.png",       -- ← твоя папка
    "vanka/adminka.png",       -- запасные варианты
    "adminka.png",
    "vanya/logo.png",
    "logo.png",
}

local LOGO_ASSET = nil
local LOGO_FOUND = false

local function findLogo()
    if not (isfile and getcustomasset) then
        return false
    end

    -- Дополнительно: если экзекутор знает путь к скрипту, ищем рядом
    if getscriptpath then
        local ok, sp = pcall(getscriptpath)
        if ok and sp then
            local dir = sp:match("^(.*)[/\\][^/\\]+$")
            if dir then
                table.insert(LOGO_PATHS, 1, dir .. "/adminka.png")
            end
        end
    end

    -- Перебираем все пути
    for _, path in ipairs(LOGO_PATHS) do
        local ok, exists = pcall(isfile, path)
        if ok and exists then
            local ok2, asset = pcall(getcustomasset, path)
            if ok2 and type(asset) == "string" and asset ~= "" then
                LOGO_ASSET = asset
                LOGO_FOUND = true
                return true
            end
        end
    end
    return false
end

findLogo()

-- ══════════════════ СОСТОЯНИЕ ══════════════════
local S = {
    esp = false, roleHighlight = false,
    aimbot = false, silentAim = false,
    fovCircle = true, fovRadius = 180,
    autoCamper = false, camperTarget = nil,
    wallbang = false,
    fly = false, noclip = false, infJump = false,
    speed = 16, jumpPower = 50,
    highlights = {}, aimTarget = nil,
}

-- ══════════════════ UI CORE ══════════════════
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "VankaAdminV2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui
V.gui = gui

-- ═════ ГЛАВНОЕ ОКНО ═════
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 480)
main.Position = UDim2.new(0, 30, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 0, 100)
mainStroke.Thickness = 2
mainStroke.Parent = main

-- ═════ ЗАГОЛОВОК ═════
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 44)
topBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
topBar.BorderSizePixel = 0
topBar.Parent = main
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local topFill = Instance.new("Frame")
topFill.Size = UDim2.new(1, 0, 0, 20)
topFill.Position = UDim2.new(0, 0, 1, -20)
topFill.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
topFill.BorderSizePixel = 0
topFill.Parent = topBar

-- ═════ ЛОГОТИП ═════
if LOGO_FOUND then
    -- Картинка из папки
    local logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.new(0, 32, 0, 32)
    logoImg.Position = UDim2.new(0, 14, 0.5, -16)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = LOGO_ASSET
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.Parent = topBar
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 6)
    lc.Parent = logoImg
else
    -- Фолбэк — эмодзи
    local logoEmoji = Instance.new("TextLabel")
    logoEmoji.Size = UDim2.new(0, 40, 1, 0)
    logoEmoji.Position = UDim2.new(0, 12, 0, 0)
    logoEmoji.BackgroundTransparency = 1
    logoEmoji.Text = "🔥"
    logoEmoji.TextSize = 22
    logoEmoji.Font = Enum.Font.GothamBold
    logoEmoji.Parent = topBar
end

local titleTxt = Instance.new("TextLabel")
titleTxt.Size = UDim2.new(1, -180, 1, 0)
titleTxt.Position = UDim2.new(0, 54, 0, 0)
titleTxt.BackgroundTransparency = 1
titleTxt.Text = "АДМИНКА ВАНЬКА v2.1"
titleTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
titleTxt.TextSize = 15
titleTxt.Font = Enum.Font.GothamBold
titleTxt.TextXAlignment = Enum.TextXAlignment.Left
titleTxt.Parent = topBar

local userLbl = Instance.new("TextLabel")
userLbl.Size = UDim2.new(0, 130, 1, 0)
userLbl.Position = UDim2.new(1, -180, 0, 0)
userLbl.BackgroundTransparency = 1
userLbl.Text = "👤 " .. LP.Name
userLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
userLbl.TextSize = 12
userLbl.Font = Enum.Font.GothamMedium
userLbl.TextXAlignment = Enum.TextXAlignment.Right
userLbl.Parent = topBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -68, 0, 9)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ═════ КНОПКА ОТКРЫТИЯ ═════
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 30, 0.5, -30)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
openBtn.Text = ""
openBtn.Visible = false
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 30)
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.new(1,1,1)
openStroke.Thickness = 2
openStroke.Parent = openBtn

-- Если лого есть — ставим и в круглую кнопку
if LOGO_FOUND then
    local obImg = Instance.new("ImageLabel")
    obImg.Size = UDim2.new(0, 40, 0, 40)
    obImg.Position = UDim2.new(0.5, -20, 0.5, -20)
    obImg.BackgroundTransparency = 1
    obImg.Image = LOGO_ASSET
    obImg.ScaleType = Enum.ScaleType.Fit
    obImg.Parent = openBtn
else
    openBtn.Text = "🔥"
    openBtn.TextSize = 26
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextColor3 = Color3.new(1,1,1)
end

-- ═════ ТАБЫ ═════
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 54)
tabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

-- ═════ КОНТЕНТ ═════
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -150)
content.Position = UDim2.new(0, 10, 0, 96)
content.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
content.BorderSizePixel = 0
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

-- ═════ СТАТУС БАР ═════
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -20, 0, 34)
statusBar.Position = UDim2.new(0, 10, 1, -44)
statusBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
statusBar.BorderSizePixel = 0
statusBar.Parent = main
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 8)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(0, 12, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusTxt = Instance.new("TextLabel")
statusTxt.Size = UDim2.new(1, -40, 1, 0)
statusTxt.Position = UDim2.new(0, 30, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = (LOGO_FOUND and "✅ Логотип загружен • " or "🔥 Логотип не найден • ") .. "RightShift — скрыть"
statusTxt.TextColor3 = Color3.fromRGB(180, 180, 200)
statusTxt.TextSize = 12
statusTxt.Font = Enum.Font.GothamMedium
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.Parent = statusBar

-- ═════ УВЕДОМЛЕНИЯ ═════
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0, 320, 1, -40)
notifHolder.Position = UDim2.new(1, -340, 0, 20)
notifHolder.BackgroundTransparency = 1
notifHolder.Parent = gui

local nLayout = Instance.new("UIListLayout")
nLayout.Padding = UDim.new(0, 8)
nLayout.SortOrder = Enum.SortOrder.LayoutOrder
nLayout.Parent = notifHolder

local function notify(text, color, duration)
    color = color or Color3.fromRGB(255, 0, 100)
    duration = duration or 3
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 48)
    n.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    n.BorderSizePixel = 0
    n.Parent = notifHolder
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 2
    s.Parent = n

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = n
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = n

    n.Position = UDim2.new(1, 340, 0, 0)
    TweenService:Create(n, TweenInfo.new(0.3), { Position = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(duration, function()
        local t = TweenService:Create(n, TweenInfo.new(0.3), { Position = UDim2.new(1, 340, 0, 0) })
        t:Play()
        t.Completed:Connect(function() n:Destroy() end)
    end)
end
V.notify = notify

-- ═════ UI HELPERS ═════
local tabs, pages = {}, {}

local function switchTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, b in pairs(tabs) do
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = (n == name) and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(35, 35, 48)
        }):Play()
        b.TextColor3 = (n == name) and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 200)
    end
end

local function addTab(name, display)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 96, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    b.Text = display
    b.TextColor3 = Color3.fromRGB(180, 180, 200)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = tabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    tabs[name] = b

    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, -12, 1, -12)
    p.Position = UDim2.new(0, 6, 0, 6)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = content
    pages[name] = p

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = p
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
    end)
    b.MouseButton1Click:Connect(function() switchTab(name) end)
    return p
end

local function makeButton(parent, text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 34)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(60, 60, 75)
    s.Thickness = 1
    s.Parent = b
    local orig = color
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = orig:Lerp(Color3.new(1,1,1), 0.15) }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = orig }):Play()
    end)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback, b)
        if not ok then notify("Ошибка: " .. tostring(err), Color3.fromRGB(255,60,60)) end
    end)
    return b
end

local function makeToggle(parent, text, getState, setState)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 44, 0, 22)
    sw.Position = UDim2.new(1, -56, 0.5, -11)
    sw.BackgroundColor3 = getState() and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
    sw.Text = ""
    sw.Parent = row
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = getState() and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = sw
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    sw.MouseButton1Click:Connect(function()
        setState(not getState())
        local on = getState()
        TweenService:Create(sw, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
    end)
    return row
end

local function makeSlider(parent, text, min, max, getVal, setVal)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(getVal())
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 32)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    barBg.BorderSizePixel = 0
    barBg.Parent = row
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    local pct = (getVal() - min) / (max - min)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
        setVal(val)
    end
    barBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(i) end
    end)
    barBg.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)
    return row
end

local function makeSection(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = "▸ " .. text
    l.TextColor3 = Color3.fromRGB(255, 0, 100)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- ═════ ВКЛАДКИ ═════
local tabMain = addTab("main", "🎮 Основное")
local tabAim  = addTab("aim",  "🎯 Аим")
local tabVis  = addTab("vis",  "👁 Визуал")
local tabMisc = addTab("misc", "⚙ Прочее")
switchTab("main")

-- ═════ РОЛИ ═════
local function getRole(plr)
    if not plr.Character then return nil end
    local function hasItem(name)
        for _, c in ipairs(plr.Character:GetChildren()) do
            if c:IsA("Tool") and string.find(string.lower(c.Name), name) then return true end
        end
        if plr.Backpack then
            for _, c in ipairs(plr.Backpack:GetChildren()) do
                if c:IsA("Tool") and string.find(string.lower(c.Name), name) then return true end
            end
        end
        return false
    end
    if hasItem("knife") or hasItem("dagger") or hasItem("sword") then return "killer" end
    if hasItem("gun") or hasItem("pistol") or hasItem("revolver") then return "sheriff" end
    return "innocent"
end

local function getRoleColor(plr)
    local r = getRole(plr)
    if r == "killer"  then return Color3.fromRGB(255, 40, 40) end
    if r == "sheriff" then return Color3.fromRGB(50, 130, 255) end
    if r == "innocent" then return Color3.fromRGB(50, 220, 100) end
    return nil
end

local function refreshHighlights()
    if not S.roleHighlight then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local color = getRoleColor(plr)
            if color then
                local hl = S.highlights[plr]
                if not hl or hl.Parent ~= plr.Character then
                    if hl then hl:Destroy() end
                    hl = Instance.new("Highlight")
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillTransparency = 0.55
                    hl.OutlineTransparency = 0.1
                    hl.Parent = plr.Character
                    S.highlights[plr] = hl
                end
                hl.FillColor = color
                hl.OutlineColor = color
            end
        end
    end
end

local function clearAllHighlights()
    for _, hl in pairs(S.highlights) do pcall(function() hl:Destroy() end) end
    S.highlights = {}
end

-- ═════ FOV ═════
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Size = UDim2.new(0, S.fovRadius * 2, 0, S.fovRadius * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 0, 100)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3
fovStroke.Parent = fovCircle

-- ═════ ГЛАВНЫЙ ЦИКЛ ═════
addConn(RunService.RenderStepped:Connect(function()
    if S.aimbot and S.fovCircle then
        fovCircle.Visible = true
        fovCircle.Size = UDim2.new(0, S.fovRadius*2, 0, S.fovRadius*2)
    else
        fovCircle.Visible = false
    end

    if S.aimbot then
        local closest, dist = nil, S.fovRadius * 3
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < S.fovRadius and d < dist then dist = d; closest = plr end
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            S.aimTarget = closest
            if not S.silentAim then
                local newCF = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.35)
            end
        end
    end

    if S.autoCamper then
        if not S.camperTarget or not S.camperTarget.Parent 
           or not S.camperTarget.Character 
           or not S.camperTarget.Character:FindFirstChild("HumanoidRootPart")
           or (S.camperTarget.Character:FindFirstChildOfClass("Humanoid") 
               and S.camperTarget.Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
            S.camperTarget = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "sheriff" then
                    S.camperTarget = plr
                    notify("🎯 Шериф: " .. plr.Name, Color3.fromRGB(50, 130, 255))
                    break
                end
            end
        end
        if S.camperTarget and S.camperTarget.Character 
           and S.camperTarget.Character:FindFirstChild("HumanoidRootPart")
           and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LP.Character.HumanoidRootPart.CFrame = 
                    S.camperTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end)
        end
    end

    if S.roleHighlight then refreshHighlights() end

    if S.fly and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dir = Vector3.zero
            if UserInput:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            hrp.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.zero
        end
    end

    if S.noclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end))

-- ═════ MAIN TAB ═════
makeSection(tabMain, "Роли")
makeToggle(tabMain, "Подсветка ролей (Красный/Синий/Зелёный)",
    function() return S.roleHighlight end,
    function(v)
        S.roleHighlight = v
        if v then refreshHighlights() else clearAllHighlights() end
        notify(v and "👁 Подсветка ВКЛ" or "Подсветка ВЫКЛ",
            v and Color3.fromRGB(0,200,100) or Color3.fromRGB(150,150,150))
    end)

makeButton(tabMain, "🔄 Обновить подсветку", Color3.fromRGB(40, 80, 160), function()
    refreshHighlights()
    notify("Обновлено", Color3.fromRGB(50, 130, 255))
end)

makeSection(tabMain, "Быстрые действия")

makeButton(tabMain, "💀 Убить всех", Color3.fromRGB(170, 20, 30), function()
    local k = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then pcall(function() hum.Health = 0 end); k = k + 1 end
        end
    end
    notify("💀 Убито: " .. k, Color3.fromRGB(255, 40, 40))
end)

makeButton(tabMain, "🔪 Выдать Нож", Color3.fromRGB(120, 30, 30), function()
    if not LP.Backpack then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") then t:Destroy() end end
    local k = Instance.new("Tool"); k.Name = "Knife"; k.RequiresHandle = false; k.Parent = LP.Backpack
    notify("🔪 Нож выдан", Color3.fromRGB(255, 100, 100))
end)

makeButton(tabMain, "🔫 Выдать Пистолет", Color3.fromRGB(30, 60, 130), function()
    if not LP.Backpack then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") then t:Destroy() end end
    local g = Instance.new("Tool"); g.Name = "Gun"; g.RequiresHandle = false; g.Parent = LP.Backpack
    notify("🔫 Пистолет выдан", Color3.fromRGB(100, 150, 255))
end)

makeButton(tabMain, "🧹 Убрать предметы", Color3.fromRGB(60, 60, 60), function()
    if LP.Backpack then for _, t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") then t:Destroy() end end end
    if LP.Character then for _, t in ipairs(LP.Character:GetChildren()) do if t:IsA("Tool") then t:Destroy() end end end
    notify("🧹 Очищено", Color3.fromRGB(180, 180, 180))
end)

makeSection(tabMain, "Авто-Кампер")
makeToggle(tabMain, "Авто-Кампер (за Шерифом)",
    function() return S.autoCamper end,
    function(v)
        S.autoCamper = v
        if not v then S.camperTarget = nil end
        notify(v and "🎯 Кампер ВКЛ" or "Кампер ВЫКЛ",
            v and Color3.fromRGB(0,200,100) or Color3.fromRGB(150,150,150))
    end)

-- ═════ AIM TAB ═════
makeSection(tabAim, "Аимбот")
makeToggle(tabAim, "Аимбот",
    function() return S.aimbot end,
    function(v) S.aimbot = v; notify(v and "🎯 Аим ВКЛ" or "Аим ВЫКЛ", v and Color3.fromRGB(0,200,100) or Color3.fromRGB(150,150,150)) end)

makeToggle(tabAim, "Тихий аим",
    function() return S.silentAim end,
    function(v) S.silentAim = v end)

makeToggle(tabAim, "Круг FOV",
    function() return S.fovCircle end,
    function(v) S.fovCircle = v end)

makeSlider(tabAim, "Радиус FOV", 50, 500, function() return S.fovRadius end, function(v) S.fovRadius = v end)

makeSection(tabAim, "Стрельба")
makeToggle(tabAim, "Wallbang (ЛКМ через стены)",
    function() return S.wallbang end,
    function(v) S.wallbang = v; notify(v and "🧱 Wallbang ВКЛ" or "Wallbang ВЫКЛ", v and Color3.fromRGB(0,200,100) or Color3.fromRGB(150,150,150)) end)

makeButton(tabAim, "💥 Убить цель аима", Color3.fromRGB(170, 20, 30), function()
    if S.aimTarget and S.aimTarget.Character then
        local hum = S.aimTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0; notify("💀 " .. S.aimTarget.Name, Color3.fromRGB(255, 40, 40)) end
    else notify("Нет цели", Color3.fromRGB(180, 180, 180)) end
end)

-- ═════ VIS TAB ═════
makeSection(tabVis, "ESP")
makeToggle(tabVis, "ESP (подсветка всех)",
    function() return S.esp end,
    function(v) S.esp = v; S.roleHighlight = v; if not v then clearAllHighlights() end end)

makeButton(tabVis, "🎨 Показать всех", Color3.fromRGB(40, 80, 160), function()
    S.roleHighlight = true; refreshHighlights(); notify("Все подсвечены", Color3.fromRGB(50, 130, 255))
end)

makeButton(tabVis, "🧹 Очистить", Color3.fromRGB(120, 40, 40), function()
    clearAllHighlights(); notify("Очищено", Color3.fromRGB(180, 180, 180))
end)

-- ═════ MISC TAB ═════
makeSection(tabMisc, "Движение")
makeToggle(tabMisc, "Полёт (WASD + Space/Ctrl)",
    function() return S.fly end,
    function(v) S.fly = v; if not v and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart"); if hrp then hrp.Velocity = Vector3.zero end
    end end)

makeToggle(tabMisc, "Noclip", function() return S.noclip end, function(v) S.noclip = v end)
makeToggle(tabMisc, "Бесконечный прыжок", function() return S.infJump end, function(v) S.infJump = v end)

makeSlider(tabMisc, "Скорость", 16, 200, function() return S.speed end, function(v)
    S.speed = v
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end
end)

makeSlider(tabMisc, "Прыжок", 50, 300, function() return S.jumpPower end, function(v)
    S.jumpPower = v
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = v; h.UseJumpPower = true end end
end)

makeSection(tabMisc, "Утилиты")

makeButton(tabMisc, "🔃 Respawn", Color3.fromRGB(100, 60, 150), function()
    if LP.Character then LP.Character:BreakJoints() end
    notify("Перерождение...", Color3.fromRGB(150, 100, 255))
end)

makeButton(tabMisc, "⛔ ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180, 0, 100), function()
    S.aimbot = false; S.silentAim = false; S.wallbang = false
    S.autoCamper = false; S.camperTarget = nil
    S.roleHighlight = false; S.esp = false
    S.fly = false; S.noclip = false; S.infJump = false
    clearAllHighlights()
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16; h.JumpPower = 50 end
    end
    notify("⛔ Всё выключено", Color3.fromRGB(255, 0, 100))
end)

-- ═════ WALLBANG ═════
addConn(Mouse.Button1Down:Connect(function()
    if not S.wallbang then return end
    local target = S.aimTarget
    if not target and Mouse.Target then
        local m = Mouse.Target:FindFirstAncestorOfClass("Model")
        if m then
            local p = Players:GetPlayerFromCharacter(m)
            if p and p ~= LP then target = p end
        end
    end
    if target and target.Character then
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then pcall(function() hum:TakeDamage(200) end) end
    end
end))

-- ═════ INF JUMP ═════
addConn(UserInput.JumpRequest:Connect(function()
    if S.infJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- ═════ RESPAWN HOOK ═════
addConn(LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = S.speed; h.JumpPower = S.jumpPower; h.UseJumpPower = true end
end))

-- ═════ ХОТКЕЙ ═════
addConn(UserInput.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        openBtn.Visible = not main.Visible
    end
end))

minBtn.MouseButton1Click:Connect(function() main.Visible = false; openBtn.Visible = true end)
openBtn.MouseButton1Click:Connect(function() main.Visible = true; openBtn.Visible = false end)

closeBtn.MouseButton1Click:Connect(function()
    clearAllHighlights()
    for _, c in ipairs(V.conns) do pcall(function() c:Disconnect() end) end
    gui:Destroy()
    _G.VankaV2 = nil
end)

V.destroy = function()
    pcall(clearAllHighlights)
    for _, c in ipairs(V.conns) do pcall(function() c:Disconnect() end) end
    pcall(function() gui:Destroy() end)
    _G.VankaV2 = nil
end

-- ═════ СТАРТ ═════
notify(LOGO_FOUND and "✅ Логотип загружен!" or "⚠️ adminka.png не найден — ставлю 🔥",
    LOGO_FOUND and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(255, 180, 0), 4)
task.delay(0.7, function()
    notify("🔥 Админка Ванька v2.1 загружена!", Color3.fromRGB(255, 0, 100), 4)
end)
task.delay(1.4, function()
    notify("RightShift — скрыть/показать", Color3.fromRGB(50, 130, 255), 4)
end)

print("[VANKA v2.1] Загружено. Логотип: " .. (LOGO_FOUND and "✅" or "❌"))