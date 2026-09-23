-- VANKA ADMIN v29
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")

local LP    = Players.LocalPlayer
local Cam   = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ═════ ЯЗЫКИ ═════
local LANG = "ru"
local L = {
    ru = {
        title="АДМИНКА ВАНЬКА", main="ГЛАВНАЯ", visual="ВИЗУАЛ", esp="ESP", rage="РЕЙДЖ", players="ИГРОКИ", settings="НАСТРОЙКИ", configs="КОНФИГИ",
        sheriff_sec="ШЕРИФ", autoshoot="Auto Shoot (стрельба в Мардера)", autokill="Auto Kill (нож, если ты Мардер)",
        farm_sec="ФАРМ", farm="Auto Farm Coins", pickup_sec="ПОДБОР", pickup="Подбор пистолета",
        roles_sec="РОЛИ", roles="Подсветка ролей", clear_inv="Очистить инвентарь", invisible="Невидимость",
        cross_sec="ПРИЦЕЛ", cross="Прицел", cross_style="Стиль", cross_custom="Свой прицел (PNG)",
        fov="FOV круг", hardaim="Жёсткий аим", aim_part="Часть тела", aim_smooth="Плавность", wallcheck="Стены",
        esp_sec="ESP", esp_main="Включить", esp_health="Здоровье", esp_name="Имя", esp_dist="Дистанция",
        esp_weapon="Оружие", esp_rainbow="Радужный", esp_preview="Превью:",
        esp_color_killer="Цвет Мардера", esp_color_sheriff="Цвет Шерифа", esp_color_innocent="Цвет Невиновного",
        move_sec="ДВИЖЕНИЕ", fly="Полёт", noclip="Noclip", infjump="Беск. прыжок", speed="Скорость 50",
        aim_sec="АИМ", aimbot="Аимбот", kill_aim="Убить цель",
        spin_sec="СПИНБОТ", spin="Спинбот", util_sec="УТИЛИТЫ", respawn="Респавн", disable_all="ВЫКЛЮЧИТЬ ВСЁ",
        lang_sec="ЯЗЫК", lang_ru="Русский", lang_en="English", lang_zh="中文",
        panel_sec="ЦВЕТ ПАНЕЛИ", plist="ИГРОКИ", tp="ТП", fling="ФЛИНГ",
        saved="Сохранено", loaded="Загружено", wait_gun="Жду пистолет", target="Цель", killed="Убил",
        fling_run="Флингаю", fling_done="Отфлингован", no_target="Нет цели", sheriff_off="Auto Shoot ВЫКЛ", all_off="Всё выключено",
        farm_on="Фарм ВКЛ", farm_off="Фарм ВЫКЛ", farm_full="Сумка полная", farm_none="Монет нет",
        cross_1="Классик", cross_2="Точка", cross_3="Круг",
        preview_name="Игрок123", preview_dist="15m",
        cfg_save="Сохранить", cfg_load="Загрузить", cfg_name="Имя конфига", cfg_saved="Конфиг сохранён", cfg_loaded="Конфиг загружен", cfg_notfound="Не найден",
        inv_on="Невидимость ВКЛ", inv_off="Невидимость ВЫКЛ", cross_loaded="Прицел загружен", cross_notfound="Файл не найден",
        aim_head="Голова", aim_torso="Торс", aim_random="Случайно",
    },
    en = {
        title="VANKA ADMIN", main="MAIN", visual="VISUAL", esp="ESP", rage="RAGE", players="PLAYERS", settings="SETTINGS", configs="CONFIGS",
        sheriff_sec="SHERIFF", autoshoot="Auto Shoot (shoot Murderer)", autokill="Auto Kill (knife, if you're Murderer)",
        farm_sec="FARM", farm="Auto Farm Coins", pickup_sec="PICKUP", pickup="Gun pickup",
        roles_sec="ROLES", roles="Role highlight", clear_inv="Clear inventory", invisible="Invisible",
        cross_sec="CROSSHAIR", cross="Crosshair", cross_style="Style", cross_custom="Custom crosshair (PNG)",
        fov="FOV circle", hardaim="Hard aim", aim_part="Aim part", aim_smooth="Smoothness", wallcheck="Wall check",
        esp_sec="ESP", esp_main="Enable", esp_health="Health", esp_name="Name", esp_dist="Distance",
        esp_weapon="Weapon", esp_rainbow="Rainbow", esp_preview="Preview:",
        esp_color_killer="Murderer Color", esp_color_sheriff="Sheriff Color", esp_color_innocent="Innocent Color",
        move_sec="MOVEMENT", fly="Fly", noclip="Noclip", infjump="Infinite jump", speed="Speed 50",
        aim_sec="AIM", aimbot="Aimbot", kill_aim="Kill target",
        spin_sec="SPINBOT", spin="Spinbot", util_sec="UTILITIES", respawn="Respawn", disable_all="TURN OFF ALL",
        lang_sec="LANGUAGE", lang_ru="Русский", lang_en="English", lang_zh="中文",
        panel_sec="PANEL COLOR", plist="PLAYERS", tp="TP", fling="FLING",
        saved="Saved", loaded="Loaded", wait_gun="Waiting for gun", target="Target", killed="Killed",
        fling_run="Flinging", fling_done="Flinged", no_target="No target", sheriff_off="Auto Shoot OFF", all_off="All disabled",
        farm_on="Farm ON", farm_off="Farm OFF", farm_full="Bag full", farm_none="No coins",
        cross_1="Classic", cross_2="Dot", cross_3="Circle",
        preview_name="Player123", preview_dist="15m",
        cfg_save="Save", cfg_load="Load", cfg_name="Config name", cfg_saved="Config saved", cfg_loaded="Config loaded", cfg_notfound="Not found",
        inv_on="Invisible ON", inv_off="Invisible OFF", cross_loaded="Crosshair loaded", cross_notfound="File not found",
        aim_head="Head", aim_torso="Torso", aim_random="Random",
    },
    zh = {
        title="VANKA 管理员", main="主要", visual="视觉", esp="ESP", rage="愤怒", players="玩家", settings="设置", configs="配置",
        sheriff_sec="警长", autoshoot="自动射击 (射击凶手)", autokill="自动击杀 (刀, 如果你是凶手)",
        farm_sec="农场", farm="自动农场", pickup_sec="拾取", pickup="拾取枪支",
        roles_sec="角色", roles="角色高亮", clear_inv="清空背包", invisible="隐身",
        cross_sec="准星", cross="准星", cross_style="样式", cross_custom="自定义准星",
        fov="FOV", hardaim="硬瞄准", aim_part="瞄准部位", aim_smooth="平滑", wallcheck="墙检",
        esp_sec="ESP", esp_main="启用", esp_health="生命", esp_name="名字", esp_dist="距离",
        esp_weapon="武器", esp_rainbow="彩虹", esp_preview="预览:",
        esp_color_killer="凶手颜色", esp_color_sheriff="警长颜色", esp_color_innocent="无辜颜色",
        move_sec="移动", fly="飞行", noclip="穿墙", infjump="无限跳", speed="速度 50",
        aim_sec="瞄准", aimbot="自瞄", kill_aim="击杀目标",
        spin_sec="旋转", spin="旋转", util_sec="工具", respawn="重生", disable_all="关闭所有",
        lang_sec="语言", lang_ru="Русский", lang_en="English", lang_zh="中文",
        panel_sec="面板颜色", plist="玩家", tp="传送", fling="甩飞",
        saved="已保存", loaded="已加载", wait_gun="等待枪", target="目标", killed="击杀",
        fling_run="甩飞", fling_done="已甩飞", no_target="无目标", sheriff_off="自动射击关闭", all_off="全部关闭",
        farm_on="农场开", farm_off="农场关", farm_full="满包", farm_none="无硬币",
        cross_1="经典", cross_2="点", cross_3="圆",
        preview_name="玩家123", preview_dist="15m",
        cfg_save="保存", cfg_load="加载", cfg_name="配置名", cfg_saved="已保存", cfg_loaded="已加载", cfg_notfound="未找到",
        inv_on="隐身开", inv_off="隐身关", cross_loaded="准星加载", cross_notfound="文件未找到",
        aim_head="头", aim_torso="躯干", aim_random="随机",
    }
}
local function T(k) return L[LANG][k] or k end

