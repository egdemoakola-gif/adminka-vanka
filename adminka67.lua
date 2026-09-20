-- [[ АДМИНКА ВАНЬКА v3.1 - Bulletproof ]] --
if _G.VankaKill then pcall(_G.VankaKill) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ===== ЛОГОТИП =====
local LOGO_URL = "https://raw.githubusercontent.com/egdemoakola-gif/adminka-vanka/main/vanya.png"
local LOGO_FILE = "vanka_logo.png"
local LOGO = nil

pcall(function()
    if isfile and getcustomasset then
        if isfile(LOGO_FILE) then
            local ok, a = pcall(getcustomasset, LOGO_FILE)
            if ok and a and a ~= "" then LOGO = a; return end
        end
    end
    if writefile and getcustomasset then
        local ok, data = pcall(function() return game:HttpGet(LOGO_URL, true) end)
        if ok and data and #data > 100 then
            pcall(writefile, LOGO_FILE, data)
            local ok2, a = pcall(getcustomasset, LOGO_FILE)
            if ok2 and a and a ~= "" then LOGO = a end
        end
    end
end)

-- ===== GUI =====
local parent = (gethui and gethui()) or game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "VankaAdmin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

-- ===== СОСТОЯНИЕ =====
local S = {
    roles = false, aim = false, fov = true, fovR = 180,
    camper = false, camperT = nil, wall = false,
    fly = false, noclip = false, infjump = false,
    spin = false, spinSpeed = 30, crosshair = true,
    autoShoot = false, autoGun = false,
    gunState = "idle", gunReturnPos = nil, gunCooldown = 0,
    hl = {}, aimT = nil,
}

-- ===== ОСНОВНОЕ ОКНО (СРАЗУ ВИДНОЕ) =====
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 450)
main.Position = UDim2.new(0, 10, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 12)
mc.Parent = main
local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(255, 0, 100)
ms.Thickness = 2
ms.Parent = main

-- Заголовок
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 42)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
top.BorderSizePixel = 0
top.Parent = main
local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 12)
tc.Parent = top
local topFill = Instance.new("Frame")
topFill.Size = UDim2.new(1, 0, 0, 18)
topFill.Position = UDim2.new(0, 0, 1, -18)
topFill.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
topFill.BorderSizePixel = 0
topFill.Parent = top

if LOGO then
    local himg = Instance.new("ImageLabel")
    himg.Size = UDim2.new(0, 30, 0, 30)
    himg.Position = UDim2.new(0, 8, 0.5, -15)
    himg.BackgroundTransparency = 1
    himg.Image = LOGO
    himg.ScaleType = Enum.ScaleType.Fit
    himg.Parent = top
    local hic = Instance.new("UICorner")
    hic.CornerRadius = UDim.new(0, 6)
    hic.Parent = himg
else
    local hem = Instance.new("TextLabel")
    hem.Size = UDim2.new(0, 30, 1, 0)
    hem.Position = UDim2.new(0, 8, 0, 0)
    hem.BackgroundTransparency = 1
    hem.Text = "🔥"
    hem.TextSize = 20
    hem.Font = Enum.Font.GothamBold
    hem.Parent = top
end

local ttl = Instance.new("TextLabel")
ttl.Size = UDim2.new(1, -120, 1, 0)
ttl.Position = UDim2.new(0, 46, 0, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "АДМИНКА ВАНЬКА v3.1"
ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
ttl.TextSize = 13
ttl.Font = Enum.Font.GothamBold
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = top

local minB = Instance.new("TextButton")
minB.Size = UDim2.new(0, 26, 0, 26)
minB.Position = UDim2.new(1, -64, 0, 8)
minB.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
minB.Text = "—"
minB.TextColor3 = Color3.new(1,1,1)
minB.TextSize = 16
minB.Font = Enum.Font.GothamBold
minB.Parent = top
local mbc = Instance.new("UICorner")
mbc.CornerRadius = UDim.new(0, 6)
mbc.Parent = minB

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 26, 0, 26)
closeB.Position = UDim2.new(1, -34, 0, 8)
closeB.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
closeB.Text = "×"
closeB.TextColor3 = Color3.new(1,1,1)
closeB.TextSize = 18
closeB.Font = Enum.Font.GothamBold
closeB.Parent = top
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = closeB

