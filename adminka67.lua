-- АДМИНКА ВАНЬКА v22
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")

local LP    = Players.LocalPlayer
local Cam   = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ═════ ЯЗЫКИ ═════
local LANG = "ru"
local L = {
    ru = {
        title="АДМИНКА ВАНЬКА",
        main="ГЛАВНАЯ", visual="ВИЗУАЛ", esp="ESP", rage="РЕЙДЖ", players="ИГРОКИ", settings="НАСТРОЙКИ",
        sheriff_sec="ШЕРИФ", sheriff="Auto Sheriff",
        killall_sec="АВТО-КИЛЛ", killall="Auto Kill All",
        pickup_sec="ПОДБОР", pickup="Подбор пистолета",
        roles_sec="РОЛИ", roles="Подсветка ролей",
        clear_inv="Очистить инвентарь",
        cross_sec="ПРИЦЕЛ", cross="Прицел", cross_style="Стиль прицела", cross_color="Цвет прицела",
        fov="FOV круг", hardaim="Жёсткий аим",
        esp_sec="ESP НАСТРОЙКИ", esp_main="Включить ESP", esp_health="Здоровье",
        esp_name="Имя", esp_dist="Дистанция", esp_box="Бокс", esp_preview="Пример",
        move_sec="ДВИЖЕНИЕ", fly="Полёт", noclip="Noclip", infjump="Беск. прыжок",
        speed="Скорость 50", speed_on="Скорость вкл", speed_off="Скорость выкл",
        aim_sec="АИМ", aimbot="Аимбот", kill_aim="Убить цель",
        spin_sec="СПИНБОТ", spin="Спинбот",
        util_sec="УТИЛИТЫ", respawn="Респавн", disable_all="ВЫКЛЮЧИТЬ ВСЁ",
        lang_sec="ЯЗЫК", lang_ru="Русский", lang_en="English",
        panel_sec="ПАНЕЛЬ", panel_color="Цвет панели", panel_reset="Сбросить",
        save_sec="СОХРАНЕНИЕ", save_info="Настройки сохраняются автоматически",
        plist="ИГРОКИ", tp="ТП", fling="ФЛИНГ",
        saved="Сохранено", loaded="Загружено",
        wait_gun="Жду пистолет", target="Цель", killed="Убил",
        fling_run="Флингаю", fling_done="Отфлингован", no_target="Нет цели",
        sheriff_off="Шериф ВЫКЛ", all_off="Всё выключено",
        cross_1="Классический", cross_2="Точка", cross_3="Круг",
        health="HP", dist="Дист",
    },
    en = {
        title="VANKA ADMIN",
        main="MAIN", visual="VISUAL", esp="ESP", rage="RAGE", players="PLAYERS", settings="SETTINGS",
        sheriff_sec="SHERIFF", sheriff="Auto Sheriff",
        killall_sec="AUTO-KILL", killall="Auto Kill All",
        pickup_sec="PICKUP", pickup="Gun pickup",
        roles_sec="ROLES", roles="Role highlight",
        clear_inv="Clear inventory",
        cross_sec="CROSSHAIR", cross="Crosshair", cross_style="Crosshair style", cross_color="Crosshair color",
        fov="FOV circle", hardaim="Hard aim",
        esp_sec="ESP SETTINGS", esp_main="Enable ESP", esp_health="Health",
        esp_name="Name", esp_dist="Distance", esp_box="Box", esp_preview="Preview",
        move_sec="MOVEMENT", fly="Fly", noclip="Noclip", infjump="Infinite jump",
        speed="Speed 50", speed_on="Speed ON", speed_off="Speed OFF",
        aim_sec="AIM", aimbot="Aimbot", kill_aim="Kill target",
        spin_sec="SPINBOT", spin="Spinbot",
        util_sec="UTILITIES", respawn="Respawn", disable_all="TURN OFF ALL",
        lang_sec="LANGUAGE", lang_ru="Русский", lang_en="English",
        panel_sec="PANEL", panel_color="Panel color", panel_reset="Reset",
        save_sec="SAVING", save_info="Settings save automatically",
        plist="PLAYERS", tp="TP", fling="FLING",
        saved="Saved", loaded="Loaded",
        wait_gun="Waiting for gun", target="Target", killed="Killed",
        fling_run="Flinging", fling_done="Flinged", no_target="No target",
        sheriff_off="Sheriff OFF", all_off="All disabled",
        cross_1="Classic", cross_2="Dot", cross_3="Circle",
        health="HP", dist="Dist",
    }
}
local function T(k) return L[LANG][k] or k end

-- ═════ СОХРАНЕНИЕ ═════
local SAVE_FILE = "vanka_settings.txt"
local SaveData = {
    lang = "ru",
    esp = false, esp_health = true, esp_name = true, esp_dist = true,
    cross_style = 1,
    cross_color = {255, 0, 100},
    panel_color = {255, 0, 100},
    speed50 = false,
}

local function serialize()
    local s = ""
    s = s .. "lang=" .. SaveData.lang .. "\n"
    s = s .. "esp=" .. tostring(SaveData.esp) .. "\n"
    s = s .. "esp_health=" .. tostring(SaveData.esp_health) .. "\n"
    s = s .. "esp_name=" .. tostring(SaveData.esp_name) .. "\n"
    s = s .. "esp_dist=" .. tostring(SaveData.esp_dist) .. "\n"
    s = s .. "cross_style=" .. tostring(SaveData.cross_style) .. "\n"
    s = s .. "cross_color=" .. SaveData.cross_color[1] .. "," .. SaveData.cross_color[2] .. "," .. SaveData.cross_color[3] .. "\n"
    s = s .. "panel_color=" .. SaveData.panel_color[1] .. "," .. SaveData.panel_color[2] .. "," .. SaveData.panel_color[3] .. "\n"
    s = s .. "speed50=" .. tostring(SaveData.speed50) .. "\n"
    return s
end

local function saveSettings()
    if not writefile then return end
    pcall(writefile, SAVE_FILE, serialize())
end

local function loadSettings()
    if not readfile or not isfile then return end
    local ok = pcall(isfile, SAVE_FILE)
    if not ok or not isfile(SAVE_FILE) then return end
    local ok2, data = pcall(readfile, SAVE_FILE)
    if not ok2 or not data then return end
    for line in string.gmatch(data, "[^\n]+") do
        local key, val = string.match(line, "(%w+)=(.+)")
        if key and val then
            if key == "lang" then LANG = val
            elseif key == "esp" then SaveData.esp = (val == "true")
            elseif key == "esp_health" then SaveData.esp_health = (val == "true")
            elseif key == "esp_name" then SaveData.esp_name = (val == "true")
            elseif key == "esp_dist" then SaveData.esp_dist = (val == "true")
            elseif key == "speed50" then SaveData.speed50 = (val == "true")
            elseif key == "cross_style" then SaveData.cross_style = tonumber(val) or 1
            elseif key == "cross_color" then
                local r,g,b = string.match(val, "(%d+),(%d+),(%d+)")
                if r then SaveData.cross_color = {tonumber(r),tonumber(g),tonumber(b)} end
            elseif key == "panel_color" then
                local r,g,b = string.match(val, "(%d+),(%d+),(%d+)")
                if r then SaveData.panel_color = {tonumber(r),tonumber(g),tonumber(b)} end
            end
        end
    end