-- ═════ СОХРАНЕНИЕ ═════
local SAVE_FILE = "vanka_settings_v29.txt"
local CFG_FOLDER = "vanka_configs/"
local SaveData = {
    lang="ru",
    esp=false, esp_health=true, esp_name=true, esp_dist=true, esp_weapon=true, esp_rainbow=false,
    esp_color_killer={255,60,60}, esp_color_sheriff={60,150,255}, esp_color_innocent={60,220,100},
    cross_style=1, cross_color={255,0,100}, panel_color={255,0,100},
    speed50=false, farm=false, invisible=false,
    aim_part="Head", aim_smooth=0.35, wallcheck=false, custom_cross="",
}

local function serialize()
    local s = ""
    local keys = {"lang","esp","esp_health","esp_name","esp_dist","esp_weapon","esp_rainbow","cross_style","speed50","farm","invisible","aim_part","aim_smooth","wallcheck","custom_cross"}
    for _, k in ipairs(keys) do
        local v = SaveData[k]
        if type(v) == "boolean" then s = s .. k .. "=" .. tostring(v) .. "\n"
        elseif type(v) == "number" then s = s .. k .. "=" .. tostring(v) .. "\n"
        elseif type(v) == "string" then s = s .. k .. "=" .. v .. "\n" end
    end
    s = s .. "cross_color=" .. table.concat(SaveData.cross_color, ",") .. "\n"
    s = s .. "panel_color=" .. table.concat(SaveData.panel_color, ",") .. "\n"
    s = s .. "esp_color_killer=" .. table.concat(SaveData.esp_color_killer, ",") .. "\n"
    s = s .. "esp_color_sheriff=" .. table.concat(SaveData.esp_color_sheriff, ",") .. "\n"
    s = s .. "esp_color_innocent=" .. table.concat(SaveData.esp_color_innocent, ",") .. "\n"
    return s
end
local function saveSettings() if writefile then pcall(writefile, SAVE_FILE, serialize()) end end
local function loadSettings()
    if not readfile or not isfile then return end
    local ok = pcall(isfile, SAVE_FILE)
    if not ok or not isfile(SAVE_FILE) then return end
    local ok2, data = pcall(readfile, SAVE_FILE)
    if not ok2 or not data then return end
    for line in string.gmatch(data, "[^\n]+") do
        local k, v = string.match(line, "(%w+)=(.+)")
        if k and v then
            if k == "lang" then LANG = v
            elseif k == "esp" then SaveData.esp = (v == "true")
            elseif k == "esp_health" then SaveData.esp_health = (v == "true")
            elseif k == "esp_name" then SaveData.esp_name = (v == "true")
            elseif k == "esp_dist" then SaveData.esp_dist = (v == "true")
            elseif k == "esp_weapon" then SaveData.esp_weapon = (v == "true")
            elseif k == "esp_rainbow" then SaveData.esp_rainbow = (v == "true")
            elseif k == "speed50" then SaveData.speed50 = (v == "true")
            elseif k == "farm" then SaveData.farm = (v == "true")
            elseif k == "invisible" then SaveData.invisible = (v == "true")
            elseif k == "wallcheck" then SaveData.wallcheck = (v == "true")
            elseif k == "cross_style" then SaveData.cross_style = tonumber(v) or 1
            elseif k == "aim_smooth" then SaveData.aim_smooth = tonumber(v) or 0.35
            elseif k == "aim_part" then SaveData.aim_part = v
            elseif k == "custom_cross" then SaveData.custom_cross = v
            elseif k == "cross_color" then
                local r,g,b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.cross_color = {tonumber(r),tonumber(g),tonumber(b)} end
            elseif k == "panel_color" then
                local r,g,b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.panel_color = {tonumber(r),tonumber(g),tonumber(b)} end
            elseif k == "esp_color_killer" then
                local r,g,b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_killer = {tonumber(r),tonumber(g),tonumber(b)} end
            elseif k == "esp_color_sheriff" then
                local r,g,b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_sheriff = {tonumber(r),tonumber(g),tonumber(b)} end
            elseif k == "esp_color_innocent" then
                local r,g,b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_innocent = {tonumber(r),tonumber(g),tonumber(b)} end
            end
        end
    end
end
loadSettings()

-- КАРТИНКИ
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
local LOGO = downloadImg("vanya.png")
local IMG_MAIN = downloadImg("main.png")
local IMG_VIS = downloadImg("visial.png")
local IMG_RAGE = downloadImg("rage.png")
local IMG_NOOB = downloadImg("Roblox-Noob-Blocky-Avatar-Transparent-PNG.png")

local S = {
    roleHighlight=false, roleHL={},
    aimbot=false, aimbotFOV=200, aimT=nil, hardAim=true,
    autoShootEnabled=false, autoShootThread=nil,
    autoKillEnabled=false, autoKillThread=nil, autoKillList={},
    autoPickup=false, sheriffThread=nil, lastSheriffPos=nil, lastSheriff=nil,
    farmEnabled=SaveData.farm, farmThread=nil,
    spin=false, spinSpeed=30,
    fly=false, noclip=false, infjump=false,
    crosshair=true, fovCircle=true,
    espEnabled=SaveData.esp, espBillboards={}, espWeaponHighlights={},
    speed50Enabled=SaveData.speed50, speedThread=nil,
    invisibleEnabled=SaveData.invisible, invisibleConn=nil,
    aimPart=SaveData.aim_part or "Head", aimSmooth=SaveData.aim_smooth or 0.35, wallCheck=SaveData.wallcheck or false,
    conns={}, gui=nil, panel=nil,
    fullbright=false, oldLighting=nil,
    crossStyle=SaveData.cross_style or 1,
    crossColor=Color3.fromRGB(SaveData.cross_color[1], SaveData.cross_color[2], SaveData.cross_color[3]),
    panelColor=Color3.fromRGB(SaveData.panel_color[1], SaveData.panel_color[2], SaveData.panel_color[3]),
    espHealth=SaveData.esp_health, espName=SaveData.esp_name,
    espDist=SaveData.esp_dist, espWeapon=SaveData.esp_weapon, espRainbow=SaveData.esp_rainbow,
    espColorKiller=Color3.fromRGB(SaveData.esp_color_killer[1], SaveData.esp_color_killer[2], SaveData.esp_color_killer[3]),
    espColorSheriff=Color3.fromRGB(SaveData.esp_color_sheriff[1], SaveData.esp_color_sheriff[2], SaveData.esp_color_sheriff[3]),
    espColorInnocent=Color3.fromRGB(SaveData.esp_color_innocent[1], SaveData.esp_color_innocent[2], SaveData.esp_color_innocent[3]),
    previewRefs={}, crossImage=nil,
}

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
        t:Play(); t.Completed:Connect(function() n:Destroy() end)
    end)
end

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
    if S.espRainbow then
        local hue = (tick() * 0.5) % 1
        return Color3.fromHSV(hue, 1, 1)
    end
    local r = getRole(plr)
    if r == "Murderer" then return S.espColorKiller end
    if r == "Sheriff" then return S.espColorSheriff end
    return S.espColorInnocent
end

local function isGun(t)
    if not t or not t.Name then return false end
    local n = string.lower(t.Name)
    return string.find(n,"gun") or string.find(n,"pistol") or string.find(n,"revolver")
end
local function isKnife(t)
    if not t or not t.Name then return false end
    local n = string.lower(t.Name)
    return string.find(n,"knife") or string.find(n,"dagger") or string.find(n,"sword")
