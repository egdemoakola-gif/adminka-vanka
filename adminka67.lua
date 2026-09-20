-- ══════════════════════════════════════════════════════════════════
--  ◆ АДМИНКА ВАНЬКА v7.0 FINAL ◆
--  Полная версия со ВСЕМИ функциями
--  Для Delta / Fluxus / Codex (mobile + PC)
--  Автор: Ванёк
-- ══════════════════════════════════════════════════════════════════

-- ═══════════════════ 1. ЗАЩИТА ОТ ПОВТОРНОГО ЗАПУСКА ═══════════════
if _G.VankaPanel and _G.VankaPanel.Destroy then
    pcall(_G.VankaPanel.Destroy)
end

-- ═══════════════════ 2. СЕРВИСЫ ═══════════════════
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")

local LP     = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse  = LP:GetMouse()

-- ═══════════════════ 3. ЗАГРУЗКА ЛОГОТИПА С GITHUB ═══════════════════
local LOGO_URL  = "https://raw.githubusercontent.com/egdemoakola-gif/adminka-vanka/main/vanya.png"
local LOGO_FILE = "vanka_logo.png"
local LOGO      = nil

pcall(function()
    -- Проверка уже скачанного
    if isfile and getcustomasset then
        if isfile(LOGO_FILE) then
            local ok, asset = pcall(getcustomasset, LOGO_FILE)
            if ok and asset and asset ~= "" then
                LOGO = asset
                return
            end
        end
    end
    -- Скачивание с GitHub
    if writefile and getcustomasset then
        local ok, data = pcall(function()
            return game:HttpGet(LOGO_URL, true)
        end)
        if ok and data and #data > 100 then
            pcall(writefile, LOGO_FILE, data)
            local ok2, asset = pcall(getcustomasset, LOGO_FILE)
            if ok2 and asset and asset ~= "" then
                LOGO = asset
            end
        end
    end
end)

-- ═══════════════════ 4. ГЛОБАЛЬНОЕ СОСТОЯНИЕ ═══════════════════
local State = {
    -- ESP
    espEnabled = false,
    -- Роли
    roleHighlight = false,
    roleHighlights = {},
    -- Аим
    aimbotEnabled = false,
    aimbotFOV = 200,
    aimbotTarget = nil,
    -- Авто-стрельба
    autoShootEnabled = false,
    -- Авто-пистолет
    autoGunEnabled = false,
    gunESPEnabled = false,
    gunHighlight = nil,
    autoDrawEnabled = false,
    gunState = "idle",
    gunReturnPos = nil,
    gunCooldown = 0,
    -- Кампер
    camperEnabled = false,
    camperTarget = nil,
    -- Wallbang
    wallbangEnabled = false,
    -- Спинбот
    spinEnabled = false,
    spinSpeed = 30,
    -- Движение
    flyEnabled = false,
    noclipEnabled = false,
    infiniteJumpEnabled = false,
    -- Прицел
    crosshairEnabled = true,
    fovCircleEnabled = true,
    -- Соединения
    connections = {},
    -- GUI
    gui = nil,
    -- Fullbright
    fullbrightEnabled = false,
    oldLighting = nil,
}

-- ═══════════════════ 5. УТИЛИТЫ ═══════════════════

-- Уведомления
local function notify(text, color)
    color = color or Color3.fromRGB(255, 0, 100)
    if not State.gui then return end
    local holder = State.gui:FindFirstChild("NotifHolder")
    if not holder then return end

    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 46)
    n.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    n.BorderSizePixel = 0
    n.Parent = holder

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = n

    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 2
    s.Parent = n

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = n
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = bar

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = n

    n.Position = UDim2.new(1, 320, 0, 0)
    TweenService:Create(n, TweenInfo.new(0.3), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(3, function()
        local t = TweenService:Create(n, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 320, 0, 0)
        })
        t:Play()
        t.Completed:Connect(function() n:Destroy() end)
    end)
end

-- Определение роли игрока
local function getPlayerRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local char = plr.Character
    local backpack = plr.Backpack

    local function hasToolWithName(namePart)
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and string.find(string.lower(t.Name), namePart) then
                return true
            end
        end
        if backpack then
            for _, t in ipairs(backpack:GetChildren()) do
                if t:IsA("Tool") and string.find(string.lower(t.Name), namePart) then
                    return true
                end
            end
        end
        return false
    end

    if hasToolWithName("knife") or hasToolWithName("dagger") or hasToolWithName("sword") then
        return "Murderer"
    end
    if hasToolWithName("gun") or hasToolWithName("pistol") or hasToolWithName("revolver") then
        return "Sheriff"
    end
    return "Innocent"
end

-- Цвет роли
local function getRoleColor(plr)
    local role = getPlayerRole(plr)
    if role == "Murderer" then
        return Color3.fromRGB(255, 60, 60)
    elseif role == "Sheriff" then
        return Color3.fromRGB(60, 150, 255)
    else
        return Color3.fromRGB(60, 220, 100)
    end
end

-- Проверка что это пистолет
local function isGun(tool)
    if not tool or not tool.Name then return false end
    local nm = string.lower(tool.Name)
    return string.find(nm, "gun") or string.find(nm, "pistol") or string.find(nm, "revolver")
end

-- Проверка что это нож
local function isKnife(tool)
    if not tool or not tool.Name then return false end
    local nm = string.lower(tool.Name)
    return string.find(nm, "knife") or string.find(nm, "dagger") or string.find(nm, "sword")