end

loadSettings()

-- ═════ СКАЧИВАНИЕ КАРТИНОК ═════
local GH = "https://raw.githubusercontent.com/egdemoakola-gif/adminka-vanka/main/"
local function downloadImg(name)
    local file = "vanka_" .. name
    if isfile and getcustomasset then
        if isfile(file) then
            local ok, a = pcall(getcustomasset, file)
            if ok and a and a ~= "" then return a end
        end
    end
    if writefile and getcustomasset then
        local ok, data = pcall(function() return game:HttpGet(GH .. name, true) end)
        if ok and data and #data > 100 then
            pcall(writefile, file, data)
            local ok2, a = pcall(getcustomasset, file)
            if ok2 and a and a ~= "" then return a end
        end
    end
    return nil
end

local LOGO      = downloadImg("vanya.png")
local IMG_MAIN  = downloadImg("main.png")
local IMG_VIS   = downloadImg("visial.png")
local IMG_RAGE  = downloadImg("rage.png")
local IMG_NOOB  = downloadImg("Roblox-Noob-Blocky-Avatar-Transparent-PNG.png")

-- ═════ СОСТОЯНИЕ ═════
local S = {
    roleHighlight=false, roleHL={},
    aimbot=false, aimbotFOV=200, aimT=nil, hardAim=true,
    autoGunPlay=false, autoGunThread=nil,
    autoPickup=false, sheriffThread=nil, lastSheriffPos=nil, lastSheriff=nil,
    spin=false, spinSpeed=30,
    fly=false, noclip=false, infjump=false,
    crosshair=true, fovCircle=true,
    killAllEnabled=false, killList={}, killThread=nil, killLoopThread=nil,
    espEnabled=SaveData.esp, espBillboards={},
    speed50Enabled=SaveData.speed50, speedThread=nil,
    conns={}, gui=nil, panel=nil,
    fullbright=false, oldLighting=nil,
    crossStyle=SaveData.cross_style or 1,
    crossColor=Color3.fromRGB(SaveData.cross_color[1], SaveData.cross_color[2], SaveData.cross_color[3]),
    panelColor=Color3.fromRGB(SaveData.panel_color[1], SaveData.panel_color[2], SaveData.panel_color[3]),
    espHealth=SaveData.esp_health,
    espName=SaveData.esp_name,
    espDist=SaveData.esp_dist,
}

-- ═════ УВЕДОМЛЕНИЯ ═════
local function notify(text, color)
    color = color or Color3.fromRGB(255,0,100)
    if not S.gui then return end
    local h = S.gui:FindFirstChild("NotifHolder")
    if not h then return end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 46)
    n.BackgroundColor3 = Color3.fromRGB(18,18,26)
    n.BorderSizePixel = 0
    n.Parent = h
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke")
    s.Color = color; s.Thickness = 2; s.Parent = n
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color; bar.BorderSizePixel = 0; bar.Parent = n
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1); l.TextSize = 12
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true; l.Parent = n
    n.Position = UDim2.new(1, 320, 0, 0)
    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,0)}):Play()
    task.delay(3, function()
        local t = TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1,320,0,0)})
        t:Play()
        t.Completed:Connect(function() n:Destroy() end)
    end)
end

-- ═════ РОЛИ ═════
local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local function has(nm)
        for _, t in ipairs(plr.Character:GetChildren()) do
            if t:IsA("Tool") and string.find(string.lower(t.Name), nm) then return true end
        end
        if plr.Backpack then
            for _, t in ipairs(plr.Backpack:GetChildren()) do
                if t:IsA("Tool") and string.find(string.lower(t.Name), nm) then return true end
            end
        end
        return false
    end
    if has("knife") or has("dagger") or has("sword") then return "Murderer" end
    if has("gun") or has("pistol") or has("revolver") then return "Sheriff" end
    return "Innocent"
end

local function roleColor(plr)
    local r = getRole(plr)
    if r == "Murderer" then return Color3.fromRGB(255,60,60) end
    if r == "Sheriff" then return Color3.fromRGB(60,150,255) end
    return Color3.fromRGB(60,220,100)
end

local function isGun(t)
    if not t or not t.Name then return false end
    local n = string.lower(t.Name)
    return string.find(n,"gun") or string.find(n,"pistol") or string.find(n,"revolver")
end

local function hasGunInHand()
    if not LP.Character then return false end
    local t = LP.Character:FindFirstChildOfClass("Tool")
    return t and isGun(t)
end

local function hasGunAnywhere()
    if hasGunInHand() then return true end
    if not LP.Backpack then return false end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and isGun(t) then return true end
    end
    return false
end

local function equipGun()
    if not LP.Backpack or not LP.Character then return false end
    local hm = LP.Character:FindFirstChildOfClass("Humanoid")
    if not hm then return false end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and isGun(t) then
            pcall(function() hm:EquipTool(t) end)
            return true
        end
    end
    return false
end

local function findMyKnife()
    if LP.Character then
        for _, t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") then
                local n = string.lower(t.Name)
                if string.find(n,"knife") or string.find(n,"dagger") or string.find(n,"sword") then return t end
            end
        end
    end
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                local n = string.lower(t.Name)
                if string.find(n,"knife") or string.find(n,"dagger") or string.find(n,"sword") then return t end
            end
        end
    end
    return nil
end

local function equipMyKnife()
    local k = findMyKnife()
    if not k then return nil end
    if k.Parent ~= LP.Character then
        local hm = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hm then pcall(function() hm:EquipTool(k) end) task.wait(0.15) end
    end
    return k
end