end
local function getToolInHand(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChildOfClass("Tool")
end
local function getHandPart(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChild("RightHand") or plr.Character:FindFirstChild("Right Arm") or plr.Character:FindFirstChild("LeftHand") or plr.Character:FindFirstChild("Left Arm")
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
            if t:IsA("Tool") and isKnife(t) then return t end
        end
    end
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and isKnife(t) then return t end
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

-- ═══════════════════════════════════════════
-- AUTO SHOOT (Шериф стреляет в Мардера)
-- Рабочий метод: точная наводка в голову + 15 выстрелов
-- ═══════════════════════════════════════════
local function getAimPart(tChar)
    if S.aimPart == "Random" then
        local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
        return tChar:FindFirstChild(parts[math.random(1, #parts)])
    end
    return tChar:FindFirstChild(S.aimPart) or tChar:FindFirstChild("Head")
end

local function startAutoShoot()
    if S.autoShootThread then return end
    S.autoShootThread = task.spawn(function()
        notify(T("wait_gun") .. "...", Color3.fromRGB(255,200,0))
        local currentTarget = nil
        while S.autoShootEnabled do
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
            local hitbox = getAimPart(tChar)
            if not hitbox then task.wait(0.05) continue end
            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHrp and tHrp then
                pcall(function()
                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
                    myHrp.Velocity = Vector3.new(0, 0, 0)
                end)
            end
            local targetPos = hitbox.Position
            local newCF = CFrame.new(Cam.CFrame.Position, targetPos)
            if S.hardAim then
                Cam.CFrame = newCF
            else
                Cam.CFrame = Cam.CFrame:Lerp(newCF, 1 - S.aimSmooth)
            end
            local lookDir = Cam.CFrame.LookVector
            local toTarget = (targetPos - Cam.CFrame.Position).Unit
            local dot = lookDir:Dot(toTarget)
            local canShoot = true
            if S.wallCheck then
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = {LP.Character, tChar}
                local res = workspace:Raycast(Cam.CFrame.Position, targetPos - Cam.CFrame.Position, rp)
                if res then canShoot = false end
            end
            if dot > 0.99 and canShoot then
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if tool and isGun(tool) then
                    for i = 1, 12 do pcall(function() tool:Activate() end) end
                end
            end
            task.wait()
        end
        S.autoShootThread = nil
        notify(T("sheriff_off"), Color3.fromRGB(150,150,150))
    end)
end
local function stopAutoShoot() S.autoShootEnabled = false S.autoShootThread = nil end

-- ═══════════════════════════════════════════
-- AUTO KILL (нож, если ты Мардер)
-- ═══════════════════════════════════════════
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

local function startAutoKill()
    if S.autoKillThread then return end
    S.autoKillList = {}
    S.autoKillThread = task.spawn(function()
        if getRole(LP) ~= "Murderer" then S.autoKillThread = nil return end
        while S.autoKillEnabled do
            local target = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 and not S.autoKillList[plr] then target = plr break end
                end
            end
            if not target then break end
            killOneTarget(target)
            S.autoKillList[target] = true
            task.wait(0.3)
        end
        S.autoKillThread = nil
    end)
end
local function stopAutoKill() S.autoKillList = {} S.autoKillThread = nil end
local function startAutoKillLoop()
    if S.autoKillLoopThread then return end
    S.autoKillLoopThread = task.spawn(function()
        while S.autoKillEnabled do
            if getRole(LP) == "Murderer" then
                if not S.autoKillThread then startAutoKill() end
            else
                if S.autoKillThread then stopAutoKill() end
            end
            task.wait(1)
        end
        S.autoKillLoopThread = nil
    end)
end
local function stopAutoKillLoop()
    S.autoKillEnabled = false
    stopAutoKill()
    S.autoKillLoopThread = nil
end

-- ═══════════════════════════════════════════
-- ФЛИНГ (рабочий FE-метод)
-- ═══════════════════════════════════════════
local flingBusy = false
local function fling(target)
    if not target or target == LP or not target.Character then
        notify(T("no_target"), Color3.fromRGB(255,60,60))
        return
    end
    if flingBusy then return end
    flingBusy = true
    local tChar = target.Character
    local tHrp = tChar:FindFirstChild("HumanoidRootPart")
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp or not myHrp then flingBusy = false return end
    notify(T("fling_run") .. ": " .. target.Name, Color3.fromRGB(255,0,150))
    task.spawn(function()
        local myPos = myHrp.CFrame
        local wasAnchored = myHrp.Anchored
        myHrp.Anchored = true
        for _, p in ipairs(tChar:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
        end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0); bv.Parent = tHrp
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(0,0,0); bav.Parent = tHrp
        local t0 = tick()
        while tick() - t0 < 2.5 do
            if not target.Character then break end
            local curHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not curHrp then break end
            local a1 = math.random() * math.pi * 2
            local a2 = math.random() * math.pi - math.pi/2
            local r = math.random(1, 3)
            pcall(function()
                myHrp.CFrame = curHrp.CFrame * CFrame.new(math.cos(a1)*math.cos(a2)*r, math.sin(a2)*r, math.sin(a1)*math.cos(a2)*r)
                bv.Velocity = Vector3.new(math.random(-40000,40000), math.random(50000,90000), math.random(-40000,40000))
                bav.AngularVelocity = Vector3.new(math.random(-800,800), math.random(-800,800), math.random(-800,800))
                curHrp.AssemblyLinearVelocity = Vector3.new(math.random(-30000,30000), math.random(40000,80000), math.random(-30000,30000))
            end)
            pcall(function() myHrp.CFrame = myPos end)
            task.wait()
        end
        if bv then pcall(function() bv:Destroy() end) end
        if bav then pcall(function() bav:Destroy() end) end
        task.wait(1)
        myHrp.Anchored = wasAnchored
        task.wait(0.2)
        pcall(function()
            if myHrp and myHrp.Parent then
                myHrp.CFrame = myPos
                myHrp.Velocity = Vector3.new(0,0,0)
            end
        end)
        flingBusy = false
        task.wait(1)
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local y = target.Character.HumanoidRootPart.Position.Y
            if y > 500 then notify(target.Name .. " В КОСМОСЕ!", Color3.fromRGB(255,100,200))
            elseif y > myPos.Position.Y + 50 then notify(target.Name .. " УЛЕТЕЛ!", Color3.fromRGB(255,150,50))
            else notify(target.Name .. " чуть откинуло", Color3.fromRGB(150,150,150)) end
        end
    end)
end

-- ФАРМ
local function findCoin()
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    local closest, closestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), "coin") then
            local part = nil
            if obj:IsA("Tool") then part = obj:FindFirstChild("Handle")
            elseif obj:IsA("BasePart") then part = obj
            elseif obj:IsA("Model") then part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
            if part then
                local used = false
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character and obj:IsDescendantOf(plr.Character) then used = true break end
                    if plr.Backpack and obj:IsDescendantOf(plr.Backpack) then used = true break end
                end
                if not used then
                    local d = (part.Position - myHrp.Position).Magnitude
                    if d < closestDist then closestDist = d; closest = {obj=obj, part=part} end
                end
            end
        end
    end
    return closest
end
local function isBagFull()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, gui in ipairs(pg:GetDescendants()) do
            if string.find(string.lower(gui.Name), "fullbag") and gui:IsA("GuiObject") and gui.Visible then
                return true
            end
        end
    end
    return false
end
local function startFarm()
    if S.farmThread then return end
    S.farmThread = task.spawn(function()
        notify(T("farm_on"), Color3.fromRGB(0,200,100))
        while S.farmEnabled do
            if isBagFull() then notify(T("farm_full"), Color3.fromRGB(255,200,0)); S.farmEnabled=false break end
            local coin = findCoin()
            if not coin then notify(T("farm_none"), Color3.fromRGB(150,150,150)); task.wait(2); if not S.farmEnabled then break end; continue end
            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not myHrp then task.wait(0.5) continue end
            local targetCoin = coin.obj
            local targetPart = coin.part
            pcall(function() myHrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0,1,0)) end)
            local t0 = tick()
            while tick() - t0 < 1.5 do
                if not targetCoin or not targetCoin.Parent then break end
                local used = false
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character and targetCoin:IsDescendantOf(plr.Character) then used = true break end
                    if plr.Backpack and targetCoin:IsDescendantOf(plr.Backpack) then used = true break end
                end
                if used then break end
                if targetPart and targetPart.Parent then
                    pcall(function() myHrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0,1,0)) end)
                end
                if isBagFull() then notify(T("farm_full"), Color3.fromRGB(255,200,0)); S.farmEnabled=false break end
                task.wait()
            end
            task.wait(0.05)
        end
        notify(T("farm_off"), Color3.fromRGB(150,150,150))
        S.farmThread = nil
    end)
end
local function stopFarm() S.farmEnabled = false S.farmThread = nil end