-- Кнопка открывашка
local openB = Instance.new("TextButton")
openB.Size = UDim2.new(0, 55, 0, 55)
openB.Position = UDim2.new(0, 15, 0.5, -27)
openB.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
openB.Text = ""
openB.Visible = false
openB.Parent = gui
local obc = Instance.new("UICorner")
obc.CornerRadius = UDim.new(0, 28)
obc.Parent = openB

if LOGO then
    local oimg = Instance.new("ImageLabel")
    oimg.Size = UDim2.new(0, 36, 0, 36)
    oimg.Position = UDim2.new(0.5, -18, 0.5, -18)
    oimg.BackgroundTransparency = 1
    oimg.Image = LOGO
    oimg.ScaleType = Enum.ScaleType.Fit
    oimg.Parent = openB
else
    openB.Text = "🔥"
    openB.TextSize = 24
    openB.Font = Enum.Font.GothamBold
    openB.TextColor3 = Color3.new(1,1,1)
end

-- Табы
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 32)
tabBar.Position = UDim2.new(0, 8, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 7)
tbc.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -130)
content.Position = UDim2.new(0, 8, 0, 88)
content.BackgroundTransparency = 1
content.Parent = main

-- ===== ХЕЛПЕРЫ =====
local tabs, pages = {}, {}

local function addTab(key, name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 96, 0, 24)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(180, 180, 200)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = tabBar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = b
    tabs[key] = b

    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = content
    pages[key] = p

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 5)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = p
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
    end)

    b.MouseButton1Click:Connect(function()
        for k, pg in pairs(pages) do pg.Visible = (k == key) end
        for k, btn in pairs(tabs) do
            btn.BackgroundColor3 = (k == key) and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(35, 35, 48)
            btn.TextColor3 = (k == key) and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 200)
        end
    end)
    return p
end

local function mkBtn(parent_, text, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 32)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.TextWrapped = true
    b.Parent = parent_
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb, b)
        if not ok then warn("Vanka:", err) end
    end)
    return b
end

local function mkToggle(parent_, text, state, setter)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -6, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent_
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = row

    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -60, 1, 0)
    lb.Position = UDim2.new(0, 10, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = text
    lb.TextColor3 = Color3.fromRGB(230, 230, 240)
    lb.TextSize = 12
    lb.Font = Enum.Font.GothamMedium
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = row

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 38, 0, 18)
    sw.Position = UDim2.new(1, -46, 0.5, -9)
    sw.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
    sw.BorderSizePixel = 0
    sw.Parent = row
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = sw

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    kn.BackgroundColor3 = Color3.new(1,1,1)
    kn.BorderSizePixel = 0
    kn.Parent = sw
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = kn

    row.MouseButton1Click:Connect(function()
        local new = not state
        setter(new)
        state = new
        sw.BackgroundColor3 = new and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
        kn.Position = new and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end)
    return row
end

