-- [[ АДМИНКА ВАНЬКА v5.0 ]] --
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
    roles = false, aim = false, fov = true, fovR = 200,
    camper = false, camperT = nil, wall = false,
    fly = false, noclip = false, infjump = false,
    spin = false, spinSpeed = 30, crosshair = true,
    autoShoot = false, autoGun = false, autoDraw = false,
    gunState = "idle", gunReturnPos = nil, gunCooldown = 0,
    hl = {}, aimT = nil,
}

-- ===== ГЛАВНОЕ ОКНО =====
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 500)
main.Position = UDim2.new(0, 10, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 14)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(255, 0, 100)
ms.Thickness = 2
ms.Parent = main

-- Заголовок
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 46)
top.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
top.BorderSizePixel = 0
top.Parent = main
local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 14)
tc.Parent = top
local topFill = Instance.new("Frame")
topFill.Size = UDim2.new(1, 0, 0, 20)
topFill.Position = UDim2.new(0, 0, 1, -20)
topFill.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
topFill.BorderSizePixel = 0
topFill.Parent = top

-- Лого
if LOGO then
    local himg = Instance.new("ImageLabel")
    himg.Size = UDim2.new(0, 32, 0, 32)
    himg.Position = UDim2.new(0, 10, 0.5, -16)
    himg.BackgroundTransparency = 1
    himg.Image = LOGO
    himg.ScaleType = Enum.ScaleType.Fit
    himg.Parent = top
    local hic = Instance.new("UICorner")
    hic.CornerRadius = UDim.new(0, 8)
    hic.Parent = himg
else
    local hem = Instance.new("TextLabel")
    hem.Size = UDim2.new(0, 32, 1, 0)
    hem.Position = UDim2.new(0, 10, 0, 0)
    hem.BackgroundTransparency = 1
    hem.Text = "◆"
    hem.TextColor3 = Color3.fromRGB(255, 0, 100)
    hem.TextSize = 22
    hem.Font = Enum.Font.GothamBold
    hem.Parent = top
end

local ttl = Instance.new("TextLabel")
ttl.Size = UDim2.new(1, -130, 1, 0)
ttl.Position = UDim2.new(0, 50, 0, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "АДМИНКА ВАНЬКА"
ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
ttl.TextSize = 14
ttl.Font = Enum.Font.GothamBold
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = top

-- Индикатор статуса (пульсирующий)
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -104, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
statusDot.BorderSizePixel = 0
statusDot.Parent = top
local sdc = Instance.new("UICorner")
sdc.CornerRadius = UDim.new(1, 0)
sdc.Parent = statusDot

task.spawn(function()
    while statusDot.Parent do
        pcall(function()
            TweenService:Create(statusDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.7
            }):Play()
        end)
        task.wait(1)
        pcall(function()
            TweenService:Create(statusDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0
            }):Play()
        end)
        task.wait(1)
    end
end)

-- Свернуть
local minB = Instance.new("TextButton")
minB.Size = UDim2.new(0, 28, 0, 28)
minB.Position = UDim2.new(1, -70, 0, 9)
minB.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
minB.Text = "−"
minB.TextColor3 = Color3.new(1, 1, 1)
minB.TextSize = 18
minB.Font = Enum.Font.GothamBold
minB.Parent = top
local mbc = Instance.new("UICorner")
mbc.CornerRadius = UDim.new(0, 7)
mbc.Parent = minB

-- Закрыть
local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 28, 0, 28)
closeB.Position = UDim2.new(1, -38, 0, 9)
closeB.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
closeB.Text = "×"
closeB.TextColor3 = Color3.new(1, 1, 1)
closeB.TextSize = 18
closeB.Font = Enum.Font.GothamBold
closeB.Parent = top
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 7)
cbc.Parent = closeB