-- ESP
local function updateESP()
    if not S.espEnabled then
        for _, bb in pairs(S.espBillboards) do pcall(function() bb:Destroy() end) end
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
                    bb.Size = UDim2.new(0, 240, 0, 90)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head
                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Name = "NameLbl"; nameLbl.Size = UDim2.new(1,0,0,16)
                    nameLbl.Position = UDim2.new(0,0,0,0); nameLbl.BackgroundTransparency = 1
                    nameLbl.TextStrokeTransparency = 0; nameLbl.TextSize = 12
                    nameLbl.Font = Enum.Font.GothamBold; nameLbl.Parent = bb
                    local weaponLbl = Instance.new("TextLabel")
                    weaponLbl.Name = "WeaponLbl"; weaponLbl.Size = UDim2.new(1,0,0,16)
                    weaponLbl.Position = UDim2.new(0,0,0,16); weaponLbl.BackgroundTransparency = 1
                    weaponLbl.TextStrokeTransparency = 0; weaponLbl.TextSize = 13
                    weaponLbl.Font = Enum.Font.GothamBold; weaponLbl.Parent = bb
                    local distLbl = Instance.new("TextLabel")
                    distLbl.Name = "DistLbl"; distLbl.Size = UDim2.new(1,0,0,14)
                    distLbl.Position = UDim2.new(0,0,0,32); distLbl.BackgroundTransparency = 1
                    distLbl.TextStrokeTransparency = 0; distLbl.TextSize = 11
                    distLbl.Font = Enum.Font.Gotham; distLbl.Parent = bb
                    local hpBg = Instance.new("Frame")
                    hpBg.Name = "HpBg"; hpBg.Size = UDim2.new(0,120,0,6)
                    hpBg.Position = UDim2.new(0.5,-60,0,50); hpBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
                    hpBg.BorderSizePixel = 0; hpBg.Parent = bb
                    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,3)
                    local hpFill = Instance.new("Frame")
                    hpFill.Name = "HpFill"; hpFill.Size = UDim2.new(1,0,1,0)
                    hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0); hpFill.BorderSizePixel = 0
                    hpFill.Parent = hpBg
                    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0,3)
                    S.espBillboards[plr] = bb
                end
                local nameLbl = bb:FindFirstChild("NameLbl")
                local weaponLbl = bb:FindFirstChild("WeaponLbl")
                local distLbl = bb:FindFirstChild("DistLbl")
                local hpBg = bb:FindFirstChild("HpBg")
                if nameLbl then
                    nameLbl.Visible = S.espName
                    nameLbl.Text = plr.Name .. " [" .. getRole(plr) .. "]"
                    nameLbl.TextColor3 = roleColor(plr)
                end
                if weaponLbl then
                    weaponLbl.Visible = S.espWeapon
                    if S.espWeapon then
                        local tool = getToolInHand(plr)
                        if tool then
                            if isKnife(tool) then
                                weaponLbl.Text = "🔪 " .. tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(255,80,80)
                                local hand = getHandPart(plr)
                                if hand and not hand:FindFirstChild("VankaHandHL") then
                                    local hl = Instance.new("Highlight")
                                    hl.Name = "VankaHandHL"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.FillColor = Color3.fromRGB(255,50,50); hl.OutlineColor = Color3.fromRGB(255,255,255)
                                    hl.FillTransparency = 0.3; hl.Parent = hand
                                end
                            elseif isGun(tool) then
                                weaponLbl.Text = "🔫 " .. tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(80,180,255)
                                local hand = getHandPart(plr)
                                if hand and not hand:FindFirstChild("VankaHandHL") then
                                    local hl = Instance.new("Highlight")
                                    hl.Name = "VankaHandHL"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.FillColor = Color3.fromRGB(50,150,255); hl.OutlineColor = Color3.fromRGB(255,255,255)
                                    hl.FillTransparency = 0.3; hl.Parent = hand
                                end
                            else
                                weaponLbl.Text = "⚔ " .. tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(255,200,80)
                            end
                        else weaponLbl.Text = "" end
                    end
                end
                if not S.espWeapon or not getToolInHand(plr) then
                    local hand = getHandPart(plr)
                    if hand then
                        local old = hand:FindFirstChild("VankaHandHL")
                        if old then old:Destroy() end
                    end
                end
                if distLbl and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    distLbl.Visible = S.espDist
                    local myHrp = LP.Character.HumanoidRootPart
                    local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        distLbl.Text = "[" .. math.floor((myHrp.Position - tHrp.Position).Magnitude) .. "m]"
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