end

-- Пистолет в руках?
local function hasGunInHand()
    local char = LP.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and isGun(tool)
end

-- Экипировать пистолет из рюкзака
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

-- Поиск упавшего пистолета
local function findDroppedGun()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and isGun(obj) then
            local inUse = false
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character and obj:IsDescendantOf(plr.Character) then
                    inUse = true
                    break
                end
                if plr.Backpack and obj:IsDescendantOf(plr.Backpack) then
                    inUse = true
                    break
                end
            end
            if not inUse then
                return obj
            end
        end
    end
    return nil
end

-- ═══════════════════ 6. ESP / ПОДСВЕТКА РОЛЕЙ ═══════════════════

local function refreshRoleHighlights()
    if not State.roleHighlight then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local color = getRoleColor(plr)
            local hl = State.roleHighlights[plr]
            if not hl or hl.Parent ~= plr.Character then
                if hl then hl:Destroy() end
                hl = Instance.new("Highlight")
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.55
                hl.OutlineTransparency = 0.1
                hl.Parent = plr.Character
                State.roleHighlights[plr] = hl
            end
            hl.FillColor = color
            hl.OutlineColor = color
        end
    end
end

local function clearRoleHighlights()
    for _, hl in pairs(State.roleHighlights) do
        pcall(function() hl:Destroy() end)
    end
    State.roleHighlights = {}
end

-- ═══════════════════ 7. FLING ═══════════════════