-- Кнопка открывашка
local openB = Instance.new("TextButton")
openB.Size = UDim2.new(0, 55, 0, 55)
openB.Position = UDim2.new(0, 15, 0.5, -27)
openB.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
openB.Text = "◆"
openB.TextColor3 = Color3.new(1, 1, 1)
openB.TextSize = 24
openB.Font = Enum.Font.GothamBold
openB.Visible = false
openB.Parent = gui
local obc = Instance.new("UICorner")
obc.CornerRadius = UDim.new(0, 28)
obc.Parent = openB
local obs = Instance.new("UIStroke")
obs.Color = Color3.fromRGB(255, 255, 255)
obs.Thickness = 2
obs.Parent = openB

if LOGO then
    openB.Text = ""
    local oimg = Instance.new("ImageLabel")
    oimg.Size = UDim2.new(0, 38, 0, 38)
    oimg.Position = UDim2.new(0.5, -19, 0.5, -19)
    oimg.BackgroundTransparency = 1
    oimg.Image = LOGO
    oimg.ScaleType = Enum.ScaleType.Fit
    oimg.Parent = openB
end

-- Табы
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 34)
tabBar.Position = UDim2.new(0, 8, 0, 52)
tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 8)
tbc.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -142)
content.Position = UDim2.new(0, 8, 0, 94)
content.BackgroundTransparency = 1
content.Parent = main

-- ===== ХЕЛПЕРЫ =====
local tabs, pages = {}, {}

local function addTab(key, name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 100, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(170, 170, 190)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = tabBar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
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
            btn.BackgroundColor3 = (k == key) and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(32, 32, 44)
            btn.TextColor3 = (k == key) and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 190)
        end
    end)
    return p
end

local function mkBtn(parent_, text, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 32)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.TextWrapped = true
    b.Parent = parent_
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = b
    local str = Instance.new("UIStroke")
    str.Color = color:Lerp(Color3.new(1, 1, 1), 0.35)
    str.Thickness = 1
    str.Transparency = 0.5
    str.Parent = b

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb, b)
        if not ok then warn("Vanka:", err) end
    end)
    return b
end

local function mkToggle(parent_, text, state, setter)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -6, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent_
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = row

    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -64, 1, 0)
    lb.Position = UDim2.new(0, 12, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = text
    lb.TextColor3 = Color3.fromRGB(230, 230, 240)
    lb.TextSize = 12
    lb.Font = Enum.Font.GothamMedium
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = row

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 42, 0, 20)
    sw.Position = UDim2.new(1, -52, 0.5, -10)
    sw.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
    sw.BorderSizePixel = 0
    sw.Parent = row
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = sw

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 16, 0, 16)
    kn.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    kn.BackgroundColor3 = Color3.new(1, 1, 1)
    kn.BorderSizePixel = 0
    kn.Parent = sw
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = kn

    row.MouseButton1Click:Connect(function()
        local new = not state
        setter(new)
        state = new
        TweenService:Create(sw, TweenInfo.new(0.15), {
            BackgroundColor3 = new and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
        }):Play()
        TweenService:Create(kn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = new and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end)
    return row
end

local function mkLabel(parent_, text)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, -6, 0, 24)
    wrap.BackgroundTransparency = 1
    wrap.Parent = parent_

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 0, 14)
    accent.Position = UDim2.new(0, 0, 0.5, -7)
    accent.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    accent.BorderSizePixel = 0
    accent.Parent = wrap
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(1, 0)
    ac.Parent = accent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -12, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = "◆ " .. text
    l.TextColor3 = Color3.fromRGB(255, 100, 150)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = wrap
    return wrap
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