-- ═════ ФЛИНГ ═════
local function fling(target)
    if not target or target == LP or not target.Character then
        notify(T("no_target"), Color3.fromRGB(255,60,60))
        return
    end
    local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp or not myHrp then return end
    notify(T("fling_run") .. ": " .. target.Name, Color3.fromRGB(255,0,150))
    
    task.spawn(function()
        for _, p in ipairs(target.Character:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
        end
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = myHrp
        
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(1e6, 1e6, 1e6)
        bav.Parent = myHrp
        
        local startTime = tick()
        while tick() - startTime < 2 do
            if not target.Character then break end
            local curHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not curHrp then break end
            for i = 1, 6 do
                local a = math.random() * math.pi * 2
                local ox = math.cos(a) * 2
                local oz = math.sin(a) * 2
                local oy = math.random(-2, 3)
                pcall(function()
                    myHrp.CFrame = curHrp.CFrame * CFrame.new(ox, oy, oz)
                    bv.Velocity = Vector3.new(
                        math.random(-80000, 80000),
                        math.random(-40000, 100000),
                        math.random(-80000, 80000)
                    )
                    myHrp.RotVelocity = Vector3.new(1e5, 1e5, 1e5)
                end)
                task.wait()
            end
        end
        
        if bv then pcall(function() bv:Destroy() end) end
        if bav then pcall(function() bav:Destroy() end) end
        
        task.wait(1.5)
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local y = target.Character.HumanoidRootPart.Position.Y
            if y > 500 then notify(target.Name .. " " .. T("fling_done") .. "!", Color3.fromRGB(255,100,200))
            else notify(target.Name .. " " .. T("fling_done"), Color3.fromRGB(100,200,255)) end
        end
    end)
end

-- ═════ AUTO SHERIFF ═════
local function findHead(tChar)
    return tChar:FindFirstChild("Head") or tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso")
end

local function startAutoGunPlay()
    if S.autoGunThread then return end
    S.autoGunThread = task.spawn(function()
        notify(T("wait_gun") .. "...", Color3.fromRGB(255,200,0))
        local currentTarget = nil
        while S.autoGunPlay do
            if not hasGunAnywhere() then
                if currentTarget then currentTarget = nil end
                task.wait(0.3)
                continue
            end
            if not hasGunInHand() then
                equipGun()
                task.wait(0.1)
                if not hasGunInHand() then task.wait(0.3) continue end
            end
            if not currentTarget or not currentTarget.Character then
                currentTarget = nil
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        if getRole(plr) == "Murderer" then
                            local h = plr.Character:FindFirstChildOfClass("Humanoid")
                            if h and h.Health > 0 then currentTarget = plr break end
                        end
                    end
                end
                if not currentTarget then task.wait(0.3) continue end
            end
            local tChar = currentTarget.Character
            if not tChar then currentTarget = nil task.wait(0.2) continue end
            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            local tHrp = tChar:FindFirstChild("HumanoidRootPart")
            if not tHum or tHum.Health <= 0 or not tHrp then
                notify(T("killed") .. " " .. currentTarget.Name, Color3.fromRGB(0,255,100))
                currentTarget = nil
                task.wait(0.2)
                continue
            end
            for _, p in ipairs(tChar:GetDescendants()) do
                if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
            end
            local hitbox = findHead(tChar)
            if not hitbox then task.wait(0.05) continue end
            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHrp and tHrp then
                pcall(function()
                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
                    myHrp.Velocity = Vector3.new(0, 0, 0)
                end)
            end
            local targetPos = hitbox.Position
            for _ = 1, 4 do
                local newCF = CFrame.new(Cam.CFrame.Position, targetPos)
                Cam.CFrame = Cam.CFrame:Lerp(newCF, 0.95)
            end
            local lookDir = Cam.CFrame.LookVector
            local toTarget = (targetPos - Cam.CFrame.Position).Unit
            local dot = lookDir:Dot(toTarget)
            if dot > 0.995 then
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if tool and isGun(tool) then
                    for i = 1, 15 do pcall(function() tool:Activate() end) end
                end
            end
            task.wait()
        end
        S.autoGunThread = nil
        notify(T("sheriff_off"), Color3.fromRGB(150,150,150))
    end)
end
local function stopAutoGunPlay() S.autoGunPlay = false S.autoGunThread = nil end

-- ═════ AUTO KILL ALL ═════
local function killOneTarget(target)
    if not target or target == LP or not target.Character then return false end
    local myChar = LP.Character
    if not myChar then return false end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
    if not myHrp or not targetHrp or not targetHum then return false end
    if targetHum.Health <= 0 then return true end
    local knife = equipMyKnife()
    if not knife then return false end
    local handle = knife:FindFirstChild("Handle")
    for _, p in ipairs(target.Character:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
    end
    for attempt = 1, 15 do
        if targetHum.Health <= 0 then return true end
        targetHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not targetHrp then return true end
        pcall(function() myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1.5) end)
        task.wait(0.02)
        if handle then
            for _, part in ipairs(target.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        firetouchinterest(handle, part, 0)
                        firetouchinterest(handle, part, 1)
                    end)
                end
            end
        end
        pcall(function() knife:Activate() end)
        task.wait(0.05)
    end
    task.wait(0.2)
    return targetHum and targetHum.Health <= 0
end
local function startAutoKillAll()
    if S.killThread then return end
    S.killList = {}
    S.killThread = task.spawn(function()
        if getRole(LP) ~= "Murderer" then S.killThread = nil return end
        while S.killAllEnabled do
            local target = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 and not S.killList[plr] then target = plr break end
                end
            end
            if not target then break end
            local ok = killOneTarget(target)
            S.killList[target] = true
            task.wait(0.3)
        end
        S.killThread = nil
    end)
end
local function stopAutoKillAll() S.killList = {} S.killThread = nil end
local function startKillAllLoop()
    if S.killLoopThread then return end
    S.killLoopThread = task.spawn(function()
        while S.killAllEnabled do
            if getRole(LP) == "Murderer" then
                if not S.killThread then startAutoKillAll() end
            else
                if S.killThread then stopAutoKillAll() end
            end
            task.wait(1)
        end
        S.killLoopThread = nil
    end)
end
local function stopKillAllLoop()
    S.killAllEnabled = false
    stopAutoKillAll()
    S.killLoopThread = nil
end

-- ═════ ESP ═════
local function updateESP()
    if not S.espEnabled then
        for _, bb in pairs(S.espBillboards) do
            pcall(function() bb:Destroy() end)
        end
        S.espBillboards = {}
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local bb = S.espBillboards[plr]
                if not bb or bb.Parent ~= head then
                    if bb then bb:Destroy() end
                    bb = Instance.new("BillboardGui")
                    bb.Name = "VankaESP"
                    bb.Size = UDim2.new(0, 220, 0, 70)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head
                    
                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Name = "NameLbl"
                    nameLbl.Size = UDim2.new(1, 0, 0, 16)
                    nameLbl.Position = UDim2.new(0, 0, 0, 0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = plr.Name
                    nameLbl.TextStrokeTransparency = 0
                    nameLbl.TextSize = 12
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.Parent = bb
                    
                    local distLbl = Instance.new("TextLabel")
                    distLbl.Name = "DistLbl"
                    distLbl.Size = UDim2.new(1, 0, 0, 14)
                    distLbl.Position = UDim2.new(0, 0, 0, 16)
                    distLbl.BackgroundTransparency = 1
                    distLbl.TextStrokeTransparency = 0
                    distLbl.TextSize = 11
                    distLbl.Font = Enum.Font.Gotham
                    distLbl.Parent = bb
                    
                    local hpBg = Instance.new("Frame")
                    hpBg.Name = "HpBg"
                    hpBg.Size = UDim2.new(0, 120, 0, 6)
                    hpBg.Position = UDim2.new(0.5, -60, 0, 34)
                    hpBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
                    hpBg.BorderSizePixel = 0
                    hpBg.Parent = bb
                    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)
                    
                    local hpFill = Instance.new("Frame")
                    hpFill.Name = "HpFill"
                    hpFill.Size = UDim2.new(1, 0, 1, 0)
                    hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
                    hpFill.BorderSizePixel = 0
                    hpFill.Parent = hpBg
                    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 3)
                    
                    S.espBillboards[plr] = bb
                end
                
                local nameLbl = bb:FindFirstChild("NameLbl")
                local distLbl = bb:FindFirstChild("DistLbl")
                local hpBg = bb:FindFirstChild("HpBg")
                
                if nameLbl then
                    nameLbl.Visible = S.espName
                    nameLbl.Text = plr.Name .. " [" .. getRole(plr) .. "]"
                    nameLbl.TextColor3 = roleColor(plr)
                end
                
                if distLbl and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    distLbl.Visible = S.espDist
                    local myHrp = LP.Character.HumanoidRootPart
                    local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        local d = (myHrp.Position - tHrp.Position).Magnitude
                        distLbl.Text = "[" .. math.floor(d) .. "m]"
                        distLbl.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end
                
                if hpBg then
                    hpBg.Visible = S.espHealth
                    local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tHum then
                        local pct = tHum.Health / tHum.MaxHealth
                        local hpFill = hpBg:FindFirstChild("HpFill")
                        if hpFill then
                            hpFill.Size = UDim2.new(pct, 0, 1, 0)
                            if pct > 0.6 then hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
                            elseif pct > 0.3 then hpFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
                            else hpFill.BackgroundColor3 = Color3.fromRGB(255,0,0) end
                        end
                    end
                end
            end
        end
    end