local function flingPlayer(target)
    if not target or target == LP or not target.Character then
        notify("◆ Нет цели для флинга", Color3.fromRGB(255, 60, 60))
        return
    end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not myHrp then return end

    notify("◆ Флингаю " .. target.Name .. "...", Color3.fromRGB(255, 100, 200))

    local myPos = myHrp.CFrame

    -- Захват сетевого контроля
    for _, part in ipairs(target.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part:SetNetworkOwner(LP) end)
        end
    end

    -- Быстрый ТП вокруг жертвы
    task.spawn(function()
        local baseCF = hrp.CFrame
        local offsets = {
            CFrame.new(0, 0, 3),
            CFrame.new(0, 0, -3),
            CFrame.new(3, 0, 0),
            CFrame.new(-3, 0, 0),
            CFrame.new(0, 2, 3),
            CFrame.new(0, 2, -3),
            CFrame.new(0, 4, 0),
        }
        for i = 1, 25 do
            local off = offsets[math.random(1, #offsets)]
            pcall(function()
                myHrp.CFrame = baseCF * off
            end)
            task.wait()
        end

        -- Мощный импульс жертве
        for i = 1, 15 do
            pcall(function()
                hrp.Velocity = Vector3.new(
                    math.random(-800, 800) * 10,
                    math.random(500, 1000) * 10,
                    math.random(-800, 800) * 10
                )
                hrp.RotVelocity = Vector3.new(
                    math.random(-500, 500),
                    math.random(-500, 500),
                    math.random(-500, 500)
                )
            end)
            task.wait(0.02)
        end

        -- Возврат на место
        task.wait(0.3)
        pcall(function()
            if myHrp and myHrp.Parent then
                myHrp.CFrame = myPos
            end
        end)

        -- Проверка космоса
        task.wait(1.5)
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local y = target.Character.HumanoidRootPart.Position.Y
            if y > 500 then
                notify("◆ " .. target.Name .. " УЛЕТЕЛ В КОСМОС!", Color3.fromRGB(255, 100, 200))
            else
                notify("◆ " .. target.Name .. " отфлингован", Color3.fromRGB(100, 200, 255))
            end
        end
    end)
end

-- ═══════════════════ 8. САХАРОК (KILL ALL через сервер) ═══════════════════

local cachedRemotes = {}

local function findKillRemotes()
    if #cachedRemotes > 0 then return cachedRemotes end
    local keywords = {"kill", "damage", "hit", "attack", "stab", "knife", "sword", "die", "health", "murder"}
    local found = {}

    -- Ищем в ReplicatedStorage
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local nm = string.lower(obj.Name)
            for _, kw in ipairs(keywords) do
                if string.find(nm, kw) then
                    table.insert(found, obj)
                    break
                end
            end
        end
    end

    -- Ищем в ноже игрока
    if LP.Character then
        local knife = LP.Character:FindFirstChild("Knife")
        if not knife and LP.Backpack then
            knife = LP.Backpack:FindFirstChild("Knife")
        end
        if knife then
            for _, obj in ipairs(knife:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(found, obj)
                end
            end
        end
    end

    -- Убираем дубликаты
    local seen = {}
    local unique = {}
    for _, r in ipairs(found) do
        if not seen[r] then
            seen[r] = true
            table.insert(unique, r)
        end
    end

    cachedRemotes = unique
    return cachedRemotes
end

local function activateSugarok()
    local remotes = findKillRemotes()
    if #remotes == 0 then
        notify("◆ Не найдено ремоутов для убийства", Color3.fromRGB(255, 60, 60))
        return
    end

    notify("◆ Найдено ремоутов: " .. #remotes, Color3.fromRGB(255, 200, 0))

    local myChar = LP.Character
    if not myChar then return end
    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Достаём нож
    local knife = myChar:FindFirstChild("Knife")
    if not knife and LP.Backpack then
        knife = LP.Backpack:FindFirstChild("Knife")
        if knife then
            pcall(function() humanoid:EquipTool(knife) end)
            task.wait(0.1)
        end
    end

    -- Взмах
    if knife then
        pcall(function() knife:Activate() end)
    end

    -- Отправляем всем ремоутам
    local fired = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health > 0 then
                for _, remote in ipairs(remotes) do
                    pcall(function() remote:FireServer(plr.Character) end)
                    pcall(function() remote:FireServer(plr.Character.HumanoidRootPart) end)
                    pcall(function() remote:FireServer(plr) end)
                    pcall(function() remote:FireServer(targetHum) end)
                    pcall(function() remote:FireServer(plr.Name) end)
                    fired = fired + 5
                end
            end
        end
    end

    task.wait(0.3)

    local killed = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health <= 0 then killed = killed + 1 end
        end
    end

    notify("◆ САХАРОК! Отправлено: " .. fired .. " | Убито: " .. killed, Color3.fromRGB(200, 0, 150))
end

-- ═══════════════════ 9. GUI - СОЗДАНИЕ ПАНЕЛИ ═══════════════════

local function createGUI()
    local parent = (gethui and gethui()) or game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "VankaAdminPanel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent
    State.gui = gui

    -- Уведомления (контейнер)
    local notifHolder = Instance.new("Frame")
    notifHolder.Name = "NotifHolder"
    notifHolder.Size = UDim2.new(0, 300, 1, -40)
    notifHolder.Position = UDim2.new(1, -320, 0, 20)
    notifHolder.BackgroundTransparency = 1
    notifHolder.Parent = gui

    local nLay = Instance.new("UIListLayout")
    nLay.Padding = UDim.new(0, 8)
    nLay.SortOrder = Enum.SortOrder.LayoutOrder
    nLay.Parent = notifHolder

    -- Главное окно
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 380, 0, 500)
    main.Position = UDim2.new(0, 15, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 14)
    mc.Parent = main

    local mstk = Instance.new("UIStroke")
    mstk.Color = Color3.fromRGB(255, 0, 100)
    mstk.Thickness = 2
    mstk.Parent = main

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

    -- Логотип
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

    -- Название
    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -130, 1, 0)
    ttl.Position = UDim2.new(0, 50, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = "АДМИНКА ВАНЬКА v7.0"
    ttl.TextColor3 = Color3.new(1, 1, 1)
    ttl.TextSize = 14
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = top

    -- Пульсирующая точка
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(1, -100, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
    dot.BorderSizePixel = 0
    dot.Parent = top
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = dot

    task.spawn(function()
        while dot.Parent do
            pcall(function()
                TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = 0.7
                }):Play()
            end)
            task.wait(1)
            pcall(function()
                TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    BackgroundTransparency = 0
                }):Play()
            end)
            task.wait(1)
        end
    end)

    -- Свернуть
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -70, 0, 9)
    minBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.TextSize = 18
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = top
    local mbc = Instance.new("UICorner")
    mbc.CornerRadius = UDim.new(0, 7)
    mbc.Parent = minBtn

    -- Закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0, 9)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = top
    local cbc = Instance.new("UICorner")
    cbc.CornerRadius = UDim.new(0, 7)
    cbc.Parent = closeBtn

    -- Кнопка открывашка
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.new(0, 55, 0, 55)
    openBtn.Position = UDim2.new(0, 15, 0.5, -27)
    openBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    openBtn.Text = "◆"
    openBtn.TextColor3 = Color3.new(1, 1, 1)
    openBtn.TextSize = 24
    openBtn.Font = Enum.Font.GothamBold
    openBtn.Visible = false
    openBtn.Parent = gui
    local obc = Instance.new("UICorner")
    obc.CornerRadius = UDim.new(0, 28)
    obc.Parent = openBtn
    local obs = Instance.new("UIStroke")
    obs.Color = Color3.new(1, 1, 1)
    obs.Thickness = 2
    obs.Parent = openBtn

    if LOGO then
        openBtn.Text = ""
        local oimg = Instance.new("ImageLabel")
        oimg.Size = UDim2.new(0, 38, 0, 38)
        oimg.Position = UDim2.new(0.5, -19, 0.5, -19)
        oimg.BackgroundTransparency = 1
        oimg.Image = LOGO
        oimg.ScaleType = Enum.ScaleType.Fit
        oimg.Parent = openBtn
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

    local tabLay = Instance.new("UIListLayout")
    tabLay.FillDirection = Enum.FillDirection.Horizontal
    tabLay.Padding = UDim.new(0, 4)
    tabLay.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent = tabBar

    -- Контент
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -142)
    content.Position = UDim2.new(0, 8, 0, 94)
    content.BackgroundTransparency = 1
    content.Parent = main

    -- ===== UI HELPERS =====
    local tabs = {}
    local pages = {}

    local function switchTab(name)
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(32, 32, 44)
            b.TextColor3 = (k == name) and Color3.new(1, 1, 1) or Color3.fromRGB(170, 170, 190)
        end
    end

    local function addTab(key, name)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 84, 0, 26)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        b.Text = name
        b.TextColor3 = Color3.fromRGB(170, 170, 190)
        b.TextSize = 10
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

        b.MouseButton1Click:Connect(function() switchTab(key) end)
        return p
    end

    local function addBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -6, 0, 32)
        b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 12
        b.Font = Enum.Font.GothamMedium
        b.TextWrapped = true
        b.Parent = parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 7)
        c.Parent = b
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then
                warn("Vanka Error:", err)
                notify("◆ Ошибка: " .. tostring(err), Color3.fromRGB(255, 60, 60))
            end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -6, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 7)
        c.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -64, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0, 42, 0, 20)
        sw.Position = UDim2.new(1, -52, 0.5, -10)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
        sw.BorderSizePixel = 0
        sw.Parent = row
        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(1, 0)
        sc.Parent = sw

        local kn = Instance.new("Frame")
        kn.Size = UDim2.new(0, 16, 0, 16)
        kn.Position = initial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        kn.BackgroundColor3 = Color3.new(1, 1, 1)
        kn.BorderSizePixel = 0
        kn.Parent = sw
        local kc = Instance.new("UICorner")
        kc.CornerRadius = UDim.new(1, 0)
        kc.Parent = kn

        local state = initial
        row.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(sw, TweenInfo.new(0.15), {
                BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
            }):Play()
            TweenService:Create(kn, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            cb(state)
        end)
        return row
    end

    local function addLabel(parent, text)
        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -6, 0, 24)
        wrap.BackgroundTransparency = 1
        wrap.Parent = parent

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

    -- ===== ВКЛАДКИ =====
    local tabMain    = addTab("main",    "◆ MAIN")
    local tabVisual  = addTab("visual",  "✦ VISUAL")
    local tabRage    = addTab("rage",    "★ RAGE")
    local tabPlayers = addTab("players", "➤ ИГРОКИ")

    switchTab("main")

    -- ═════ MAIN ═════
    addLabel(tabMain, "РОЛИ И ESP")
    addToggle(tabMain, "Подсветка ролей (К/С/З)", false, function(v)
        State.roleHighlight = v
        State.espEnabled = v
        if v then
            refreshRoleHighlights()
        else
            clearRoleHighlights()
        end
    end)
    addBtn(tabMain, "▸ Обновить подсветку", Color3.fromRGB(40, 80, 160), function()
        refreshRoleHighlights()
    end)

    addLabel(tabMain, "АВТО-КАМПЕР")
    addToggle(tabMain, "Кампер за Шерифом", false, function(v)
        State.camperEnabled = v
        if not v then State.camperTarget = nil end
    end)
    addBtn(tabMain, "▸ Найти Шерифа", Color3.fromRGB(80, 60, 130), function()
        State.camperTarget = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and getPlayerRole(plr) == "Sheriff" then
                State.camperTarget = plr
                notify("◆ Шериф: " .. plr.Name, Color3.fromRGB(60, 150, 255))
                break
            end
        end
    end)

    addLabel(tabMain, "АВТО-ПИСТОЛЕТ")
    addToggle(tabMain, "Авто-подбор пистолета", false, function(v)
        State.autoGunEnabled = v
        if not v then
            State.gunState = "idle"
            State.gunReturnPos = nil
        end
    end)
    addToggle(tabMain, "ESP для пистолета (жёлтый)", false, function(v)
        State.gunESPEnabled = v
        if not v and State.gunHighlight then
            pcall(function() State.gunHighlight:Destroy() end)
            State.gunHighlight = nil
        end
    end)
    addToggle(tabMain, "Авто-достать пистолет при аиме", false, function(v)
        State.autoDrawEnabled = v
    end)

    addLabel(tabMain, "ДЕЙСТВИЯ")
    addBtn(tabMain, "▸ Убить всех (локально)", Color3.fromRGB(170, 20, 30), function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    pcall(function() h.Health = 0 end)
                end
            end
        end
        notify("◆ Убито всех локально", Color3.fromRGB(255, 60, 60))
    end)
    addBtn(tabMain, "▸ Очистить инвентарь", Color3.fromRGB(60, 60, 70), function()
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

    -- ═════ VISUAL ═════
    addLabel(tabVisual, "ПРИЦЕЛ")
    addToggle(tabVisual, "Показывать прицел", true, function(v)
        State.crosshairEnabled = v
    end)

    addLabel(tabVisual, "FOV")
    addToggle(tabVisual, "Показывать FOV", true, function(v)
        State.fovCircleEnabled = v
    end)
    addBtn(tabVisual, "▸ FOV +20", Color3.fromRGB(60, 60, 90), function()
        State.aimbotFOV = math.min(State.aimbotFOV + 20, 600)
        notify("◆ FOV: " .. State.aimbotFOV, Color3.fromRGB(100, 200, 255))
    end)
    addBtn(tabVisual, "▸ FOV -20", Color3.fromRGB(60, 60, 90), function()
        State.aimbotFOV = math.max(State.aimbotFOV - 20, 40)
        notify("◆ FOV: " .. State.aimbotFOV, Color3.fromRGB(100, 200, 255))
    end)

    addLabel(tabVisual, "ДВИЖЕНИЕ")
    addToggle(tabVisual, "Полёт (WASD + Space)", false, function(v) State.flyEnabled = v end)
    addToggle(tabVisual, "Noclip (сквозь стены)", false, function(v) State.noclipEnabled = v end)
    addToggle(tabVisual, "Беск. прыжок", false, function(v) State.infiniteJumpEnabled = v end)
    addBtn(tabVisual, "▸ Скорость 16", Color3.fromRGB(60, 60, 90), function()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 16 end
        end
    end)
    addBtn(tabVisual, "▸ Скорость 50", Color3.fromRGB(60, 60, 90), function()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 50 end
        end
    end)
    addBtn(tabVisual, "▸ Скорость 100", Color3.fromRGB(60, 60, 90), function()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 100 end
        end
    end)

    addLabel(tabVisual, "ВИЗУАЛ")
    addToggle(tabVisual, "Fullbright (светло)", false, function(v)
        State.fullbrightEnabled = v
        if v then
            if not State.oldLighting then
                State.oldLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                }
            end
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        else
            if State.oldLighting then
                Lighting.Brightness = State.oldLighting.Brightness
                Lighting.ClockTime = State.oldLighting.ClockTime
                Lighting.Ambient = State.oldLighting.Ambient
                Lighting.OutdoorAmbient = State.oldLighting.OutdoorAmbient
                State.oldLighting = nil
            end
        end
    end)

    -- ═════ RAGE ═════
    addLabel(tabRage, "★ САХАРОК")
    addBtn(tabRage, "★ САХАРОК (все здохли)", Color3.fromRGB(200, 0, 150), function()
        activateSugarok()
    end)

    addLabel(tabRage, "АИМ (только Мардер)")
    addToggle(tabRage, "Аимбот на Мардера", false, function(v)
        State.aimbotEnabled = v
    end)
    addToggle(tabRage, "Стрельба через стены", false, function(v)
        State.wallbangEnabled = v
    end)
    addToggle(tabRage, "Авто-стрельба в Мардера", false, function(v)
        State.autoShootEnabled = v
    end)
    addBtn(tabRage, "▸ Убить цель аима", Color3.fromRGB(170, 20, 30), function()
        if State.aimbotTarget and State.aimbotTarget.Character then
            local h = State.aimbotTarget.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end)

    addLabel(tabRage, "СПИНБОТ")
    addToggle(tabRage, "Спинбот", false, function(v) State.spinEnabled = v end)
    addBtn(tabRage, "▸ Скорость 30", Color3.fromRGB(60, 60, 90), function(b)
        State.spinSpeed = 30
        b.Text = "▸ Скорость 30"
    end)
    addBtn(tabRage, "▸ Скорость 60", Color3.fromRGB(60, 60, 90), function(b)
        State.spinSpeed = 60
        b.Text = "▸ Скорость 60"
    end)
    addBtn(tabRage, "▸ Скорость 120", Color3.fromRGB(60, 60, 90), function(b)
        State.spinSpeed = 120
        b.Text = "▸ Скорость 120"
    end)

    addLabel(tabRage, "УТИЛИТЫ")
    addBtn(tabRage, "▸ Respawn", Color3.fromRGB(100, 60, 150), function()
        if LP.Character then LP.Character:BreakJoints() end
    end)
    addBtn(tabRage, "▸ ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180, 0, 100), function()
        State.aimbotEnabled = false
        State.wallbangEnabled = false
        State.camperEnabled = false
        State.camperTarget = nil
        State.roleHighlight = false
        State.espEnabled = false
        State.flyEnabled = false
        State.noclipEnabled = false
        State.infiniteJumpEnabled = false
        State.spinEnabled = false
        State.autoShootEnabled = false
        State.autoGunEnabled = false
        State.autoDrawEnabled = false
        State.gunESPEnabled = false
        State.gunState = "idle"
        clearRoleHighlights()
        if State.gunHighlight then
            pcall(function() State.gunHighlight:Destroy() end)
            State.gunHighlight = nil
        end
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h.WalkSpeed = 16
                h.JumpPower = 50
            end
        end
        notify("◆ Всё выключено", Color3.fromRGB(255, 60, 60))
    end)

    -- ═════ PLAYERS ═════
    addLabel(tabPlayers, "СПИСОК ИГРОКОВ")

    local pList = Instance.new("Frame")
    pList.Size = UDim2.new(1, -6, 0, 340)
    pList.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    pList.BorderSizePixel = 0
    pList.Parent = tabPlayers
    local plc = Instance.new("UICorner")
    plc.CornerRadius = UDim.new(0, 8)
    plc.Parent = pList

    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1, -10, 1, -10)
    pScroll.Position = UDim2.new(0, 5, 0, 5)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 4
    pScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
    pScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    pScroll.Parent = pList

    local pLay = Instance.new("UIListLayout")
    pLay.Padding = UDim.new(0, 5)
    pLay.Parent = pScroll
    pLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pScroll.CanvasSize = UDim2.new(0, 0, 0, pLay.AbsoluteContentSize.Y + 8)
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
                row.Parent = pScroll
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

                -- Цветной индикатор роли
                local tag = Instance.new("Frame")
                tag.Size = UDim2.new(0, 6, 0, 26)
                tag.Position = UDim2.new(0, 41, 0.5, -13)
                tag.BackgroundColor3 = getRoleColor(plr)
                tag.BorderSizePixel = 0
                tag.Parent = row
                local tgc = Instance.new("UICorner")
                tgc.CornerRadius = UDim.new(1, 0)
                tgc.Parent = tag

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

                -- Кнопка ТП
                local tpB = Instance.new("TextButton")
                tpB.Size = UDim2.new(0, 34, 0, 26)
                tpB.Position = UDim2.new(1, -118, 0.5, -13)
                tpB.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
                tpB.Text = "ТП"
                tpB.TextColor3 = Color3.new(1, 1, 1)
                tpB.TextSize = 10
                tpB.Font = Enum.Font.GothamBold
                tpB.Parent = row
                local tbc2 = Instance.new("UICorner")
                tbc2.CornerRadius = UDim.new(0, 5)
                tbc2.Parent = tpB
                tpB.MouseButton1Click:Connect(function()
                    if plr.Character and LP.Character then
                        local t = plr.Character:FindFirstChild("HumanoidRootPart")
                        local m = LP.Character:FindFirstChild("HumanoidRootPart")
                        if t and m then
                            pcall(function() m.CFrame = t.CFrame * CFrame.new(0, 0, 4) end)
                        end
                    end
                end)

                -- Кнопка ФЛИНГ
                local flB = Instance.new("TextButton")
                flB.Size = UDim2.new(0, 60, 0, 26)
                flB.Position = UDim2.new(1, -80, 0.5, -13)
                flB.BackgroundColor3 = Color3.fromRGB(180, 20, 100)
                flB.Text = "ФЛИНГ"
                flB.TextColor3 = Color3.new(1, 1, 1)
                flB.TextSize = 10
                flB.Font = Enum.Font.GothamBold
                flB.Parent = row
                local fbc = Instance.new("UICorner")
                fbc.CornerRadius = UDim.new(0, 5)
                fbc.Parent = flB
                flB.MouseButton1Click:Connect(function()
                    flingPlayer(plr)
                end)

                playerRows[plr] = row
            end
        end
    end

    rebuildPlayerList()
    Players.PlayerAdded:Connect(function()
        task.wait(1)
        rebuildPlayerList()
    end)
    Players.PlayerRemoving:Connect(function()
        task.wait(0.3)
        rebuildPlayerList()
    end)

    -- Свернуть/Открыть
    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        openBtn.Visible = true
    end)
    openBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        openBtn.Visible = false
    end)

    return gui