-- ===== FLING ФУНКЦИЯ =====
local function flingPlayer(target)
    if not target or target == LP or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Захватываем сетевой контроль
    for _, part in ipairs(target.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part:SetNetworkOwner(LP) end)
        end
    end

    -- Проверяем сетевой владелец
    local owner = hrp:GetNetworkOwner()
    if owner ~= LP then
        -- Не смогли завладеть — пробуем через velocity всё равно
    end

    -- Флингаем: огромная скорость + вращение
    pcall(function()
        hrp.Velocity = Vector3.new(1e5, 1e5, 1e5)
        hrp.RotVelocity = Vector3.new(1e5, 1e5, 1e5)
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
    end)

    -- Дополнительный импульс через BodyVelocity
    task.spawn(function()
        for i = 1, 10 do
            pcall(function()
                if hrp and hrp.Parent then
                    hrp.Velocity = Vector3.new(
                        math.random(-500, 500) * 100,
                        math.random(300, 800) * 10,
                        math.random(-500, 500) * 100
                    )
                end
            end)
            task.wait(0.05)
        end
    end)
end

-- ===== FOV =====
local fovC = Instance.new("Frame")
fovC.AnchorPoint = Vector2.new(0.5, 0.5)
fovC.Size = UDim2.new(0, 400, 0, 400)
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
fcs.Transparency = 0.35
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

-- ===== ИНДИКАТОР ЦЕЛИ =====
local targetInfo = Instance.new("TextLabel")
targetInfo.Size = UDim2.new(0, 200, 0, 24)
targetInfo.Position = UDim2.new(0.5, -100, 0, 40)
targetInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
targetInfo.BackgroundTransparency = 0.3
targetInfo.Text = ""
targetInfo.TextColor3 = Color3.fromRGB(255, 100, 150)
targetInfo.TextSize = 12
targetInfo.Font = Enum.Font.GothamBold
targetInfo.Visible = false
targetInfo.Parent = gui
local tic = Instance.new("UICorner")
tic.CornerRadius = UDim.new(0, 6)
tic.Parent = targetInfo

-- ===== ТАБЫ =====
local tabMain = addTab("main", "◆ MAIN")
local tabVisual = addTab("visual", "✦ VISUAL")
local tabRage = addTab("rage", "★ RAGE")
local tabPlayers = addTab("players", "➤ ИГРОКИ")

for k, pg in pairs(pages) do pg.Visible = (k == "main") end
tabs["main"].BackgroundColor3 = Color3.fromRGB(255, 0, 100)
tabs["main"].TextColor3 = Color3.new(1, 1, 1)

-- ===== MAIN =====
mkLabel(tabMain, "РОЛИ")
mkToggle(tabMain, "Подсветка ролей (Красн/Син/Зел)", false, function(v)
    S.roles = v
    if v then refreshHL() else clearHL() end
end)
mkBtn(tabMain, "▸ Обновить подсветку", Color3.fromRGB(40, 80, 160), function() refreshHL() end)

mkLabel(tabMain, "АВТО-КАМПЕР")
mkToggle(tabMain, "Кампер за Шерифом", false, function(v)
    S.camper = v
    if not v then S.camperT = nil end
end)
mkBtn(tabMain, "▸ Найти Шерифа", Color3.fromRGB(80, 60, 130), function()
    S.camperT = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and getRole(plr) == "s" then S.camperT = plr; break end
    end
end)

mkLabel(tabMain, "АВТО-ПИСТОЛЕТ")
mkToggle(tabMain, "Авто-подбор пистолета", false, function(v)
    S.autoGun = v
    if not v then S.gunState = "idle"; S.gunReturnPos = nil end
end)
mkToggle(tabMain, "Авто-достать пистолет при аиме", false, function(v) S.autoDraw = v end)