local function mkLabel(parent_, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = "▸ " .. text
    l.TextColor3 = Color3.fromRGB(255, 0, 100)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent_
    return l
end

-- ===== РОЛИ =====
local function getRole(plr)
    if not plr.Character then return nil end
    local function has(nm)
        for _, c in ipairs(plr.Character:GetChildren()) do
            if c:IsA("Tool") and string.find(string.lower(c.Name), nm) then return true end
        end
        if plr.Backpack then
            for _, c in ipairs(plr.Backpack:GetChildren()) do
                if c:IsA("Tool") and string.find(string.lower(c.Name), nm) then return true end
            end
        end
        return false
    end
    if has("knife") or has("dagger") or has("sword") then return "k" end
    if has("gun") or has("pistol") or has("revolver") then return "s" end
    return "i"
end

local function roleColor(plr)
    local r = getRole(plr)
    if r == "k" then return Color3.fromRGB(255, 40, 40) end
    if r == "s" then return Color3.fromRGB(50, 130, 255) end
    if r == "i" then return Color3.fromRGB(50, 220, 100) end
    return nil
end

local function refreshHL()
    if not S.roles then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local color = roleColor(plr)
            if color then
                local hl = S.hl[plr]
                if not hl or hl.Parent ~= plr.Character then
                    if hl then hl:Destroy() end
                    hl = Instance.new("Highlight")
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillTransparency = 0.55
                    hl.OutlineTransparency = 0.1
                    hl.Parent = plr.Character
                    S.hl[plr] = hl
                end
                hl.FillColor = color
                hl.OutlineColor = color
            end
        end
    end
end

local function clearHL()
    for _, hl in pairs(S.hl) do
        pcall(function() hl:Destroy() end)
    end
    S.hl = {}
end

-- ===== FOV =====
local fovC = Instance.new("Frame")
fovC.AnchorPoint = Vector2.new(0.5, 0.5)
fovC.Size = UDim2.new(0, 360, 0, 360)
fovC.Position = UDim2.new(0.5, 0, 0.5, 0)
fovC.BackgroundTransparency = 1
fovC.Visible = false
fovC.Parent = gui
local fcc = Instance.new("UICorner")
fcc.CornerRadius = UDim.new(1, 0)
fcc.Parent = fovC
local fcs = Instance.new("UIStroke")
fcs.Color = Color3.fromRGB(255, 0, 100)
fcs.Thickness = 1.5
fcs.Transparency = 0.3
fcs.Parent = fovC

-- ===== ПРИЦЕЛ =====
local crossH = Instance.new("Frame")
crossH.Size = UDim2.new(0, 16, 0, 2)
crossH.Position = UDim2.new(0.5, -8, 0.5, -1)
crossH.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
crossH.BorderSizePixel = 0
crossH.Parent = gui
local crossV = Instance.new("Frame")
crossV.Size = UDim2.new(0, 2, 0, 16)
crossV.Position = UDim2.new(0.5, -1, 0.5, -8)
crossV.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
crossV.BorderSizePixel = 0
crossV.Parent = gui
local crossDot = Instance.new("Frame")
crossDot.Size = UDim2.new(0, 4, 0, 4)
crossDot.Position = UDim2.new(0.5, -2, 0.5, -2)
crossDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crossDot.BorderSizePixel = 0
crossDot.Parent = gui
local cdc = Instance.new("UICorner")
cdc.CornerRadius = UDim.new(1, 0)
cdc.Parent = crossDot

-- ===== ТАБЫ =====
local tabMain = addTab("main", "🎮 Main")
local tabVisual = addTab("visual", "👁 Visual")
local tabRage = addTab("rage", "⚡ Rage")

for k, pg in pairs(pages) do pg.Visible = (k == "main") end
tabs["main"].BackgroundColor3 = Color3.fromRGB(255, 0, 100)
tabs["main"].TextColor3 = Color3.new(1,1,1)

-- MAIN
mkLabel(tabMain, "РОЛИ")
mkToggle(tabMain, "Подсветка ролей", false, function(v)
    S.roles = v
    if v then refreshHL() else clearHL() end
end)
mkBtn(tabMain, "🔄 Обновить подсветку", Color3.fromRGB(40, 80, 160), function() refreshHL() end)

mkLabel(tabMain, "АВТО-КАМПЕР")
mkToggle(tabMain, "Кампер (за Шерифом)", false, function(v)
    S.camper = v
    if not v then S.camperT = nil end
end)
mkBtn(tabMain, "🔄 Найти Шерифа", Color3.fromRGB(80, 60, 130), function()
    S.camperT = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and getRole(plr) == "s" then S.camperT = plr; break end
    end
end)

mkLabel(tabMain, "АВТО-ПИСТОЛЕТ")
mkToggle(tabMain, "Авто-подбор Пистолета", false, function(v)
    S.autoGun = v
    if not v then S.gunState = "idle"; S.gunReturnPos = nil end
end)

mkLabel(tabMain, "ДЕЙСТВИЯ")
mkBtn(tabMain, "💀 Убить всех", Color3.fromRGB(170, 20, 30), function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then pcall(function() h.Health = 0 end) end
        end
    end
end)
mkBtn(tabMain, "🧹 Очистить инвентарь", Color3.fromRGB(60, 60, 60), function()
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") then t:Destroy() end
        end
    end
    if LP.Character then
        for _, t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") then t:Destroy() end
        end
    end
end)

mkLabel(tabMain, "ИГРОКИ")
local playersList = Instance.new("Frame")
playersList.Size = UDim2.new(1, -6, 0, 180)
playersList.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
playersList.BorderSizePixel = 0
playersList.Parent = tabMain
local plc = Instance.new("UICorner")
plc.CornerRadius = UDim.new(0, 6)
plc.Parent = playersList

local plScroll = Instance.new("ScrollingFrame")
plScroll.Size = UDim2.new(1, -8, 1, -8)
plScroll.Position = UDim2.new(0, 4, 0, 4)
plScroll.BackgroundTransparency = 1
plScroll.BorderSizePixel = 0
plScroll.ScrollBarThickness = 3
plScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.Parent = playersList

local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 4)
plLayout.Parent = plScroll
plLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    plScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 8)
end)