end

-- ═══════════════════ 10. ПРИЦЕЛ ═══════════════════
local function createCrosshair()
    local h = Instance.new("Frame")
    h.Size = UDim2.new(0, 16, 0, 2)
    h.Position = UDim2.new(0.5, -8, 0.5, -1)
    h.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    h.BorderSizePixel = 0
    h.Parent = State.gui

    local v = Instance.new("Frame")
    v.Size = UDim2.new(0, 2, 0, 16)
    v.Position = UDim2.new(0.5, -1, 0.5, -8)
    v.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    v.BorderSizePixel = 0
    v.Parent = State.gui

    local d = Instance.new("Frame")
    d.Size = UDim2.new(0, 4, 0, 4)
    d.Position = UDim2.new(0.5, -2, 0.5, -2)
    d.BackgroundColor3 = Color3.new(1, 1, 1)
    d.BorderSizePixel = 0
    d.Parent = State.gui
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = d

    return h, v, d
end

-- ═══════════════════ 11. FOV КРУГ ═══════════════════
local function createFovCircle()
    local fov = Instance.new("Frame")
    fov.AnchorPoint = Vector2.new(0.5, 0.5)
    fov.Size = UDim2.new(0, 400, 0, 400)
    fov.Position = UDim2.new(0.5, 0, 0.5, 0)
    fov.BackgroundTransparency = 1
    fov.Visible = false
    fov.Parent = State.gui
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = fov
    local fs = Instance.new("UIStroke")
    fs.Color = Color3.fromRGB(255, 0, 100)
    fs.Thickness = 1.5
    fs.Transparency = 0.35
    fs.Parent = fov
    return fov