mkLabel(tabMain, "ДЕЙСТВИЯ")
mkBtn(tabMain, "▸ Убить всех", Color3.fromRGB(170, 20, 30), function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then pcall(function() h.Health = 0 end) end
        end
    end
end)
mkBtn(tabMain, "▸ Очистить инвентарь", Color3.fromRGB(60, 60, 70), function()
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

-- ===== VISUAL =====
mkLabel(tabVisual, "ПРИЦЕЛ")
mkToggle(tabVisual, "Показывать прицел", true, function(v)
    S.crosshair = v
    crossH.Visible = v; crossV.Visible = v; crossDot.Visible = v
end)

mkLabel(tabVisual, "FOV")
mkToggle(tabVisual, "Показывать FOV", true, function(v) S.fov = v end)
mkBtn(tabVisual, "▸ FOV +20", Color3.fromRGB(60, 60, 90), function() S.fovR = math.min(S.fovR + 20, 600) end)
mkBtn(tabVisual, "▸ FOV -20", Color3.fromRGB(60, 60, 90), function() S.fovR = math.max(S.fovR - 20, 40) end)

mkLabel(tabVisual, "ДВИЖЕНИЕ")
mkToggle(tabVisual, "Полёт (WASD + Space/Ctrl)", false, function(v) S.fly = v end)
mkToggle(tabVisual, "Noclip (сквозь стены)", false, function(v) S.noclip = v end)
mkToggle(tabVisual, "Бесконечный прыжок", false, function(v) S.infjump = v end)
mkBtn(tabVisual, "▸ Скорость 16", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 16 end end
end)
mkBtn(tabVisual, "▸ Скорость 50", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 50 end end
end)
mkBtn(tabVisual, "▸ Скорость 100", Color3.fromRGB(60, 60, 90), function()
    if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 100 end end
end)

-- ===== RAGE =====
mkLabel(tabRage, "АИМ (ТОЛЬКО МАРДЕР)")
mkToggle(tabRage, "Аимбот на Мардера", false, function(v) S.aim = v end)
mkToggle(tabRage, "Стрельба через стены", false, function(v) S.wall = v end)
mkToggle(tabRage, "Авто-стрельба в Мардера", false, function(v) S.autoShoot = v end)
mkBtn(tabRage, "▸ Убить цель аима", Color3.fromRGB(170, 20, 30), function()
    if S.aimT and S.aimT.Character then
        local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

mkLabel(tabRage, "СПИНБОТ")
mkToggle(tabRage, "Спинбот", false, function(v) S.spin = v end)
mkBtn(tabRage, "▸ Скорость 30", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 30; b.Text = "▸ Скорость 30" end)
mkBtn(tabRage, "▸ Скорость 60", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 60; b.Text = "▸ Скорость 60" end)
mkBtn(tabRage, "▸ Скорость 120", Color3.fromRGB(60, 60, 90), function(b) S.spinSpeed = 120; b.Text = "▸ Скорость 120" end)

mkLabel(tabRage, "УТИЛИТЫ")
mkBtn(tabRage, "▸ Respawn", Color3.fromRGB(100, 60, 150), function()
    if LP.Character then LP.Character:BreakJoints() end
end)
mkBtn(tabRage, "▸ ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180, 0, 100), function()
    S.aim = false; S.wall = false; S.camper = false; S.camperT = nil
    S.roles = false; S.fly = false; S.noclip = false; S.infjump = false
    S.spin = false; S.autoShoot = false; S.autoGun = false; S.autoDraw = false
    S.gunState = "idle"
    clearHL()
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16; h.JumpPower = 50 end
    end
end)

-- ===== PLAYERS (ФЛИНГ СПИСОК) =====
mkLabel(tabPlayers, "СПИСОК ИГРОКОВ И ФЛИНГ")
mkBtn(tabPlayers, "▸ Обновить список", Color3.fromRGB(60, 60, 120), function() end)

local playersList = Instance.new("Frame")
playersList.Size = UDim2.new(1, -6, 0, 340)
playersList.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
playersList.BorderSizePixel = 0
playersList.Parent = tabPlayers
local plc = Instance.new("UICorner")
plc.CornerRadius = UDim.new(0, 8)
plc.Parent = playersList
local pls = Instance.new("UIStroke")
pls.Color = Color3.fromRGB(50, 50, 70)
pls.Thickness = 1
pls.Parent = playersList

local plScroll = Instance.new("ScrollingFrame")
plScroll.Size = UDim2.new(1, -10, 1, -10)
plScroll.Position = UDim2.new(0, 5, 0, 5)
plScroll.BackgroundTransparency = 1
plScroll.BorderSizePixel = 0
plScroll.ScrollBarThickness = 4
plScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.Parent = playersList

local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 5)
plLayout.Parent = plScroll
plLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    plScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 8)
end)