end

-- ═════ АВТО-СКОРОСТЬ 50 (не сбрасывается при респавне) ═════
local function startSpeed50Loop()
    if S.speedThread then return end
    S.speedThread = task.spawn(function()
        while S.speed50Enabled do
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h and h.WalkSpeed ~= 50 then
                    h.WalkSpeed = 50
                end
            end
            task.wait(0.3)
        end
        S.speedThread = nil
    end)
end

-- ═════ ПОДБОР ═════
local function startAutoPickup()
    if S.sheriffThread then return end
    S.lastSheriff = nil
    S.lastSheriffPos = nil
    S.sheriffThread = task.spawn(function()
        while S.autoPickup do
            local curSheriff = nil
            local curPos = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    if getRole(plr) == "Sheriff" then
                        curSheriff = plr
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then curPos = hrp.CFrame end
                        break
                    end
                end
            end
            if curSheriff and curPos then S.lastSheriffPos = curPos end
            if S.lastSheriff and not curSheriff and S.lastSheriffPos then
                task.wait(0.4)
                if LP.Character then
                    local myHrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        pcall(function() myHrp.CFrame = S.lastSheriffPos + Vector3.new(0, 3, 0) end)
                        task.wait(1)
                    end
                end
                S.lastSheriffPos = nil
            end
            S.lastSheriff = curSheriff
            task.wait(0.3)
        end
        S.sheriffThread = nil
    end)
end
local function stopAutoPickup()
    S.autoPickup = false
    S.sheriffThread = nil
    S.lastSheriff = nil
    S.lastSheriffPos = nil
end

-- ═════ ESP HL ═════
local function refreshHL()
    if not S.roleHighlight then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local c = roleColor(plr)
            local hl = S.roleHL[plr]
            if not hl or hl.Parent ~= plr.Character then
                if hl then hl:Destroy() end
                hl = Instance.new("Highlight")
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.55
                hl.OutlineTransparency = 0.1
                hl.Parent = plr.Character
                S.roleHL[plr] = hl
            end
            hl.FillColor = c
            hl.OutlineColor = c
        end
    end
end

local function clearHL()
    for _, hl in pairs(S.roleHL) do pcall(function() hl:Destroy() end) end
    S.roleHL = {}
end