end

-- ═══════════════════ 12. ИНДИКАТОР ЦЕЛИ ═══════════════════
local function createTargetInfo()
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0, 240, 0, 24)
    t.Position = UDim2.new(0.5, -120, 0, 40)
    t.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    t.BackgroundTransparency = 0.3
    t.Text = ""
    t.TextColor3 = Color3.fromRGB(255, 100, 150)
    t.TextSize = 12
    t.Font = Enum.Font.GothamBold
    t.Visible = false
    t.Parent = State.gui
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = t
    return t
end

-- ═══════════════════ 13. ОСНОВНОЙ ЦИКЛ ═══════════════════
local function startMainLoop()
    local crossH, crossV, crossDot
    local fovCircle
    local targetInfo

    if State.gui then
        crossH, crossV, crossDot = createCrosshair()
        fovCircle = createFovCircle()
        targetInfo = createTargetInfo()
    end

    local conn = RunService.RenderStepped:Connect(function(dt)
        -- ПРИЦЕЛ
        if crossH and crossV and crossDot then
            local show = State.crosshairEnabled
            crossH.Visible = show
            crossV.Visible = show
            crossDot.Visible = show
        end

        -- FOV КРУГ
        if fovCircle then
            if State.aimbotEnabled and State.fovCircleEnabled then
                fovCircle.Visible = true
                fovCircle.Size = UDim2.new(0, State.aimbotFOV * 2, 0, State.aimbotFOV * 2)
            else
                fovCircle.Visible = false
            end
        end

        -- АИМБОТ (только Мардер)
        if State.aimbotEnabled then
            local closest, dist = nil, State.aimbotFOV * 3
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getPlayerRole(plr) == "Murderer" then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local cx = Camera.ViewportSize.X / 2
                            local cy = Camera.ViewportSize.Y / 2
                            local d = math.sqrt((sp.X - cx) ^ 2 + (sp.Y - cy) ^ 2)
                            if d < State.aimbotFOV and d < dist then
                                dist = d
                                closest = plr
                            end
                        end
                    end
                end
            end

            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                State.aimbotTarget = closest
                local target = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(target, 0.35)
                if targetInfo then
                    targetInfo.Visible = true
                    targetInfo.Text = "◆ ЦЕЛЬ: " .. closest.Name .. " [МАРДЕР]"
                end
            else
                State.aimbotTarget = nil
                if targetInfo then targetInfo.Visible = false end
            end
        else
            if targetInfo then targetInfo.Visible = false end
        end

        -- АВТО-ДОСТАТЬ
        if State.autoDrawEnabled and State.aimbotTarget and not hasGunInHand() then
            equipGunFromBackpack()
        end

        -- АВТО-СТРЕЛЬБА
        if State.autoShootEnabled and State.aimbotTarget and State.aimbotTarget.Character then
            local target = State.aimbotTarget
            if getPlayerRole(target) == "Murderer" then
                local head = target.Character:FindFirstChild("Head")
                local wallBetween = false

                if head and LP.Character then
                    local origin = Camera.CFrame.Position
                    local dir = (head.Position - origin)
                    local rp = RaycastParams.new()
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    rp.FilterDescendantsInstances = {LP.Character, target.Character}
                    rp.IgnoreWater = true
                    local result = workspace:Raycast(origin, dir, rp)
                    if result then wallBetween = true end
                end

                if State.autoDrawEnabled and not hasGunInHand() then
                    equipGunFromBackpack()
                end

                if hasGunInHand() then
                    local tool = LP.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                end

                if wallBetween and State.wallbangEnabled then
                    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        pcall(function() humanoid:TakeDamage(35) end)
                    end
                end
            end
        end

        -- СПИНБОТ
        if State.spinEnabled and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(State.spinSpeed * dt * 60), 0)
            end
        end

        -- ESP ПИСТОЛЕТА
        if State.gunESPEnabled then
            local gun = findDroppedGun()
            if gun then
                local part = gun:IsA("Tool") and gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
                if part then
                    if not State.gunHighlight or not State.gunHighlight.Parent then
                        State.gunHighlight = Instance.new("Highlight")
                        State.gunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        State.gunHighlight.FillColor = Color3.fromRGB(255, 220, 0)
                        State.gunHighlight.OutlineColor = Color3.new(1, 1, 1)
                        State.gunHighlight.FillTransparency = 0.4
                        State.gunHighlight.OutlineTransparency = 0
                        State.gunHighlight.Parent = part
                    end
                end
            else
                if State.gunHighlight and State.gunHighlight.Parent then
                    pcall(function() State.gunHighlight:Destroy() end)
                    State.gunHighlight = nil
                end
            end
        elseif State.gunHighlight then
            pcall(function() State.gunHighlight:Destroy() end)
            State.gunHighlight = nil
        end

        -- АВТО-ПИСТОЛЕТ (подбор)
        if State.autoGunEnabled then
            State.gunCooldown = State.gunCooldown - dt
            if State.gunState == "idle" then
                local gun = findDroppedGun()
                if gun and LP.Character then
                    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        State.gunReturnPos = hrp.CFrame
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
                            local touchPart = gun:IsA("Tool") and gun:FindFirstChild("Handle") or gun
                            if touchPart and touchPart:IsA("BasePart") and firetouchinterest then
                                pcall(function()
                                    firetouchinterest(hrp, touchPart, 0)
                                    task.wait(0.05)
                                    firetouchinterest(hrp, touchPart, 1)
                                end)
                            end
                            State.gunState = "pickup"
                            State.gunCooldown = 0.8
                        end
                    end
                end
            elseif State.gunState == "pickup" and State.gunCooldown <= 0 then
                if State.gunReturnPos and LP.Character then
                    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function() hrp.CFrame = State.gunReturnPos end)
                    end
                end
                State.gunState = "idle"
                State.gunReturnPos = nil
                State.gunCooldown = 0.6
            end
        end

        -- КАМПЕР
        if State.camperEnabled then
            local valid = State.camperTarget and State.camperTarget.Parent and State.camperTarget.Character
            if valid then
                local h = State.camperTarget.Character:FindFirstChildOfClass("Humanoid")
                if not h or h.Health <= 0 then valid = false end
            end
            if not valid then
                State.camperTarget = nil
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character and getPlayerRole(plr) == "Sheriff" then
                        State.camperTarget = plr
                        break
                    end
                end
            end
            if State.camperTarget and State.camperTarget.Character then
                local t = State.camperTarget.Character:FindFirstChild("HumanoidRootPart")
                local m = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if t and m then
                    pcall(function() m.CFrame = t.CFrame * CFrame.new(0, 0, 3) end)
                end
            end
        end

        -- ПОДСВЕТКА РОЛЕЙ
        if State.roleHighlight then
            refreshRoleHighlights()
        end

        -- ПОЛЁТ
        if State.flyEnabled and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
                if dir.Magnitude > 0 then
                    hrp.Velocity = dir.Unit * 60
                else
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end

        -- NOCLIP
        if State.noclipEnabled and LP.Character then
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end)

    table.insert(State.connections, conn)