local playerRows = {}
local function rebuildPlayerList()
    for _, r in pairs(playerRows) do r:Destroy() end
    playerRows = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -4, 0, 42)
            row.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
            row.BorderSizePixel = 0
            row.Parent = plScroll
            local rc = Instance.new("UICorner")
            rc.CornerRadius = UDim.new(0, 6)
            rc.Parent = row

            local av = Instance.new("ImageLabel")
            av.Size = UDim2.new(0, 32, 0, 32)
            av.Position = UDim2.new(0, 5, 0.5, -16)
            av.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            av.BorderSizePixel = 0
            av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
            av.Parent = row
            local avc = Instance.new("UICorner")
            avc.CornerRadius = UDim.new(0, 16)
            avc.Parent = av

            -- Роль
            local roleTag = Instance.new("Frame")
            roleTag.Size = UDim2.new(0, 6, 0, 26)
            roleTag.Position = UDim2.new(0, 41, 0.5, -13)
            roleTag.BackgroundColor3 = roleColor(plr) or Color3.fromRGB(100, 100, 100)
            roleTag.BorderSizePixel = 0
            roleTag.Parent = row
            local rtc = Instance.new("UICorner")
            rtc.CornerRadius = UDim.new(1, 0)
            rtc.Parent = roleTag

            local nm = Instance.new("TextLabel")
            nm.Size = UDim2.new(1, -170, 1, 0)
            nm.Position = UDim2.new(0, 54, 0, 0)
            nm.BackgroundTransparency = 1
            nm.Text = plr.Name
            nm.TextColor3 = Color3.fromRGB(230, 230, 240)
            nm.TextSize = 11
            nm.Font = Enum.Font.GothamMedium
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.TextTruncate = Enum.TextTruncate.AtEnd
            nm.Parent = row

            -- ТП
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 34, 0, 26)
            tpBtn.Position = UDim2.new(1, -116, 0.5, -13)
            tpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
            tpBtn.Text = "ТП"
            tpBtn.TextColor3 = Color3.new(1, 1, 1)
            tpBtn.TextSize = 10
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.Parent = row
            local tbc2 = Instance.new("UICorner")
            tbc2.CornerRadius = UDim.new(0, 5)
            tbc2.Parent = tpBtn
            tpBtn.MouseButton1Click:Connect(function()
                if plr.Character and LP.Character then
                    local t = plr.Character:FindFirstChild("HumanoidRootPart")
                    local m = LP.Character:FindFirstChild("HumanoidRootPart")
                    if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0, 0, 4) end) end
                end
            end)

            -- ФЛИНГ
            local flBtn = Instance.new("TextButton")
            flBtn.Size = UDim2.new(0, 60, 0, 26)
            flBtn.Position = UDim2.new(1, -78, 0.5, -13)
            flBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 100)
            flBtn.Text = "ФЛИНГ"
            flBtn.TextColor3 = Color3.new(1, 1, 1)
            flBtn.TextSize = 10
            flBtn.Font = Enum.Font.GothamBold
            flBtn.Parent = row
            local fbc = Instance.new("UICorner")
            fbc.CornerRadius = UDim.new(0, 5)
            fbc.Parent = flBtn
            flBtn.MouseButton1Click:Connect(function()
                pcall(function() flingPlayer(plr) end)
            end)

            playerRows[plr] = row
        end
    end
end

Players.PlayerAdded:Connect(function() task.wait(1) rebuildPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.3) rebuildPlayerList() end)

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