-- ═════ СОЗДАНИЕ GUI ═════
local function createGUI()
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "VankaPanel_" .. tostring(math.random(1000,9999))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent
    S.gui = gui

    local nh = Instance.new("Frame")
    nh.Name = "NotifHolder"
    nh.Size = UDim2.new(0, 300, 1, -40)
    nh.Position = UDim2.new(1, -320, 0, 20)
    nh.BackgroundTransparency = 1
    nh.Parent = gui
    local nl = Instance.new("UIListLayout")
    nl.Padding = UDim.new(0, 8)
    nl.SortOrder = Enum.SortOrder.LayoutOrder
    nl.Parent = nh

    -- УВЕЛИЧЕННАЯ ПАНЕЛЬ
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 500, 0, 620)
    main.Position = UDim2.new(0, 20, 0.5, -310)
    main.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    S.panel = main

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14)),
    }
    bgGrad.Rotation = 45
    bgGrad.Parent = main

    local mstk = Instance.new("UIStroke")
    mstk.Name = "MainStroke"
    mstk.Color = S.panelColor
    mstk.Thickness = 2
    mstk.Parent = main

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 54)
    top.BackgroundColor3 = Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 26)
    tf.Position = UDim2.new(0, 0, 1, -26)
    tf.BackgroundColor3 = Color3.fromRGB(22,22,32)
    tf.BorderSizePixel = 0
    tf.Parent = top

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0, 38, 0, 38)
        li.Position = UDim2.new(0, 14, 0.5, -19)
        li.BackgroundTransparency = 1
        li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit
        li.Parent = top
        Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8)
    else
        local he = Instance.new("TextLabel")
        he.Size = UDim2.new(0, 38, 1, 0)
        he.Position = UDim2.new(0, 14, 0, 0)
        he.BackgroundTransparency = 1
        he.Text = "V"
        he.TextColor3 = S.panelColor
        he.TextSize = 26
        he.Font = Enum.Font.GothamBold
        he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Name = "Title"
    ttl.Size = UDim2.new(1, -160, 1, 0)
    ttl.Position = UDim2.new(0, 62, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = T("title") .. " v22"
    ttl.TextColor3 = Color3.new(1,1,1)
    ttl.TextSize = 16
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = top

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0, 32, 0, 32)
    minB.Position = UDim2.new(1, -76, 0, 11)
    minB.BackgroundColor3 = Color3.fromRGB(55,55,70)
    minB.Text = "−"
    minB.TextColor3 = Color3.new(1,1,1)
    minB.TextSize = 20
    minB.Font = Enum.Font.GothamBold
    minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 7)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0, 32, 0, 32)
    closeB.Position = UDim2.new(1, -40, 0, 11)
    closeB.BackgroundColor3 = Color3.fromRGB(255,55,75)
    closeB.Text = "×"
    closeB.TextColor3 = Color3.new(1,1,1)
    closeB.TextSize = 20
    closeB.Font = Enum.Font.GothamBold
    closeB.Parent = top
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 7)

    local openB = Instance.new("TextButton")
    openB.Size = UDim2.new(0, 55, 0, 55)
    openB.Position = UDim2.new(0, 15, 0.5, -27)
    openB.BackgroundColor3 = S.panelColor
    openB.Text = "V"
    openB.TextColor3 = Color3.new(1,1,1)
    openB.TextSize = 22
    openB.Font = Enum.Font.GothamBold
    openB.Visible = false
    openB.Parent = gui
    Instance.new("UICorner", openB).CornerRadius = UDim.new(0, 28)
    if LOGO then
        openB.Text = ""
        local oi = Instance.new("ImageLabel")
        oi.Size = UDim2.new(0, 38, 0, 38)
        oi.Position = UDim2.new(0.5, -19, 0.5, -19)
        oi.BackgroundTransparency = 1
        oi.Image = LOGO
        oi.ScaleType = Enum.ScaleType.Fit
        oi.Parent = openB
    end

    -- ТАБЫ
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 44)
    tabBar.Position = UDim2.new(0, 10, 0, 60)
    tabBar.BackgroundColor3 = Color3.fromRGB(20,20,28)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 4)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tl.Parent = tabBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -175)
    content.Position = UDim2.new(0, 10, 0, 114)
    content.BackgroundTransparency = 1
    content.Parent = main

    local tabs, pages = {}, {}
    local function switchTab(name)
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and S.panelColor or Color3.fromRGB(32,32,44)
        end
    end

    local function addTab(key, img, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 88, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(32,32,44)
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        tabs[key] = b
        if img then
            local im = Instance.new("ImageLabel")
            im.Size = UDim2.new(0, 26, 0, 26)
            im.Position = UDim2.new(0.5, -13, 0.5, -13)
            im.BackgroundTransparency = 1
            im.Image = img
            im.ScaleType = Enum.ScaleType.Fit
            im.Parent = b
        else
            b.Text = txt or key:upper()
            b.TextColor3 = Color3.fromRGB(170,170,190)
            b.TextSize = 11
            b.Font = Enum.Font.GothamBold
        end
        local p = Instance.new("ScrollingFrame")
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ScrollBarThickness = 5
        p.ScrollBarImageColor3 = S.panelColor
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.Visible = false
        p.Parent = content
        pages[key] = p
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 6)
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
        b.Size = UDim2.new(1, -6, 0, 36)
        b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.TextSize = 13
        b.Font = Enum.Font.GothamMedium
        b.TextWrapped = true
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then notify("Error: " .. tostring(err), Color3.fromRGB(255,60,60)) end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -6, 0, 40)
        row.BackgroundColor3 = Color3.fromRGB(22,22,32)
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230,230,240)
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0, 46, 0, 22)
        sw.Position = UDim2.new(1, -56, 0.5, -11)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
        sw.BorderSizePixel = 0
        sw.Parent = row
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local kn = Instance.new("Frame")
        kn.Size = UDim2.new(0, 18, 0, 18)
        kn.Position = initial and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        kn.BackgroundColor3 = Color3.new(1,1,1)
        kn.BorderSizePixel = 0
        kn.Parent = sw
        Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)
        local st = initial
        row.MouseButton1Click:Connect(function()
            st = not st
            TweenService:Create(sw, TweenInfo.new(0.15), {
                BackgroundColor3 = st and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
            }):Play()
            TweenService:Create(kn, TweenInfo.new(0.15), {
                Position = st and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }):Play()
            cb(st)
        end)
        return row
    end

    local function addLabel(parent, text)
        local w = Instance.new("Frame")
        w.Size = UDim2.new(1, -6, 0, 28)
        w.BackgroundTransparency = 1
        w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0, 3, 0, 16)
        a.Position = UDim2.new(0, 0, 0.5, -8)
        a.BackgroundColor3 = S.panelColor
        a.BorderSizePixel = 0
        a.Parent = w
        Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -14, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = S.panelColor
        l.TextSize = 12
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = w
    end

    -- Табы
    local tabMain     = addTab("main", IMG_MAIN)
    local tabVisual   = addTab("visual", IMG_VIS)
    local tabESP      = addTab("esp", nil, "ESP")
    local tabRage     = addTab("rage", IMG_RAGE)
    local tabPlayers  = addTab("players", nil, T("players"))
    local tabSettings = addTab("settings", nil, T("settings"))
    switchTab("main")

    -- ═ MAIN ═
    addLabel(tabMain, T("sheriff_sec"))
    addToggle(tabMain, T("sheriff"), false, function(v)
        S.autoGunPlay = v
        if v then startAutoGunPlay() else stopAutoGunPlay() end
    end)

    addLabel(tabMain, T("killall_sec"))
    addToggle(tabMain, T("killall"), false, function(v)
        S.killAllEnabled = v
        if v then startKillAllLoop() else stopKillAllLoop() end
    end)

    addLabel(tabMain, T("pickup_sec"))
    addToggle(tabMain, T("pickup"), false, function(v)
        S.autoPickup = v
        if v then startAutoPickup() else stopAutoPickup() end
    end)

    addLabel(tabMain, T("roles_sec"))
    addToggle(tabMain, T("roles"), false, function(v)
        S.roleHighlight = v
        if v then refreshHL() else clearHL() end
    end)

    addBtn(tabMain, T("clear_inv"), Color3.fromRGB(60,60,70), function()
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

    -- ═ VISUAL ═
    addLabel(tabVisual, T("cross_sec"))
    addToggle(tabVisual, T("cross"), true, function(v) S.crosshair = v end)
    addToggle(tabVisual, T("fov"), true, function(v) S.fovCircle = v end)
    addToggle(tabVisual, T("hardaim"), true, function(v) S.hardAim = v end)
    
    addLabel(tabVisual, T("cross_style"))
    addBtn(tabVisual, T("cross_1"), Color3.fromRGB(60,60,90), function()
        S.crossStyle = 1
        SaveData.cross_style = 1
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
        notify(T("saved"), Color3.fromRGB(0,200,100))
    end)
    addBtn(tabVisual, T("cross_2"), Color3.fromRGB(60,60,90), function()
        S.crossStyle = 2
        SaveData.cross_style = 2
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
        notify(T("saved"), Color3.fromRGB(0,200,100))
    end)
    addBtn(tabVisual, T("cross_3"), Color3.fromRGB(60,60,90), function()
        S.crossStyle = 3
        SaveData.cross_style = 3
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
        notify(T("saved"), Color3.fromRGB(0,200,100))
    end)

    addLabel(tabVisual, T("move_sec"))
    addToggle(tabVisual, T("fly"), false, function(v) S.fly = v end)
    addToggle(tabVisual, T("noclip"), false, function(v) S.noclip = v end)
    addToggle(tabVisual, T("infjump"), false, function(v) S.infjump = v end)
    
    addToggle(tabVisual, T("speed"), S.speed50Enabled, function(v)
        S.speed50Enabled = v
        SaveData.speed50 = v
        saveSettings()
        if v then
            startSpeed50Loop()
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = 50 end
            end
        else
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = 16 end
            end
        end
    end)

    addLabel(tabVisual, T("vis_sec"))
    addToggle(tabVisual, T("fullbright"), false, function(v)
        S.fullbright = v
        if v then
            if not S.oldLighting then
                S.oldLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                }
            end
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(180,180,180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180,180,180)
        else
            if S.oldLighting then
                Lighting.Brightness = S.oldLighting.Brightness
                Lighting.ClockTime = S.oldLighting.ClockTime
                Lighting.Ambient = S.oldLighting.Ambient
                Lighting.OutdoorAmbient = S.oldLighting.OutdoorAmbient
                S.oldLighting = nil
            end
        end
    end)

    -- ═ ESP ═
    addLabel(tabESP, T("esp_sec"))
    addToggle(tabESP, T("esp_main"), S.espEnabled, function(v)
        S.espEnabled = v
        SaveData.esp = v
        saveSettings()
    end)
    addToggle(tabESP, T("esp_health"), S.espHealth, function(v)
        S.espHealth = v
        SaveData.esp_health = v
        saveSettings()
    end)
    addToggle(tabESP, T("esp_name"), S.espName, function(v)
        S.espName = v
        SaveData.esp_name = v
        saveSettings()
    end)
    addToggle(tabESP, T("esp_dist"), S.espDist, function(v)
        S.espDist = v
        SaveData.esp_dist = v
        saveSettings()
    end)
    
    addLabel(tabESP, T("esp_preview"))
    if IMG_NOOB then
        local pFrame = Instance.new("Frame")
        pFrame.Size = UDim2.new(1, -6, 0, 220)
        pFrame.BackgroundColor3 = Color3.fromRGB(22,22,32)
        pFrame.BorderSizePixel = 0
        pFrame.Parent = tabESP
        Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 10)
        
        local pImg = Instance.new("ImageLabel")
        pImg.Size = UDim2.new(0, 180, 0, 180)
        pImg.Position = UDim2.new(0.5, -90, 0, 20)
        pImg.BackgroundTransparency = 1
        pImg.Image = IMG_NOOB
        pImg.ScaleType = Enum.ScaleType.Fit
        pImg.Parent = pFrame
    else
        addBtn(tabESP, "Ошибка: картинка не загружена", Color3.fromRGB(80,40,40), function() end)
    end

    -- ═ RAGE ═
    addLabel(tabRage, T("aim_sec"))
    addToggle(tabRage, T("aimbot"), false, function(v) S.aimbot = v end)
    addBtn(tabRage, T("kill_aim"), Color3.fromRGB(170,20,30), function()
        if S.aimT and S.aimT.Character then
            local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end)

    addLabel(tabRage, T("spin_sec"))
    addToggle(tabRage, T("spin"), false, function(v) S.spin = v end)

    addLabel(tabRage, T("util_sec"))
    addBtn(tabRage, T("respawn"), Color3.fromRGB(100,60,150), function()
        if LP.Character then LP.Character:BreakJoints() end
    end)
    addBtn(tabRage, T("disable_all"), Color3.fromRGB(180,0,100), function()
        S.aimbot=false S.roleHighlight=false S.fly=false S.noclip=false S.infjump=false
        S.spin=false S.autoPickup=false S.killAllEnabled=false S.killList={}
        S.autoGunPlay=false S.espEnabled=false S.speed50Enabled=false
        stopKillAllLoop()
        stopAutoPickup()
        stopAutoGunPlay()
        clearHL()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed=16 h.JumpPower=50 end
        end
        notify(T("all_off"), Color3.fromRGB(255,60,60))
    end)

    -- ═ PLAYERS ═
    addLabel(tabPlayers, T("plist"))
    local pList = Instance.new("Frame")
    pList.Size = UDim2.new(1, -6, 0, 380)
    pList.BackgroundColor3 = Color3.fromRGB(16,16,24)
    pList.BorderSizePixel = 0
    pList.Parent = tabPlayers
    Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 10)
    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1, -10, 1, -10)
    pScroll.Position = UDim2.new(0, 5, 0, 5)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 5
    pScroll.ScrollBarImageColor3 = S.panelColor
    pScroll.CanvasSize = UDim2.new(0,0,0,0)
    pScroll.Parent = pList
    local pLay = Instance.new("UIListLayout")
    pLay.Padding = UDim.new(0, 5)
    pLay.Parent = pScroll
    pLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pScroll.CanvasSize = UDim2.new(0, 0, 0, pLay.AbsoluteContentSize.Y + 8)
    end)

    local rows = {}
    local function rebuild()
        for _, r in pairs(rows) do r:Destroy() end
        rows = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -4, 0, 46)
                row.BackgroundColor3 = Color3.fromRGB(26,26,36)
                row.BorderSizePixel = 0
                row.Parent = pScroll
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0, 36, 0, 36)
                av.Position = UDim2.new(0, 5, 0.5, -18)
                av.BackgroundColor3 = Color3.fromRGB(40,40,55)
                av.BorderSizePixel = 0
                av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                av.Parent = row
                Instance.new("UICorner", av).CornerRadius = UDim.new(0, 18)

                local tag = Instance.new("Frame")
                tag.Size = UDim2.new(0, 6, 0, 28)
                tag.Position = UDim2.new(0, 46, 0.5, -14)
                tag.BackgroundColor3 = roleColor(plr)
                tag.BorderSizePixel = 0
                tag.Parent = row
                Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)

                local nm = Instance.new("TextLabel")
                nm.Size = UDim2.new(1, -180, 1, 0)
                nm.Position = UDim2.new(0, 60, 0, 0)
                nm.BackgroundTransparency = 1
                nm.Text = plr.Name
                nm.TextColor3 = Color3.fromRGB(230,230,240)
                nm.TextSize = 12
                nm.Font = Enum.Font.GothamMedium
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Parent = row

                local tpB = Instance.new("TextButton")
                tpB.Size = UDim2.new(0, 38, 0, 28)
                tpB.Position = UDim2.new(1, -128, 0.5, -14)
                tpB.BackgroundColor3 = Color3.fromRGB(40,100,200)
                tpB.Text = T("tp")
                tpB.TextColor3 = Color3.new(1,1,1)
                tpB.TextSize = 11
                tpB.Font = Enum.Font.GothamBold
                tpB.Parent = row
                Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, 6)
                tpB.MouseButton1Click:Connect(function()
                    if plr.Character and LP.Character then
                        local t = plr.Character:FindFirstChild("HumanoidRootPart")
                        local m = LP.Character:FindFirstChild("HumanoidRootPart")
                        if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0,0,4) end) end
                    end
                end)

                local flB = Instance.new("TextButton")
                flB.Size = UDim2.new(0, 68, 0, 28)
                flB.Position = UDim2.new(1, -86, 0.5, -14)
                flB.BackgroundColor3 = Color3.fromRGB(180,20,100)
                flB.Text = T("fling")
                flB.TextColor3 = Color3.new(1,1,1)
                flB.TextSize = 11
                flB.Font = Enum.Font.GothamBold
                flB.Parent = row
                Instance.new("UICorner", flB).CornerRadius = UDim.new(0, 6)
                flB.MouseButton1Click:Connect(function() fling(plr) end)

                rows[plr] = row
            end
        end
    end
    rebuild()
    Players.PlayerAdded:Connect(function() task.wait(1) rebuild() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.3) rebuild() end)

    -- ═ SETTINGS ═
    addLabel(tabSettings, T("lang_sec"))
    addBtn(tabSettings, T("lang_ru"), Color3.fromRGB(50,80,150), function()
        LANG = "ru"
        SaveData.lang = "ru"
        saveSettings()
        notify(T("saved") .. ": Русский", Color3.fromRGB(0,200,100))
        -- Обновляем тексты
        ttl.Text = T("title") .. " v22"
        for k, b in pairs(tabs) do
            if k == "players" then b.Text = T("players") end
            if k == "settings" then b.Text = T("settings") end
        end
    end)
    addBtn(tabSettings, T("lang_en"), Color3.fromRGB(50,80,150), function()
        LANG = "en"
        SaveData.lang = "en"
        saveSettings()
        notify(T("saved") .. ": English", Color3.fromRGB(0,200,100))
        ttl.Text = T("title") .. " v22"
        for k, b in pairs(tabs) do
            if k == "players" then b.Text = T("players") end
            if k == "settings" then b.Text = T("settings") end
        end
    end)
    
    addLabel(tabSettings, T("panel_sec"))
    addLabel(tabSettings, T("panel_color"))
    
    -- Пресеты цвета
    local colors = {
        {255,0,100, "Розовый"},
        {0,150,255, "Синий"},
        {0,255,130, "Зелёный"},
        {255,200,0, "Жёлтый"},
        {180,0,255, "Фиолетовый"},
        {255,100,0, "Оранжевый"},
        {255,255,255, "Белый"},
        {100,100,100, "Серый"},
    }
    for _, c in ipairs(colors) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(c[1], c[2], c[3])
        btn.Text = c[4]
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabSettings
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function()
            S.panelColor = Color3.fromRGB(c[1], c[2], c[3])
            SaveData.panel_color = {c[1], c[2], c[3]}
            saveSettings()
            -- Применяем
            mstk.Color = S.panelColor
            openB.BackgroundColor3 = S.panelColor
            pScroll.ScrollBarImageColor3 = S.panelColor
            for _, tab in pairs(tabs) do
                if tab.BackgroundColor3 ~= Color3.fromRGB(32,32,44) then
                    tab.BackgroundColor3 = S.panelColor
                end
            end
            notify(T("saved"), Color3.fromRGB(0,200,100))
        end)
    end
    
    addBtn(tabSettings, T("panel_reset"), Color3.fromRGB(120,50,50), function()
        S.panelColor = Color3.fromRGB(255,0,100)
        SaveData.panel_color = {255,0,100}
        saveSettings()
        mstk.Color = S.panelColor
        openB.BackgroundColor3 = S.panelColor
        pScroll.ScrollBarImageColor3 = S.panelColor
        notify(T("saved"), Color3.fromRGB(0,200,100))
    end)
    
    addLabel(tabSettings, T("save_sec"))
    addBtn(tabSettings, T("save_info"), Color3.fromRGB(40,40,60), function() end)

    -- Обработчики закрытия
    closeB.MouseButton1Click:Connect(function()
        pcall(clearHL)
        stopKillAllLoop()
        stopAutoPickup()
        stopAutoGunPlay()
        for _, bb in pairs(S.espBillboards) do
            pcall(function() bb:Destroy() end)
        end
        for _, c in ipairs(S.conns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        pcall(function() gui:Destroy() end)
        _G.VankaPanel = nil
    end)

    minB.MouseButton1Click:Connect(function()
        main.Visible = false
        openB.Visible = true
    end)
    openB.MouseButton1Click:Connect(function()
        main.Visible = true
        openB.Visible = false
    end)

    return gui
end

-- ═════ ПРИЦЕЛ / FOV ═════
local crossH, crossV, crossDot, crossCircle, fovCircle

local function updateCrosshair()
    if crossH then
        if S.crossStyle == 1 then
            crossH.Visible = S.crosshair
            crossV.Visible = S.crosshair
            crossDot.Visible = false
            if crossCircle then crossCircle.Visible = false end
            crossH.BackgroundColor3 = S.crossColor
            crossV.BackgroundColor3 = S.crossColor
        elseif S.crossStyle == 2 then
            crossH.Visible = false
            crossV.Visible = false
            crossDot.Visible = S.crosshair
            if crossCircle then crossCircle.Visible = false end
            crossDot.BackgroundColor3 = S.crossColor
        elseif S.crossStyle == 3 then
            crossH.Visible = false
            crossV.Visible = false
            crossDot.Visible = false
            if crossCircle then
                crossCircle.Visible = S.crosshair
                crossCircle.UIStroke.Color = S.crossColor
            end
        end
    end
end
_G.VankaUpdateCross = updateCrosshair

local function createOverlays()
    crossH = Instance.new("Frame")
    crossH.Size = UDim2.new(0, 20, 0, 2)
    crossH.Position = UDim2.new(0.5, -10, 0.5, -1)
    crossH.BackgroundColor3 = S.crossColor
    crossH.BorderSizePixel = 0
    crossH.Parent = S.gui

    crossV = Instance.new("Frame")
    crossV.Size = UDim2.new(0, 2, 0, 20)
    crossV.Position = UDim2.new(0.5, -1, 0.5, -10)
    crossV.BackgroundColor3 = S.crossColor
    crossV.BorderSizePixel = 0
    crossV.Parent = S.gui

    crossDot = Instance.new("Frame")
    crossDot.Size = UDim2.new(0, 5, 0, 5)
    crossDot.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
    crossDot.BackgroundColor3 = S.crossColor
    crossDot.BorderSizePixel = 0
    crossDot.Visible = false
    crossDot.Parent = S.gui
    Instance.new("UICorner", crossDot).CornerRadius = UDim.new(1, 0)

    crossCircle = Instance.new("Frame")
    crossCircle.Size = UDim2.new(0, 30, 0, 30)
    crossCircle.Position = UDim2.new(0.5, -15, 0.5, -15)
    crossCircle.BackgroundTransparency = 1
    crossCircle.Visible = false
    crossCircle.Parent = S.gui
    Instance.new("UICorner", crossCircle).CornerRadius = UDim.new(1, 0)
    local ccStroke = Instance.new("UIStroke")
    ccStroke.Color = S.crossColor
    ccStroke.Thickness = 2
    ccStroke.Parent = crossCircle

    fovCircle = Instance.new("Frame")
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Size = UDim2.new(0, 400, 0, 400)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.Parent = S.gui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    local fs = Instance.new("UIStroke")
    fs.Color = S.panelColor
    fs.Thickness = 1.5
    fs.Transparency = 0.35
    fs.Parent = fovCircle

    updateCrosshair()
end

local function mainLoop()
    local conn = RunService.RenderStepped:Connect(function(dt)
        if not S.gui then return end
        updateCrosshair()
        
        if fovCircle then
            if S.aimbot and S.fovCircle then
                fovCircle.Visible = true
                fovCircle.Size = UDim2.new(0, S.aimbotFOV*2, 0, S.aimbotFOV*2)
            else
                fovCircle.Visible = false
            end
        end
        
        if S.aimbot then
            local cl, dist = nil, S.aimbotFOV * 3
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "Murderer" then
                    local h = plr.Character:FindFirstChild("Head")
                    if h then
                        local sp, on = Cam:WorldToViewportPoint(h.Position)
                        if on then
                            local cx = Cam.ViewportSize.X / 2
                            local cy = Cam.ViewportSize.Y / 2
                            local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
                            if d < S.aimbotFOV and d < dist then
                                dist = d cl = plr
                            end
                        end
                    end
                end
            end
            if cl and cl.Character and cl.Character:FindFirstChild("Head") then
                S.aimT = cl
                Cam.CFrame = CFrame.new(Cam.CFrame.Position, cl.Character.Head.Position)
            else
                S.aimT = nil
            end
        end
        
        if S.spin and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed * dt * 60), 0)
            end
        end
        
        if S.roleHighlight then refreshHL() end
        if S.espEnabled then updateESP() end
        
        if S.fly and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - Cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + Cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then d = d - Vector3.new(0,1,0) end
                if d.Magnitude > 0 then hrp.Velocity = d.Unit * 60
                else hrp.Velocity = Vector3.new(0,0,0) end
            end
        end
        
        if S.noclip and LP.Character then
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end
    end)
    table.insert(S.conns, conn)