end

-- ═══════════════════ 14. WALLBANG ПО КЛИКУ ═══════════════════
local function setupWallbang()
    local conn = Mouse.Button1Down:Connect(function()
        if not State.wallbangEnabled then return end
        local target = State.aimbotTarget
        if not target and Mouse.Target then
            local m = Mouse.Target:FindFirstAncestorOfClass("Model")
            if m then
                local p = Players:GetPlayerFromCharacter(m)
                if p and p ~= LP then target = p end
            end
        end
        if target and target.Character then
            local h = target.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                pcall(function() h:TakeDamage(200) end)
            end
        end
    end)
    table.insert(State.connections, conn)
end

-- ═══════════════════ 15. БЕСКОНЕЧНЫЙ ПРЫЖОК ═══════════════════
local function setupInfiniteJump()
    local conn = UserInputService.JumpRequest:Connect(function()
        if State.infiniteJumpEnabled and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    table.insert(State.connections, conn)
end

-- ═══════════════════ 16. ЗАГРУЗОЧНЫЙ ЭКРАН ═══════════════════
local function runLoadingScreen()
    task.spawn(function()
        local loadF = Instance.new("Frame")
        loadF.Size = UDim2.new(1, 0, 1, 0)
        loadF.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
        loadF.BorderSizePixel = 0
        loadF.ZIndex = 500
        loadF.Parent = State.gui

        -- Лого
        if LOGO then
            local li = Instance.new("ImageLabel")
            li.Size = UDim2.new(0, 160, 0, 160)
            li.Position = UDim2.new(0.5, -80, 0.5, -150)
            li.BackgroundTransparency = 1
            li.Image = LOGO
            li.ScaleType = Enum.ScaleType.Fit
            li.ImageTransparency = 1
            li.ZIndex = 501
            li.Parent = loadF
            TweenService:Create(li, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
        end

        -- Заголовок
        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1, 0, 0, 36)
        lt.Position = UDim2.new(0, 0, 0.5, 30)
        lt.BackgroundTransparency = 1
        lt.Text = "◆ АДМИНКА ВАНЬКА ◆"
        lt.TextColor3 = Color3.new(1, 1, 1)
        lt.TextSize = 26
        lt.Font = Enum.Font.GothamBold
        lt.TextTransparency = 1
        lt.ZIndex = 501
        lt.Parent = loadF
        TweenService:Create(lt, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

        -- Статус
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

        -- Подстатус
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

        -- Прогресс-бар
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

        -- Проценты
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

        -- Стадии загрузки
        local stages = {
            {p = 5,   t = "Инициализация...",         d = 0.4},
            {p = 12,  t = "Загрузка логотипа...",     d = 0.4},
            {p = 22,  t = "Подключение к серверу...", d = 0.5},
            {p = 32,  t = "Загрузка модулей...",      d = 0.4},
            {p = 45,  t = "Настройка интерфейса...",  d = 0.5},
            {p = 58,  t = "Проверка обновлений...",   d = 0.4},
            {p = 70,  t = "Загрузка функций...",      d = 0.5},
            {p = 82,  t = "Синхронизация...",         d = 0.4},
            {p = 92,  t = "Финальная настройка...",   d = 0.4},
            {p = 100, t = "Готово!",                  d = 0.6},
        }

        for _, st in ipairs(stages) do
            ls.Text = "Загрузка скрипта: " .. st.p .. "%"
            sub.Text = st.t
            pctLbl.Text = st.p .. "%"
            local tw = TweenService:Create(bf, TweenInfo.new(st.d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(st.p / 100, 0, 1, 0)
            })
            tw:Play()
            task.wait(st.d)
        end

        task.wait(0.4)

        -- Плавное исчезновение
        TweenService:Create(loadF, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        for _, c in ipairs(loadF:GetDescendants()) do
            if c:IsA("TextLabel") then
                pcall(function()
                    TweenService:Create(c, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
                end)
            elseif c:IsA("ImageLabel") then
                pcall(function()
                    TweenService:Create(c, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()
                end)
            elseif c:IsA("Frame") then
                pcall(function()
                    TweenService:Create(c, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
                end)
            end
        end
        task.wait(0.7)
        loadF:Destroy()
    end)
end

-- ═══════════════════ 17. ОЧИСТКА ═══════════════════
_G.VankaPanel = {
    Destroy = function()
        for _, c in ipairs(State.connections) do
            if c and c.Disconnect then
                pcall(function() c:Disconnect() end)
            end
        end
        clearRoleHighlights()
        if State.gunHighlight then
            pcall(function() State.gunHighlight:Destroy() end)
        end
        if State.gui then
            pcall(function() State.gui:Destroy() end)
        end
        _G.VankaPanel = nil
    end
}

-- ═══════════════════ 18. ЗАПУСК ═══════════════════
createGUI()
startMainLoop()
setupWallbang()
setupInfiniteJump()
runLoadingScreen()

-- Уведомления о старте
task.delay(6, function()
    notify("◆ Админка Ванька v7.0 загружена!", Color3.fromRGB(255, 0, 100))
end)
task.delay(6.8, function()
    notify("◆ Все функции готовы", Color3.fromRGB(0, 200, 100))
end)

print("[VANKA v7.0 FINAL] Загружено | Логотип: " .. (LOGO and "OK" or "NO"))