local playerRows = {}
local function rebuildPlayerList()
    for _, r in pairs(playerRows) do r:Destroy() end
    playerRows = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        row.BorderSizePixel = 0
        row.Parent = plScroll
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 5)
        rc.Parent = row

        local av = Instance.new("ImageLabel")
        av.Size = UDim2.new(0, 28, 0, 28)
        av.Position = UDim2.new(0, 4, 0.5, -14)
        av.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        av.BorderSizePixel = 0
        av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
        av.Parent = row
        local avc = Instance.new("UICorner")
        avc.CornerRadius = UDim.new(0, 14)
        avc.Parent = av

        local nm = Instance.new("TextLabel")
        nm.Size = UDim2.new(1, -110, 1, 0)
        nm.Position = UDim2.new(0, 38, 0, 0)
        nm.BackgroundTransparency = 1
        nm.Text = plr.Name
        nm.TextColor3 = Color3.fromRGB(230, 230, 240)
        nm.TextSize = 12
        nm.Font = Enum.Font.GothamMedium
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.Parent = row

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 50, 0, 26)
        tpBtn.Position = UDim2.new(1, -56, 0.5, -13)
        tpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
        tpBtn.Text = "ТП"
        tpBtn.TextColor3 = Color3.new(1,1,1)
        tpBtn.TextSize = 11
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.Parent = row
        local tbc2 = Instance.new("UICorner")
        tbc2.CornerRadius = UDim.new(0, 5)
        tbc2.Parent = tpBtn
        tpBtn.MouseButton1Click:Connect(function()
            if plr ~= LP and plr.Character and LP.Character then
                local t = plr.Character:FindFirstChild("HumanoidRootPart")
                local m = LP.Character:FindFirstChild("HumanoidRootPart")
                if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0, 0, 4) end) end
            end
        end)
        playerRows[plr] = row
    end
end

Players.PlayerAdded:Connect(function() task.wait(1) rebuildPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.3) rebuildPlayerList() end)

-- VISUAL
mkLabel(tabVisual, "ПРИЦЕЛ")
mkToggle(tabVisual, "Показывать прицел", true, function(v)
    S.crosshair = v
    crossH.Visible = v; crossV.Visible = v; crossDot.Visible = v
end)

mkLabel(tabVisual, "FOV")
mkToggle(tabVisual, "Показывать FOV", true, function(v) S.fov = v end)
mkBtn(tabVisual, "➕ FOV +20", Color3.fromRGB(60, 60, 90), function() S.fovR = math.min(S.fovR + 20, 500) end)
mkBtn(tabVisual, "➖ FOV -20", Color3.fromRGB(60, 60, 90), function() S.fovR = math.max(S.fovR - 20, 40) end)

mkLabel(tabVisual, "ДВИЖЕНИЕ")
mkToggle(tabVisual, "Полёт", false, function(v) S.fly = v end)
mkToggle(tabVisual, "Noclip", false, function(v) S.noclip = v end)
mkToggle(tabVisual, "Беск. прыжок", false, function(v) S.infjump = v end)
mkBtn(tabVisual, "⚡ Скорость 16", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 16 end end
end)
mkBtn(tabVisual, "⚡ Скорость 50", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 50 end end
end)
mkBtn(tabVisual, "⚡ Скорость 100", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 100 end end
end)