end

local function setupInfJump()
    local c = UIS.JumpRequest:Connect(function()
        if S.infjump and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
    table.insert(S.conns, c)
end

local function runLoading()
    task.spawn(function()
        local lf = Instance.new("Frame")
        lf.Size = UDim2.new(1,0,1,0)
        lf.BackgroundColor3 = Color3.fromRGB(6,6,12)
        lf.BorderSizePixel = 0
        lf.ZIndex = 500
        lf.Parent = S.gui

        if LOGO then
            local li = Instance.new("ImageLabel")
            li.Size = UDim2.new(0,180,0,180)
            li.Position = UDim2.new(0.5,-90,0.5,-170)
            li.BackgroundTransparency = 1
            li.Image = LOGO
            li.ScaleType = Enum.ScaleType.Fit
            li.ZIndex = 501
            li.Parent = lf
        end

        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1,0,0,40)
        lt.Position = UDim2.new(0,0,0.5,30)
        lt.BackgroundTransparency = 1
        lt.Text = T("title")
        lt.TextColor3 = Color3.new(1,1,1)
        lt.TextSize = 28
        lt.Font = Enum.Font.GothamBold
        lt.ZIndex = 501
        lt.Parent = lf

        local ls = Instance.new("TextLabel")
        ls.Size = UDim2.new(1,0,0,22)
        ls.Position = UDim2.new(0,0,0.5,75)
        ls.BackgroundTransparency = 1
        ls.Text = "0%"
        ls.TextColor3 = Color3.fromRGB(180,180,210)
        ls.TextSize = 15
        ls.Font = Enum.Font.GothamMedium
        ls.ZIndex = 501
        ls.Parent = lf

        local bb = Instance.new("Frame")
        bb.Size = UDim2.new(0,360,0,12)
        bb.Position = UDim2.new(0.5,-180,0.5,140)
        bb.BackgroundColor3 = Color3.fromRGB(28,28,40)
        bb.BorderSizePixel = 0
        bb.ZIndex = 501
        bb.Parent = lf
        Instance.new("UICorner", bb).CornerRadius = UDim.new(1,0)

        local bf = Instance.new("Frame")
        bf.Size = UDim2.new(0,0,1,0)
        bf.BackgroundColor3 = S.panelColor
        bf.BorderSizePixel = 0
        bf.ZIndex = 502
        bf.Parent = bb
        Instance.new("UICorner", bf).CornerRadius = UDim.new(1,0)

        for i = 1, 100, 5 do
            ls.Text = i .. "%"
            local tw = TweenService:Create(bf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(i/100, 0, 1, 0)
            })
            tw:Play()
            task.wait(0.08)
        end
        task.wait(0.4)
        TweenService:Create(lf, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        for _, c in ipairs(lf:GetDescendants()) do
            if c:IsA("TextLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {TextTransparency = 1}):Play() end)
            elseif c:IsA("ImageLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {ImageTransparency = 1}):Play() end)
            elseif c:IsA("Frame") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play() end)
            end
        end
        task.wait(0.7)
        lf:Destroy()
    end)
end

_G.VankaPanel = {
    Destroy = function()
        for _, c in ipairs(S.conns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        clearHL()
        stopKillAllLoop()
        stopAutoPickup()
        stopAutoGunPlay()
        for _, bb in pairs(S.espBillboards) do
            pcall(function() bb:Destroy() end)
        end
        if S.gui then pcall(function() S.gui:Destroy() end) end
        _G.VankaPanel = nil
    end
}

-- Автозапуск авто-скорости если была включена
if S.speed50Enabled then
    startSpeed50Loop()
end

createGUI()
createOverlays()
mainLoop()
setupInfJump()
runLoading()

task.delay(5, function() notify(T("loaded"), Color3.fromRGB(0,200,100)) end)

print("[VANKA v22] OK")