local function isGun(tool)
    if not tool or not tool.Name then return false end
    local nm = string.lower(tool.Name)
    return string.find(nm, "gun") or string.find(nm, "pistol") or string.find(nm, "revolver")
end

local function hasGunInHand()
    local char = LP.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and isGun(tool)
end

local function equipGunFromBackpack()
    if not LP.Backpack or not LP.Character then return false end
    local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and isGun(t) then
            pcall(function() humanoid:EquipTool(t) end)
            return true
        end
    end
    return false
end

-- ===== ГЛАВНЫЙ ЦИКЛ =====
local conn = RunService.RenderStepped:Connect(function(dt)
    -- FOV
    if S.aim and S.fov then
        fovC.Visible = true
        fovC.Size = UDim2.new(0, S.fovR * 2, 0, S.fovR * 2)
    else
        fovC.Visible = false
    end

    -- AIM — только Мардер
    if S.aim then
        local closest, dist = nil, S.fovR * 3
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                -- Проверяем что цель — убийца
                if getRole(plr) == "k" then
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
        end

        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            S.aimT = closest
            local target = CFrame.new(Cam.CFrame.Position, closest.Character.Head.Position)
            Cam.CFrame = Cam.CFrame:Lerp(target, 0.35)

            -- Индикатор цели
            targetInfo.Visible = true
            targetInfo.Text = "◆ ЦЕЛЬ: " .. closest.Name .. " [МАРДЕР]"
        else
            S.aimT = nil
            targetInfo.Visible = false
        end
    else
        targetInfo.Visible = false
    end

    -- AUTO DRAW — достать пушку если есть цель и авто-достать включено
    if S.autoDraw and S.aimT and S.aimT.Character then
        if not hasGunInHand() then
            equipGunFromBackpack()
        end
    end

    -- AUTO SHOOT — стрельба в Мардера
    if S.autoShoot and S.aimT and S.aimT.Character then
        local target = S.aimT
        -- Проверяем что цель ещё мардер
        if getRole(target) == "k" then
            -- Проверяем: цель за стеной или нет
            local head = target.Character:FindFirstChild("Head")
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            local wallBetween = false

            if head and LP.Character then
                local origin = Cam.CFrame.Position
                local dir = (head.Position - origin)
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {LP.Character, target.Character}
                rayParams.IgnoreWater = true
                local result = workspace:Raycast(origin, dir, rayParams)
                if result then
                    -- Что-то между нами и целью
                    wallBetween = true
                end
            end

            -- Если авто-достать включено — сначала достаём
            if S.autoDraw and not hasGunInHand() then
                equipGunFromBackpack()
            end

            -- Стреляем только если есть пушка в руках
            if hasGunInHand() then
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function() tool:Activate() end)
                end
            end

            -- Если цель за стеной и включён wallbang — урон напрямую
            if wallBetween and S.wall then
                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    pcall(function() humanoid:TakeDamage(35) end)
                end
            end
        end
    end

    -- SPIN
    if S.spin and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed * dt * 60), 0)
        end
    end

    -- AUTO GUN pickup
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

    -- CAMPER
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

    -- FLY
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

    -- NOCLIP
    if S.noclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end
end)

-- ===== WALLBANG (по клику) =====
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

rebuildPlayerList()