-- RAGE
mkLabel(tabRage, "АИМ")
mkToggle(tabRage, "Аимбот", false, function(v) S.aim = v end)
mkToggle(tabRage, "Стрельба через стены", false, function(v) S.wall = v end)
mkBtn(tabRage, "💥 Убить цель аима", Color3.fromRGB(170, 20, 30), function()
    if S.aimT and S.aimT.Character then
        local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

mkLabel(tabRage, "АВТО-СТРЕЛЬБА")
mkToggle(tabRage, "Авто-стрельба в Мардера", false, function(v) S.autoShoot = v end)

mkLabel(tabRage, "СПИНБОТ")
mkToggle(tabRage, "🌀 Спинбот", false, function(v) S.spin = v end)
mkBtn(tabRage, "🌀 Скорость 30", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 30; b.Text = "🌀 Скорость 30" end)
mkBtn(tabRage, "🌀 Скорость 60", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 60; b.Text = "🌀 Скорость 60" end)
mkBtn(tabRage, "🌀 Скорость 120", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 120; b.Text = "🌀 Скорость 120" end)

mkLabel(tabRage, "УТИЛИТЫ")
mkBtn(tabRage, "🔃 Respawn", Color3.fromRGB(100, 60, 150), function()
    if LP.Character then LP.Character:BreakJoints() end
end)
mkBtn(tabRage, "⛔ ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180, 0, 100), function()
    S.aim = false; S.wall = false; S.camper = false; S.camperT = nil
    S.roles = false; S.fly = false; S.noclip = false; S.infjump = false
    S.spin = false; S.autoShoot = false; S.autoGun = false
    S.gunState = "idle"
    clearHL()
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16; h.JumpPower = 50 end
    end
end)

-- ===== АВТО-ПИСТОЛЕТ =====
local function findDroppedGun()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local inUse = false
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character and obj:IsDescendantOf(plr.Character) then inUse = true; break end
                if plr.Backpack and obj:IsDescendantOf(plr.Backpack) then inUse = true; break end
            end
            if not inUse then
                local nm = string.lower(obj.Name)
                if string.find(nm, "gun") or string.find(nm, "pistol") or string.find(nm, "revolver") then
                    return obj
                end
            end
        end
    end
    return nil
end

-- ===== ГЛАВНЫЙ ЦИКЛ =====
local conn = RunService.RenderStepped:Connect(function(dt)
    if not S.crosshair then
        crossH.Visible = false; crossV.Visible = false; crossDot.Visible = false
    end

    if S.aim and S.fov then
        fovC.Visible = true
        fovC.Size = UDim2.new(0, S.fovR * 2, 0, S.fovR * 2)
    else
        fovC.Visible = false
    end

    if S.aim then
        local closest, dist = nil, S.fovR * 3
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local sp, onScreen = Cam:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local cx = Cam.ViewportSize.X / 2
                        local cy = Cam.ViewportSize.Y / 2
                        local d = math.sqrt((sp.X - cx) ^ 2 + (sp.Y - cy) ^ 2)
                        if d < S.fovR and d < dist then dist = d; closest = plr end
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            S.aimT = closest
            local target = CFrame.new(Cam.CFrame.Position, closest.Character.Head.Position)
            Cam.CFrame = Cam.CFrame:Lerp(target, 0.35)
        end
    end

    if S.autoShoot and S.aimT and S.aimT.Character then
        if getRole(S.aimT) == "k" then
            local char = LP.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
        end
    end

    if S.spin and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed * dt * 60), 0)
        end
    end

    if S.autoGun then
        S.gunCooldown = S.gunCooldown - dt
        if S.gunState == "idle" then
            local gun = findDroppedGun()
            if gun and LP.Character then
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    S.gunReturnPos = hrp.CFrame
                    local gunPos
                    if gun:IsA("Tool") and gun:FindFirstChild("Handle") then
                        gunPos = gun.Handle.Position
                    elseif gun:IsA("BasePart") then
                        gunPos = gun.Position
                    else
                        local p = gun:FindFirstChildWhichIsA("BasePart")
                        gunPos = p and p.Position
                    end
                    if gunPos then
                        hrp.CFrame = CFrame.new(gunPos + Vector3.new(0, 2, 0))
                        S.gunState = "pickup"
                        S.gunCooldown = 0.6
                    end
                end
            end
        elseif S.gunState == "pickup" and S.gunCooldown <= 0 then
            if S.gunReturnPos and LP.Character then
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then pcall(function() hrp.CFrame = S.gunReturnPos end) end
            end
            S.gunState = "idle"
            S.gunReturnPos = nil
            S.gunCooldown = 0.5
        end
    end

    if S.camper then
        local valid = S.camperT and S.camperT.Parent and S.camperT.Character
        if valid then
            local h = S.camperT.Character:FindFirstChildOfClass("Humanoid")
            if not h or h.Health <= 0 then valid = false end
        end
        if not valid then
            S.camperT = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "s" then
                    S.camperT = plr; break
                end
            end
        end
        if S.camperT and S.camperT.Character then
            local t = S.camperT.Character:FindFirstChild("HumanoidRootPart")
            local m = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0, 0, 3) end) end
        end
    end

    if S.roles then refreshHL() end

    if S.fly and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then hrp.Velocity = dir.Unit * 60 else hrp.Velocity = Vector3.new(0, 0, 0) end
        end
    end

    if S.noclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end)