-- НЕВИДИМОСТЬ
local function applyInvisible()
    if not S.invisibleEnabled then return end
    if not LP.Character then return end
    for _, p in ipairs(LP.Character:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then
            pcall(function() p.Transparency = 1 end)
        end
    end
    for _, acc in ipairs(LP.Character:GetChildren()) do
        if acc:IsA("Accessory") then
            local h = acc:FindFirstChild("Handle")
            if h then pcall(function() h.Transparency = 1 end) end
        end
    end
end
local function setInvisible(state)
    S.invisibleEnabled = state
    SaveData.invisible = state
    saveSettings()
    if state then
        applyInvisible()
        if not S.invisibleConn then
            S.invisibleConn = RunService.Heartbeat:Connect(applyInvisible)
        end
        notify(T("inv_on"), Color3.fromRGB(150,50,150))
    else
        if S.invisibleConn then S.invisibleConn:Disconnect() S.invisibleConn = nil end
        if LP.Character then
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") or p:IsA("Decal") then
                    pcall(function() p.Transparency = 0 end)
                end
            end
            for _, acc in ipairs(LP.Character:GetChildren()) do
                if acc:IsA("Accessory") then
                    local h = acc:FindFirstChild("Handle")
                    if h then pcall(function() h.Transparency = 0 end) end
                end
            end
        end
        notify(T("inv_off"), Color3.fromRGB(150,150,150))
    end
end

-- АВТО-СКОРОСТЬ
local function startSpeed50Loop()
    if S.speedThread then return end
    S.speedThread = task.spawn(function()
        while S.speed50Enabled do
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h and h.WalkSpeed ~= 50 then h.WalkSpeed = 50 end
            end
            task.wait(0.3)
        end
        S.speedThread = nil
    end)
end

-- ПОДБОР
local function startAutoPickup()
    if S.sheriffThread then return end
    S.lastSheriff = nil; S.lastSheriffPos = nil
    S.sheriffThread = task.spawn(function()
        while S.autoPickup do
            local curSheriff, curPos = nil, nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "Sheriff" then
                    curSheriff = plr
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then curPos = hrp.CFrame end
                    break
                end
            end
            if curSheriff and curPos then S.lastSheriffPos = curPos end
            if S.lastSheriff and not curSheriff and S.lastSheriffPos then
                task.wait(0.4)
                if LP.Character then
                    local myHrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        pcall(function() myHrp.CFrame = S.lastSheriffPos + Vector3.new(0,3,0) end)
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
    S.autoPickup = false; S.sheriffThread = nil
    S.lastSheriff = nil; S.lastSheriffPos = nil
end

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
                hl.FillTransparency = 0.55; hl.OutlineTransparency = 0.1
                hl.Parent = plr.Character
                S.roleHL[plr] = hl
            end
            hl.FillColor = c; hl.OutlineColor = c
        end
    end
end
local function clearHL()
    for _, hl in pairs(S.roleHL) do pcall(function() hl:Destroy() end) end
    S.roleHL = {}
end

-- КОНФИГИ
local function ensureCfgFolder()
    if not makefolder then return end
    pcall(makefolder, "vanka_configs")
end
local function saveConfig(name)
    if not writefile or not name or name == "" then return false end
    ensureCfgFolder()
    local path = "vanka_configs/" .. name .. ".txt"
    local ok = pcall(writefile, path, serialize())
    if ok then notify(T("cfg_saved"), Color3.fromRGB(0,200,100)) end
    return ok
end
local function loadConfig(name)
    if not readfile or not name or name == "" then return false end
    local path = "vanka_configs/" .. name .. ".txt"
    local ok, exists = pcall(isfile, path)
    if not ok or not exists then
        notify(T("cfg_notfound"), Color3.fromRGB(255,60,60))
        return false
    end
    local ok2, data = pcall(readfile, path)
    if not ok2 or not data then return false end
    pcall(writefile, SAVE_FILE, data)
    notify(T("cfg_loaded") .. " (" .. name .. ")", Color3.fromRGB(0,200,100))
    return true
end

local function updatePreview()
    local refs = S.previewRefs
    if refs.nameLbl then refs.nameLbl.Visible = S.espName end
    if refs.distLbl then refs.distLbl.Visible = S.espDist end
    if refs.hpBg then refs.hpBg.Visible = S.espHealth end
    if refs.weaponLbl then refs.weaponLbl.Visible = S.espWeapon end
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
    nh.Size = UDim2.new(0, 320, 1, -40)
    nh.Position = UDim2.new(1, -340, 0, 20)
    nh.BackgroundTransparency = 1; nh.Parent = gui
    local nl = Instance.new("UIListLayout")
    nl.Padding = UDim.new(0, 8); nl.SortOrder = Enum.SortOrder.LayoutOrder; nl.Parent = nh

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 580, 0, 680)
    main.Position = UDim2.new(0, 20, 0.5, -340)
    main.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
    main.BorderSizePixel = 0; main.Active = true; main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    S.panel = main

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20,15,30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,14)),
    }
    bgGrad.Rotation = 45; bgGrad.Parent = main

    local mstk = Instance.new("UIStroke")
    mstk.Name = "MainStroke"; mstk.Color = S.panelColor
    mstk.Thickness = 2; mstk.Parent = main

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 56)
    top.BackgroundColor3 = Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0; top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1,0,0,28); tf.Position = UDim2.new(0,0,1,-28)
    tf.BackgroundColor3 = Color3.fromRGB(22,22,32); tf.BorderSizePixel = 0; tf.Parent = top

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0,40,0,40); li.Position = UDim2.new(0,14,0.5,-20)
        li.BackgroundTransparency = 1; li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit; li.Parent = top
        Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8)
    else
        local he = Instance.new("TextLabel")
        he.Size = UDim2.new(0,40,1,0); he.Position = UDim2.new(0,14,0,0)
        he.BackgroundTransparency = 1; he.Text = "V"
        he.TextColor3 = S.panelColor; he.TextSize = 26
        he.Font = Enum.Font.GothamBold; he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Name = "Title"
    ttl.Size = UDim2.new(1,-180,1,0); ttl.Position = UDim2.new(0,64,0,0)
    ttl.BackgroundTransparency = 1; ttl.Text = T("title") .. " v29"
    ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize = 16
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.Parent = top

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0,34,0,34); minB.Position = UDim2.new(1,-80,0,11)
    minB.BackgroundColor3 = Color3.fromRGB(55,55,70); minB.Text = "−"
    minB.TextColor3 = Color3.new(1,1,1); minB.TextSize = 20
    minB.Font = Enum.Font.GothamBold; minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 8)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0,34,0,34); closeB.Position = UDim2.new(1,-42,0,11)
    closeB.BackgroundColor3 = Color3.fromRGB(255,55,75); closeB.Text = "×"
    closeB.TextColor3 = Color3.new(1,1,1); closeB.TextSize = 20
    closeB.Font = Enum.Font.GothamBold; closeB.Parent = top
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 8)

    local openB = Instance.new("TextButton")
    openB.Size = UDim2.new(0,55,0,55); openB.Position = UDim2.new(0,15,0.5,-27)
    openB.BackgroundColor3 = S.panelColor; openB.Text = "V"
    openB.TextColor3 = Color3.new(1,1,1); openB.TextSize = 22
    openB.Font = Enum.Font.GothamBold; openB.Visible = false; openB.Parent = gui
    Instance.new("UICorner", openB).CornerRadius = UDim.new(0, 28)
    if LOGO then
        openB.Text = ""
        local oi = Instance.new("ImageLabel")
        oi.Size = UDim2.new(0,38,0,38); oi.Position = UDim2.new(0.5,-19,0.5,-19)
        oi.BackgroundTransparency = 1; oi.Image = LOGO
        oi.ScaleType = Enum.ScaleType.Fit; oi.Parent = openB
    end

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1,-24,0,46); tabBar.Position = UDim2.new(0,12,0,62)
    tabBar.BackgroundColor3 = Color3.fromRGB(20,20,28); tabBar.BorderSizePixel = 0; tabBar.Parent = main
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0, 4)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center; tl.Parent = tabBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,-24,1,-180); content.Position = UDim2.new(0,12,0,118)
    content.BackgroundTransparency = 1; content.Parent = main

    local tabs, pages = {}, {}
    local function switchTab(name)
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and S.panelColor or Color3.fromRGB(32,32,44)
        end
    end

    local function addTab(key, img, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,86,0,36)
        b.BackgroundColor3 = Color3.fromRGB(32,32,44); b.Text = ""; b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        tabs[key] = b
        if img then
            local im = Instance.new("ImageLabel")
            im.Size = UDim2.new(0,24,0,24); im.Position = UDim2.new(0.5,-12,0.5,-12)
            im.BackgroundTransparency = 1; im.Image = img
            im.ScaleType = Enum.ScaleType.Fit; im.Parent = b
        else
            b.Text = txt or key:upper()
            b.TextColor3 = Color3.fromRGB(170,170,190); b.TextSize = 11
            b.Font = Enum.Font.GothamBold
        end
        local p = Instance.new("ScrollingFrame")
        p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1
        p.BorderSizePixel = 0; p.ScrollBarThickness = 6
        p.ScrollBarImageColor3 = S.panelColor; p.CanvasSize = UDim2.new(0,0,0,0)
        p.Visible = false; p.Parent = content; pages[key] = p
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0,12); padding.PaddingBottom = UDim.new(0,30)
        padding.PaddingLeft = UDim.new(0,4); padding.PaddingRight = UDim.new(0,4)
        padding.Parent = p
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0,8); lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = p
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            p.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 60)
        end)
        b.MouseButton1Click:Connect(function() switchTab(key) end)
        return p
    end

    local function addBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,38); b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
        b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.TextSize = 13
        b.Font = Enum.Font.GothamMedium; b.TextWrapped = true; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then notify("Error: " .. tostring(err), Color3.fromRGB(255,60,60)) end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1,0,0,42); row.BackgroundColor3 = Color3.fromRGB(22,22,32)
        row.Text = ""; row.AutoButtonColor = false; row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-80,1,0); lbl.Position = UDim2.new(0,16,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230,230,240); lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0,48,0,24); sw.Position = UDim2.new(1,-60,0.5,-12)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
        sw.BorderSizePixel = 0; sw.Parent = row
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local kn = Instance.new("Frame")
        kn.Size = UDim2.new(0,18,0,18)
        kn.Position = initial and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
        kn.BackgroundColor3 = Color3.new(1,1,1); kn.BorderSizePixel = 0; kn.Parent = sw
        Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)
        local st = initial
        row.MouseButton1Click:Connect(function()
            st = not st
            TweenService:Create(sw, TweenInfo.new(0.15), {
                BackgroundColor3 = st and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
            }):Play()
            TweenService:Create(kn, TweenInfo.new(0.15), {
                Position = st and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
            }):Play()
            cb(st)
        end)
        return row
    end

    local function addLabel(parent, text)
        local w = Instance.new("Frame")
        w.Size = UDim2.new(1,0,0,30); w.BackgroundTransparency = 1; w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0,3,0,18); a.Position = UDim2.new(0,0,0.5,-9)
        a.BackgroundColor3 = S.panelColor; a.BorderSizePixel = 0; a.Parent = w
        Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,-14,1,0); l.Position = UDim2.new(0,12,0,0)
        l.BackgroundTransparency = 1; l.Text = text
        l.TextColor3 = S.panelColor; l.TextSize = 12
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = w
    end

    local tabMain     = addTab("main", IMG_MAIN)
    local tabVisual   = addTab("visual", IMG_VIS)
    local tabESP      = addTab("esp", nil, "ESP")
    local tabRage     = addTab("rage", IMG_RAGE)
    local tabPlayers  = addTab("players", nil, T("players"))
    local tabSettings = addTab("settings", nil, T("settings"))
    local tabConfigs  = addTab("configs", nil, T("configs"))
    switchTab("main")

    -- MAIN
    addLabel(tabMain, T("sheriff_sec"))
    addToggle(tabMain, T("autoshoot"), false, function(v)
        S.autoShootEnabled = v
        if v then startAutoShoot() else stopAutoShoot() end
    end)
    addToggle(tabMain, T("autokill"), false, function(v)
        S.autoKillEnabled = v
        if v then startAutoKillLoop() else stopAutoKillLoop() end
    end)
    addLabel(tabMain, T("farm_sec"))
    addToggle(tabMain, T("farm"), S.farmEnabled, function(v)
        S.farmEnabled = v; SaveData.farm = v; saveSettings()
        if v then startFarm() else stopFarm() end
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
    addToggle(tabMain, T("invisible"), S.invisibleEnabled, function(v) setInvisible(v) end)
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

    -- VISUAL
    addLabel(tabVisual, T("cross_sec"))
    addToggle(tabVisual, T("cross"), true, function(v) S.crosshair = v end)
    addToggle(tabVisual, T("fov"), true, function(v) S.fovCircle = v end)
    addToggle(tabVisual, T("hardaim"), true, function(v) S.hardAim = v end)
    addLabel(tabVisual, T("cross_style"))
    addBtn(tabVisual, T("cross_1"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=1 SaveData.cross_style=1 saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_2"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=2 SaveData.cross_style=2 saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_3"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=3 SaveData.cross_style=3 saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addLabel(tabVisual, T("cross_custom"))
    addBtn(tabVisual, "Загрузить custom.png", Color3.fromRGB(80,60,120), function()
        if isfile and getcustomasset then
            local ok, exists = pcall(isfile, "vanka_crosshair.png")
            if ok and exists then
                local ok2, asset = pcall(getcustomasset, "vanka_crosshair.png")
                if ok2 and asset and asset ~= "" then
                    S.crossImage = asset
                    SaveData.custom_cross = "vanka_crosshair.png"
                    saveSettings()
                    if _G.VankaUpdateCross then _G.VankaUpdateCross() end
                    notify(T("cross_loaded"), Color3.fromRGB(0,200,100))
                end
            else
                notify(T("cross_notfound"), Color3.fromRGB(255,60,60))
            end
        end
    end)
    addBtn(tabVisual, "Сбросить прицел", Color3.fromRGB(120,50,50), function()
        S.crossImage = nil
        SaveData.custom_cross = ""
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addLabel(tabVisual, T("move_sec"))
    addToggle(tabVisual, T("fly"), false, function(v) S.fly = v end)
    addToggle(tabVisual, T("noclip"), false, function(v) S.noclip = v end)
    addToggle(tabVisual, T("infjump"), false, function(v) S.infjump = v end)
    addToggle(tabVisual, T("speed"), S.speed50Enabled, function(v)
        S.speed50Enabled = v SaveData.speed50 = v saveSettings()
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

    -- ESP
    addLabel(tabESP, T("esp_sec"))
    addToggle(tabESP, T("esp_main"), S.espEnabled, function(v)
        S.espEnabled = v SaveData.esp = v saveSettings()
    end)
    addToggle(tabESP, T("esp_health"), S.espHealth, function(v)
        S.espHealth = v SaveData.esp_health = v saveSettings() updatePreview()
    end)
    addToggle(tabESP, T("esp_name"), S.espName, function(v)
        S.espName = v SaveData.esp_name = v saveSettings() updatePreview()
    end)
    addToggle(tabESP, T("esp_dist"), S.espDist, function(v)
        S.espDist = v SaveData.esp_dist = v saveSettings() updatePreview()
    end)
    addToggle(tabESP, T("esp_weapon"), S.espWeapon, function(v)
        S.espWeapon = v SaveData.esp_weapon = v saveSettings() updatePreview()
    end)
    addToggle(tabESP, T("esp_rainbow"), S.espRainbow, function(v)
        S.espRainbow = v SaveData.esp_rainbow = v saveSettings()
    end)

    addLabel(tabESP, T("esp_preview"))
    local previewFrame = Instance.new("Frame")
    previewFrame.Size = UDim2.new(1,0,0,260)
    previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,45)
    previewFrame.BorderSizePixel = 0; previewFrame.Parent = tabESP
    Instance.new("UICorner", previewFrame).CornerRadius = UDim.new(0, 10)
    if IMG_NOOB then
        local noobImg = Instance.new("ImageLabel")
        noobImg.Size = UDim2.new(0,140,0,140); noobImg.Position = UDim2.new(0.5,-70,0.5,-25)
        noobImg.BackgroundTransparency = 1; noobImg.Image = IMG_NOOB
        noobImg.ScaleType = Enum.ScaleType.Fit; noobImg.Parent = previewFrame
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "PrevName"; nameLbl.Size = UDim2.new(0,180,0,18)
        nameLbl.Position = UDim2.new(0.5,-90,0,30); nameLbl.BackgroundTransparency = 1
        nameLbl.Text = T("preview_name") .. " [Innocent]"
        nameLbl.TextColor3 = S.espColorInnocent
        nameLbl.TextStrokeTransparency = 0; nameLbl.TextSize = 13
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.Parent = previewFrame
        S.previewRefs.nameLbl = nameLbl
        local weaponLbl = Instance.new("TextLabel")
        weaponLbl.Name = "PrevWeapon"; weaponLbl.Size = UDim2.new(0,180,0,18)
        weaponLbl.Position = UDim2.new(0.5,-90,0,48); weaponLbl.BackgroundTransparency = 1
        weaponLbl.Text = "🔫 Gun"; weaponLbl.TextColor3 = Color3.fromRGB(80,180,255)
        weaponLbl.TextStrokeTransparency = 0; weaponLbl.TextSize = 13
        weaponLbl.Font = Enum.Font.GothamBold; weaponLbl.Parent = previewFrame
        S.previewRefs.weaponLbl = weaponLbl
        local hpBg = Instance.new("Frame")
        hpBg.Name = "PrevHpBg"; hpBg.Size = UDim2.new(0,120,0,8)
        hpBg.Position = UDim2.new(0.5,-60,0,68); hpBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        hpBg.BorderSizePixel = 0; hpBg.Parent = previewFrame
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 4)
        local hpFill = Instance.new("Frame")
        hpFill.Size = UDim2.new(1,0,1,0); hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
        hpFill.BorderSizePixel = 0; hpFill.Parent = hpBg
        Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 4)
        S.previewRefs.hpBg = hpBg
        local distLbl = Instance.new("TextLabel")
        distLbl.Name = "PrevDist"; distLbl.Size = UDim2.new(0,180,0,16)
        distLbl.Position = UDim2.new(0.5,-90,0,82); distLbl.BackgroundTransparency = 1
        distLbl.Text = "[" .. T("preview_dist") .. "]"; distLbl.TextColor3 = Color3.new(1,1,1)
        distLbl.TextStrokeTransparency = 0; distLbl.TextSize = 12
        distLbl.Font = Enum.Font.Gotham; distLbl.Parent = previewFrame
        S.previewRefs.distLbl = distLbl
        updatePreview()
    end

    -- RAGE
    addLabel(tabRage, T("aim_sec"))
    addToggle(tabRage, T("aimbot"), false, function(v) S.aimbot = v end)
    addToggle(tabRage, T("wallcheck"), S.wallCheck, function(v)
        S.wallCheck = v SaveData.wallcheck = v saveSettings()
    end)
    addLabel(tabRage, T("aim_part"))
    addBtn(tabRage, T("aim_head"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Head" SaveData.aim_part = "Head" saveSettings()
    end)
    addBtn(tabRage, T("aim_torso"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Torso" SaveData.aim_part = "Torso" saveSettings()
    end)
    addBtn(tabRage, T("aim_random"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Random" SaveData.aim_part = "Random" saveSettings()
    end)
    addLabel(tabRage, T("aim_smooth"))
    addBtn(tabRage, "Плавно (0.5)", Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.5 SaveData.aim_smooth = 0.5 saveSettings()
    end)
    addBtn(tabRage, "Средне (0.35)", Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.35 SaveData.aim_smooth = 0.35 saveSettings()
    end)
    addBtn(tabRage, "Резко (0.15)", Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.15 SaveData.aim_smooth = 0.15 saveSettings()
    end)
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
        S.spin=false S.autoPickup=false S.autoShootEnabled=false S.autoKillEnabled=false
        S.espEnabled=false S.speed50Enabled=false S.farmEnabled=false
        stopAutoShoot() stopAutoKillLoop() stopAutoPickup() stopFarm() clearHL()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed=16 h.JumpPower=50 end
        end
        notify(T("all_off"), Color3.fromRGB(255,60,60))
    end)

    -- PLAYERS
    addLabel(tabPlayers, T("plist"))
    local pList = Instance.new("Frame")
    pList.Size = UDim2.new(1,0,0,400)
    pList.BackgroundColor3 = Color3.fromRGB(16,16,24)
    pList.BorderSizePixel = 0; pList.Parent = tabPlayers
    Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 10)
    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1,-10,1,-10); pScroll.Position = UDim2.new(0,5,0,5)
    pScroll.BackgroundTransparency = 1; pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 5; pScroll.ScrollBarImageColor3 = S.panelColor
    pScroll.CanvasSize = UDim2.new(0,0,0,0); pScroll.Parent = pList
    local pLay = Instance.new("UIListLayout")
    pLay.Padding = UDim.new(0, 6); pLay.Parent = pScroll
    pLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pScroll.CanvasSize = UDim2.new(0,0,0, pLay.AbsoluteContentSize.Y + 8)
    end)
    local rows = {}
    local function rebuild()
        for _, r in pairs(rows) do r:Destroy() end
        rows = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1,-4,0,48)
                row.BackgroundColor3 = Color3.fromRGB(26,26,36); row.BorderSizePixel = 0
                row.Parent = pScroll
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0,38,0,38); av.Position = UDim2.new(0,5,0.5,-19)
                av.BackgroundColor3 = Color3.fromRGB(40,40,55); av.BorderSizePixel = 0
                av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                av.Parent = row
                Instance.new("UICorner", av).CornerRadius = UDim.new(0, 19)
                local tag = Instance.new("Frame")
                tag.Size = UDim2.new(0,6,0,30); tag.Position = UDim2.new(0,48,0.5,-15)
                tag.BackgroundColor3 = roleColor(plr); tag.BorderSizePixel = 0; tag.Parent = row
                Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)
                local nm = Instance.new("TextLabel")
                nm.Size = UDim2.new(1,-200,1,0); nm.Position = UDim2.new(0,62,0,0)
                nm.BackgroundTransparency = 1; nm.Text = plr.Name
                nm.TextColor3 = Color3.fromRGB(230,230,240); nm.TextSize = 12
                nm.Font = Enum.Font.GothamMedium
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd; nm.Parent = row
                local tpB = Instance.new("TextButton")
                tpB.Size = UDim2.new(0,42,0,30); tpB.Position = UDim2.new(1,-140,0.5,-15)
                tpB.BackgroundColor3 = Color3.fromRGB(40,100,200); tpB.Text = T("tp")
                tpB.TextColor3 = Color3.new(1,1,1); tpB.TextSize = 11
                tpB.Font = Enum.Font.GothamBold; tpB.Parent = row
                Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, 6)
                tpB.MouseButton1Click:Connect(function()
                    if plr.Character and LP.Character then
                        local t = plr.Character:FindFirstChild("HumanoidRootPart")
                        local m = LP.Character:FindFirstChild("HumanoidRootPart")
                        if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0,0,4) end) end
                    end
                end)
                local flB = Instance.new("TextButton")
                flB.Size = UDim2.new(0,76,0,30); flB.Position = UDim2.new(1,-94,0.5,-15)
                flB.BackgroundColor3 = Color3.fromRGB(180,20,100); flB.Text = T("fling")
                flB.TextColor3 = Color3.new(1,1,1); flB.TextSize = 11
                flB.Font = Enum.Font.GothamBold; flB.Parent = row
                Instance.new("UICorner", flB).CornerRadius = UDim.new(0, 6)
                flB.MouseButton1Click:Connect(function() fling(plr) end)
                rows[plr] = row
            end
        end
    end
    rebuild()
    Players.PlayerAdded:Connect(function() task.wait(1) rebuild() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.3) rebuild() end)

    -- SETTINGS
    addLabel(tabSettings, T("lang_sec"))
    addBtn(tabSettings, T("lang_ru"), Color3.fromRGB(50,80,150), function()
        LANG = "ru" SaveData.lang = "ru" saveSettings()
        ttl.Text = T("title") .. " v29"
        notify(T("saved") .. ": Русский", Color3.fromRGB(0,200,100))
    end)
    addBtn(tabSettings, T("lang_en"), Color3.fromRGB(50,80,150), function()
        LANG = "en" SaveData.lang = "en" saveSettings()
        ttl.Text = T("title") .. " v29"
        notify(T("saved") .. ": English", Color3.fromRGB(0,200,100))
    end)
    addBtn(tabSettings, T("lang_zh"), Color3.fromRGB(50,80,150), function()
        LANG = "zh" SaveData.lang = "zh" saveSettings()
        ttl.Text = T("title") .. " v29"
        notify(T("saved") .. ": 中文", Color3.fromRGB(0,200,100))
    end)
    addLabel(tabSettings, T("panel_sec"))
    local colorHolder = Instance.new("Frame")
    colorHolder.Size = UDim2.new(1,0,0,120)
    colorHolder.BackgroundColor3 = Color3.fromRGB(22,22,32)
    colorHolder.BorderSizePixel = 0; colorHolder.Parent = tabSettings
    Instance.new("UICorner", colorHolder).CornerRadius = UDim.new(0, 10)
    local colorGrid = Instance.new("UIGridLayout")
    colorGrid.CellSize = UDim2.new(0,50,0,50)
    colorGrid.CellPadding = UDim2.new(0,8,0,8); colorGrid.Parent = colorHolder
    local palette = {
        {255,0,100},{255,50,50},{255,150,0},{255,220,0},
        {100,255,0},{0,200,100},{0,220,220},{0,150,255},
        {100,100,255},{180,0,255},{255,0,200},{255,255,255},
        {50,50,50},{20,20,30},{150,75,0},{75,150,0},
    }
    for _, c in ipairs(palette) do
        local cBtn = Instance.new("TextButton")
        cBtn.BackgroundColor3 = Color3.fromRGB(c[1],c[2],c[3]); cBtn.Text = ""
        cBtn.Parent = colorHolder
        Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)
        cBtn.MouseButton1Click:Connect(function()
            S.panelColor = Color3.fromRGB(c[1],c[2],c[3])
            SaveData.panel_color = {c[1],c[2],c[3]}
            saveSettings()
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

    -- CONFIGS
    addLabel(tabConfigs, "Сохранение")
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1,0,0,38)
    nameBox.BackgroundColor3 = Color3.fromRGB(22,22,32)
    nameBox.BorderSizePixel = 0
    nameBox.PlaceholderText = T("cfg_name")
    nameBox.Text = ""
    nameBox.TextColor3 = Color3.new(1,1,1)
    nameBox.TextSize = 13
    nameBox.Font = Enum.Font.GothamMedium
    nameBox.Parent = tabConfigs
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", nameBox)
    pad.PaddingLeft = UDim.new(0, 12)
    addBtn(tabConfigs, T("cfg_save"), Color3.fromRGB(50,120,80), function()
        saveConfig(nameBox.Text)
    end)
    addBtn(tabConfigs, T("cfg_load"), Color3.fromRGB(80,80,150), function()
        if loadConfig(nameBox.Text) then
            task.wait(0.3)
            if _G.VankaPanel and _G.VankaPanel.Destroy then
                _G.VankaPanel.Destroy()
                loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
            end
        end
    end)
    addLabel(tabConfigs, "Готовые конфиги:")
    addBtn(tabConfigs, "По умолчанию", Color3.fromRGB(60,60,90), function()
        saveConfig("default")
    end)
    addBtn(tabConfigs, "Для аима", Color3.fromRGB(60,90,60), function()
        nameBox.Text = "aim"
        saveConfig("aim")
    end)
    addBtn(tabConfigs, "Для фарма", Color3.fromRGB(90,90,60), function()
        nameBox.Text = "farm"
        saveConfig("farm")
    end)

    closeB.MouseButton1Click:Connect(function()
        pcall(clearHL) stopAutoShoot() stopAutoKillLoop() stopAutoPickup() stopFarm()
        for _, bb in pairs(S.espBillboards) do pcall(function() bb:Destroy() end) end
        if S.invisibleConn then pcall(function() S.invisibleConn:Disconnect() end) end
        for _, c in ipairs(S.conns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        pcall(function() gui:Destroy() end)
        _G.VankaPanel = nil
    end)
    minB.MouseButton1Click:Connect(function()
        main.Visible = false; openB.Visible = true
    end)
    openB.MouseButton1Click:Connect(function()
        main.Visible = true; openB.Visible = false
    end)
    return gui
end

-- ОВЕРЛЕИ
local crossH, crossV, crossDot, crossCircle, crossImage, fovCircle
local function updateCrosshair()
    if not crossH then return end
    crossH.Visible = false; crossV.Visible = false
    crossDot.Visible = false
    if crossCircle then crossCircle.Visible = false end
    if crossImage then crossImage.Visible = false end
    if S.crossImage and S.crosshair then
        if not crossImage then
            crossImage = Instance.new("ImageLabel")
            crossImage.Size = UDim2.new(0, 32, 0, 32)
            crossImage.Position = UDim2.new(0.5, -16, 0.5, -16)
            crossImage.BackgroundTransparency = 1
            crossImage.Parent = S.gui
        end
        crossImage.Image = S.crossImage
        crossImage.Visible = true
        return
    end
    if not S.crosshair then return end
    if S.crossStyle == 1 then
        crossH.Visible = true; crossV.Visible = true
        crossH.BackgroundColor3 = S.crossColor
        crossV.BackgroundColor3 = S.crossColor
    elseif S.crossStyle == 2 then
        crossDot.Visible = true
        crossDot.BackgroundColor3 = S.crossColor
    elseif S.crossStyle == 3 and crossCircle then
        crossCircle.Visible = true
        crossCircle.UIStroke.Color = S.crossColor
    end
end
_G.VankaUpdateCross = updateCrosshair

local function createOverlays()
    crossH = Instance.new("Frame")
    crossH.Size = UDim2.new(0,20,0,2); crossH.Position = UDim2.new(0.5,-10,0.5,-1)
    crossH.BackgroundColor3 = S.crossColor; crossH.BorderSizePixel = 0; crossH.Parent = S.gui
    crossV = Instance.new("Frame")
    crossV.Size = UDim2.new(0,2,0,20); crossV.Position = UDim2.new(0.5,-1,0.5,-10)
    crossV.BackgroundColor3 = S.crossColor; crossV.BorderSizePixel = 0; crossV.Parent = S.gui
    crossDot = Instance.new("Frame")
    crossDot.Size = UDim2.new(0,5,0,5); crossDot.Position = UDim2.new(0.5,-2.5,0.5,-2.5)
    crossDot.BackgroundColor3 = S.crossColor; crossDot.BorderSizePixel = 0
    crossDot.Visible = false; crossDot.Parent = S.gui
    Instance.new("UICorner", crossDot).CornerRadius = UDim.new(1, 0)
    crossCircle = Instance.new("Frame")
    crossCircle.Size = UDim2.new(0,30,0,30); crossCircle.Position = UDim2.new(0.5,-15,0.5,-15)
    crossCircle.BackgroundTransparency = 1; crossCircle.Visible = false
    crossCircle.Parent = S.gui
    Instance.new("UICorner", crossCircle).CornerRadius = UDim.new(1, 0)
    local ccStroke = Instance.new("UIStroke")
    ccStroke.Color = S.crossColor; ccStroke.Thickness = 2; ccStroke.Parent = crossCircle
    fovCircle = Instance.new("Frame")
    fovCircle.AnchorPoint = Vector2.new(0.5,0.5)
    fovCircle.Size = UDim2.new(0,400,0,400); fovCircle.Position = UDim2.new(0.5,0,0.5,0)
    fovCircle.BackgroundTransparency = 1; fovCircle.Visible = false
    fovCircle.Parent = S.gui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    local fs = Instance.new("UIStroke")
    fs.Color = S.panelColor; fs.Thickness = 1.5; fs.Transparency = 0.35; fs.Parent = fovCircle
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
            else fovCircle.Visible = false end
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
                            if d < S.aimbotFOV and d < dist then dist = d cl = plr end
                        end
                    end
                end
            end
            if cl and cl.Character and cl.Character:FindFirstChild("Head") then
                S.aimT = cl
                local newCF = CFrame.new(Cam.CFrame.Position, cl.Character.Head.Position)
                if S.hardAim then Cam.CFrame = newCF
                else Cam.CFrame = Cam.CFrame:Lerp(newCF, 1 - S.aimSmooth) end
            else S.aimT = nil end
        end
        if S.spin and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed * dt * 60), 0) end
        end
        if S.roleHighlight then refreshHL() end
        if S.espEnabled then updateESP() end
        if S.invisibleEnabled then applyInvisible() end
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
        lf.Size = UDim2.new(1,0,1,0); lf.BackgroundColor3 = Color3.fromRGB(6,6,12)
        lf.BorderSizePixel = 0; lf.ZIndex = 500; lf.Parent = S.gui
        if LOGO then
            local li = Instance.new("ImageLabel")
            li.Size = UDim2.new(0,180,0,180); li.Position = UDim2.new(0.5,-90,0.5,-170)
            li.BackgroundTransparency = 1; li.Image = LOGO
            li.ScaleType = Enum.ScaleType.Fit; li.ZIndex = 501; li.Parent = lf
        end
        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1,0,0,40); lt.Position = UDim2.new(0,0,0.5,30)
        lt.BackgroundTransparency = 1; lt.Text = T("title")
        lt.TextColor3 = Color3.new(1,1,1); lt.TextSize = 28
        lt.Font = Enum.Font.GothamBold; lt.ZIndex = 501; lt.Parent = lf
        local ls = Instance.new("TextLabel")
        ls.Size = UDim2.new(1,0,0,22); ls.Position = UDim2.new(0,0,0.5,75)
        ls.BackgroundTransparency = 1; ls.Text = "0%"
        ls.TextColor3 = Color3.fromRGB(180,180,210); ls.TextSize = 15
        ls.Font = Enum.Font.GothamMedium; ls.ZIndex = 501; ls.Parent = lf
        local bb = Instance.new("Frame")
        bb.Size = UDim2.new(0,360,0,12); bb.Position = UDim2.new(0.5,-180,0.5,140)
        bb.BackgroundColor3 = Color3.fromRGB(28,28,40); bb.BorderSizePixel = 0
        bb.ZIndex = 501; bb.Parent = lf
        Instance.new("UICorner", bb).CornerRadius = UDim.new(1, 0)
        local bf = Instance.new("Frame")
        bf.Size = UDim2.new(0,0,1,0); bf.BackgroundColor3 = S.panelColor
        bf.BorderSizePixel = 0; bf.ZIndex = 502; bf.Parent = bb
        Instance.new("UICorner", bf).CornerRadius = UDim.new(1, 0)
        for i = 1, 100, 5 do
            ls.Text = i .. "%"
            local tw = TweenService:Create(bf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(i/100, 0, 1, 0)
            })
            tw:Play(); task.wait(0.08)
        end
        task.wait(0.4)
        TweenService:Create(lf, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        for _, c in ipairs(lf:GetDescendants()) do
            if c:IsA("TextLabel") then pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {TextTransparency = 1}):Play() end)
            elseif c:IsA("ImageLabel") then pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {ImageTransparency = 1}):Play() end)
            elseif c:IsA("Frame") then pcall(function() TweenService:Create(c, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play() end) end
        end
        task.wait(0.7); lf:Destroy()
    end)
end

_G.VankaPanel = {
    Destroy = function()
        for _, c in ipairs(S.conns) do
            pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
        clearHL() stopAutoShoot() stopAutoKillLoop() stopAutoPickup() stopFarm()
        if S.invisibleConn then pcall(function() S.invisibleConn:Disconnect() end) end
        for _, bb in pairs(S.espBillboards) do pcall(function() bb:Destroy() end) end
        if S.gui then pcall(function() S.gui:Destroy() end) end
        _G.VankaPanel = nil
    end
}

if S.speed50Enabled then startSpeed50Loop() end
if S.farmEnabled then startFarm() end

createGUI()
createOverlays()
mainLoop()
setupInfJump()
runLoading()

task.delay(5, function() notify(T("loaded"), Color3.fromRGB(0,200,100)) end)

print("[VANKA v29] OK")