-- ===== ЗАГРУЗОЧНЫЙ ЭКРАН (ДЛИННЫЙ) =====
task.spawn(function()
    local loadF = Instance.new("Frame")
    loadF.Size = UDim2.new(1, 0, 1, 0)
    loadF.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
    loadF.BorderSizePixel = 0
    loadF.ZIndex = 500
    loadF.Parent = gui

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0, 160, 0, 160)
        li.Position = UDim2.new(0.5, -80, 0.5, -150)
        li.BackgroundTransparency = 1
        li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit
        li.ZIndex = 501
        li.ImageTransparency = 1
        li.Parent = loadF
        TweenService:Create(li, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    end

    local lt = Instance.new("TextLabel")
    lt.Size = UDim2.new(1, 0, 0, 36)
    lt.Position = UDim2.new(0, 0, 0.5, 30)
    lt.BackgroundTransparency = 1
    lt.Text = "◆ АДМИНКА ВАНЬКА ◆"
    lt.TextColor3 = Color3.fromRGB(255, 255, 255)
    lt.TextSize = 26
    lt.Font = Enum.Font.GothamBold
    lt.TextTransparency = 1
    lt.ZIndex = 501
    lt.Parent = loadF
    TweenService:Create(lt, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local ls = Instance.new("TextLabel")
    ls.Size = UDim2.new(1, 0, 0, 22)
    ls.Position = UDim2.new(0, 0, 0.5, 70)
    ls.BackgroundTransparency = 1
    ls.Text = "Загрузка скрипта: 0%"
    ls.TextColor3 = Color3.fromRGB(180, 180, 210)
    ls.TextSize = 15
    ls.Font = Enum.Font.GothamMedium
    ls.TextTransparency = 1
    ls.ZIndex = 501
    ls.Parent = loadF
    TweenService:Create(ls, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0.5, 95)
    sub.BackgroundTransparency = 1
    sub.Text = "Инициализация..."
    sub.TextColor3 = Color3.fromRGB(120, 120, 150)
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.TextTransparency = 1
    sub.ZIndex = 501
    sub.Parent = loadF
    TweenService:Create(sub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local bb = Instance.new("Frame")
    bb.Size = UDim2.new(0, 320, 0, 10)
    bb.Position = UDim2.new(0.5, -160, 0.5, 130)
    bb.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
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

    local pctLbl = Instance.new("TextLabel")
    pctLbl.Size = UDim2.new(1, 0, 0, 20)
    pctLbl.Position = UDim2.new(0, 0, 0.5, 150)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = Color3.fromRGB(255, 0, 100)
    pctLbl.TextSize = 13
    pctLbl.Font = Enum.Font.GothamBold
    pctLbl.TextTransparency = 1
    pctLbl.ZIndex = 501
    pctLbl.Parent = loadF
    TweenService:Create(pctLbl, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

    local stages = {
        {p=5,  t="Инициализация...",         delay=0.5},
        {p=12, t="Загрузка логотипа...",     delay=0.4},
        {p=22, t="Подключение к серверу...", delay=0.5},
        {p=32, t="Загрузка модулей...",      delay=0.4},
        {p=45, t="Настройка интерфейса...",  delay=0.5},
        {p=58, t="Проверка обновлений...",   delay=0.4},
        {p=70, t="Загрузка функций...",      delay=0.5},
        {p=82, t="Синхронизация...",         delay=0.4},
        {p=92, t="Финальная настройка...",   delay=0.4},
        {p=100,t="Готово!",                  delay=0.6},
    }

    for _, st in ipairs(stages) do
        ls.Text = "Загрузка скрипта: " .. st.p .. "%"
        sub.Text = st.t
        pctLbl.Text = st.p .. "%"
        local tw = TweenService:Create(bf, TweenInfo.new(st.delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(st.p / 100, 0, 1, 0)
        })
        tw:Play()
        task.wait(st.delay)
    end

    task.wait(0.4)

    -- Плавное исчезновение
    TweenService:Create(loadF, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    for _, c in ipairs(loadF:GetDescendants()) do
        if c:IsA("TextLabel") then
            pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {TextTransparency = 1}):Play() end)
        elseif c:IsA("ImageLabel") then
            pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {ImageTransparency = 1}):Play() end)
        elseif c:IsA("Frame") then
            pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play() end)
        end
    end
    task.wait(0.7)
    loadF:Destroy()
end)

print("[VANKA v5.0] Загружено. Лого: " .. (LOGO and "OK" or "NO"))