-- ===== WALLBANG =====
local wbConn = Mouse.Button1Down:Connect(function()
    if not S.wall then return end
    local target = S.aimT
    if not target and Mouse.Target then
        local m = Mouse.Target:FindFirstAncestorOfClass("Model")
        if m then
            local p = Players:GetPlayerFromCharacter(m)
            if p and p ~= LP then target = p end
        end
    end
    if target and target.Character then
        local h = target.Character:FindFirstChildOfClass("Humanoid")
        if h and h.Health > 0 then pcall(function() h:TakeDamage(200) end) end
    end
end)

-- ===== INF JUMP =====
local ijConn = UIS.JumpRequest:Connect(function()
    if S.infjump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ===== ЗАКРЫТИЕ =====
local function cleanup()
    pcall(clearHL)
    pcall(function() conn:Disconnect() end)
    pcall(function() wbConn:Disconnect() end)
    pcall(function() ijConn:Disconnect() end)
    pcall(function() gui:Destroy() end)
    _G.VankaKill = nil
end
_G.VankaKill = cleanup

minB.MouseButton1Click:Connect(function()
    main.Visible = false
    openB.Visible = true
end)
openB.MouseButton1Click:Connect(function()
    main.Visible = true
    openB.Visible = false
end)
closeB.MouseButton1Click:Connect(cleanup)

-- ===== ЗАГРУЗКА (ОТДЕЛЬНО, ПОВЕРХ, САМА УБИРАЕТСЯ) =====
task.spawn(function()
    local ok = pcall(function()
        local loadF = Instance.new("Frame")
        loadF.Size = UDim2.new(1, 0, 1, 0)
        loadF.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
        loadF.BorderSizePixel = 0
        loadF.ZIndex = 500
        loadF.Parent = gui

        if LOGO then
            local li = Instance.new("ImageLabel")
            li.Size = UDim2.new(0, 140, 0, 140)
            li.Position = UDim2.new(0.5, -70, 0.5, -120)
            li.BackgroundTransparency = 1
            li.Image = LOGO
            li.ScaleType = Enum.ScaleType.Fit
            li.ZIndex = 501
            li.Parent = loadF
        end

        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1, 0, 0, 30)
        lt.Position = UDim2.new(0, 0, 0.5, 20)
        lt.BackgroundTransparency = 1
        lt.Text = "АДМИНКА ВАНЬКА"
        lt.TextColor3 = Color3.fromRGB(255, 255, 255)
        lt.TextSize = 22
        lt.Font = Enum.Font.GothamBold
        lt.ZIndex = 501
        lt.Parent = loadF

        local ls = Instance.new("TextLabel")
        ls.Size = UDim2.new(1, 0, 0, 20)
        ls.Position = UDim2.new(0, 0, 0.5, 55)
        ls.BackgroundTransparency = 1
        ls.Text = "Загрузка: 0%"
        ls.TextColor3 = Color3.fromRGB(180, 180, 200)
        ls.TextSize = 14
        ls.Font = Enum.Font.GothamMedium
        ls.ZIndex = 501
        ls.Parent = loadF

        local bb = Instance.new("Frame")
        bb.Size = UDim2.new(0, 280, 0, 8)
        bb.Position = UDim2.new(0.5, -140, 0.5, 85)
        bb.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        bb.BorderSizePixel = 0
        bb.ZIndex = 501
        bb.Parent = loadF
        local bbc = Instance.new("UICorner")
        bbc.CornerRadius = UDim.new(1, 0)
        bbc.Parent = bb

        local bf = Instance.new("Frame")
        bf.Size = UDim2.new(0, 0, 1, 0)
        bf.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        bf.BorderSizePixel = 0
        bf.ZIndex = 502
        bf.Parent = bb
        local bfc = Instance.new("UICorner")
        bfc.CornerRadius = UDim.new(1, 0)
        bfc.Parent = bf

        for i = 1, 20 do
            ls.Text = "Загрузка: " .. (i * 5) .. "%"
            bf.Size = UDim2.new(i / 20, 0, 1, 0)
            task.wait(0.08)
        end
        task.wait(0.2)
        loadF:Destroy()
    end)
    -- Если что-то пошло не так — всё равно убираем через 3 сек
end)

-- ===== СТАРТ =====
rebuildPlayerList()
print("[VANKA v3.1] Загружено! Лого: " .. (LOGO and "OK" or "NO"))
