-- VANKA ADMIN v30 FINAL
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting     = game:GetService("Lighting")

local LP    = Players.LocalPlayer
local Cam   = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ═══════════════════════════════════════════════════════════════
-- ПОЛНЫЕ ЯЗЫКИ
-- ═══════════════════════════════════════════════════════════════
local LANG = "ru"
local L = {
    ru = {
        title="АДМИНКА ВАНЬКА",
        tab_main="ГЛАВНАЯ", tab_visual="ВИЗУАЛ", tab_esp="ESP", tab_rage="РЕЙДЖ",
        tab_players="ИГРОКИ", tab_settings="НАСТРОЙКИ", tab_configs="КОНФИГИ",
        role_murderer="Мардер", role_sheriff="Шериф", role_innocent="Невиновный",
        sec_sheriff="ШЕРИФ", autoshoot="Авто-выстрел в Мардера",
        sec_autokill="АВТО-КИЛЛ", autokill="Авто-убийство (нож, если Мардер)",
        sec_farm="ФАРМ", farm="Авто-фарм монет",
        sec_pickup="ПОДБОР", pickup="Подбор пистолета",
        sec_roles="РОЛИ", roles="Подсветка ролей",
        invisible="Невидимость", clear_inv="Очистить инвентарь",
        sec_cross="ПРИЦЕЛ", cross="Прицел", fov="Круг FOV", hardaim="Жёсткий аим",
        sec_cross_style="Стиль прицела", cross_1="Классик", cross_2="Точка", cross_3="Круг",
        sec_cross_custom="Свой прицел (PNG)", cross_load="Загрузить vanka_crosshair.png",
        cross_reset="Сбросить прицел",
        sec_move="ДВИЖЕНИЕ", fly="Полёт", noclip="Noclip", infjump="Бесконечный прыжок",
        speed="Скорость 50",
        sec_vis="ВИЗУАЛ", fullbright="Яркий свет",
        sec_esp="ESP", esp_main="Включить", esp_health="Здоровье", esp_name="Имя",
        esp_dist="Дистанция", esp_weapon="Оружие", esp_rainbow="Радужный режим",
        esp_preview="Превью:",
        esp_color_killer="Цвет Мардера", esp_color_sheriff="Цвет Шерифа",
        esp_color_innocent="Цвет Невиновного",
        sec_aim="АИМ", aimbot="Аимбот", wallcheck="Проверка стен",
        sec_aim_part="Часть тела", aim_head="Голова", aim_torso="Торс", aim_random="Случайно",
        sec_smooth="Плавность", smooth_slow="Плавно", smooth_mid="Средне", smooth_fast="Резко",
        kill_aim="Убить цель аима",
        sec_spin="СПИНБОТ", spin="Спинбот",
        sec_util="УТИЛИТЫ", respawn="Респавн", disable_all="ВЫКЛЮЧИТЬ ВСЁ",
        plist="СПИСОК ИГРОКОВ", tp="ТП", fling="ФЛИНГ",
        sec_lang="ЯЗЫК", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="ЦВЕТ ПАНЕЛИ", sec_reload="ПЕРЕЗАПУСК", reload="Перезапустить панель",
        sec_cfg_save="СОХРАНЕНИЕ", cfg_name="Имя конфига", cfg_save="Сохранить",
        cfg_load="Загрузить", cfg_presets="Готовые конфиги:",
        cfg_default="По умолчанию", cfg_aim="Для аима", cfg_farm="Для фарма",
        loaded="Загружено", saved="Сохранено",
        wait_gun="Жду пистолет", target="Цель", killed="Убил",
        fling_run="Флингаю", fling_done="Отфлингован", no_target="Нет цели",
        sheriff_off="Авто-выстрел ВЫКЛ", all_off="Всё выключено",
        farm_on="Фарм ВКЛ", farm_off="Фарм ВЫКЛ", farm_full="Сумка полная", farm_none="Монет нет",
        inv_on="Невидимость ВКЛ", inv_off="Невидимость ВЫКЛ",
        cross_loaded="Прицел загружен", cross_notfound="Файл не найден",
        cfg_saved="Конфиг сохранён", cfg_loaded="Конфиг загружен", cfg_notfound="Не найден",
        load_lang="Выберите язык", load_device="Выберите устройство",
        load_pc="Компьютер", load_mobile="Телефон", load_start="Загрузка...",
        preview_name="Игрок123", preview_dist="15м",
    },
    en = {
        title="VANKA ADMIN",
        tab_main="MAIN", tab_visual="VISUAL", tab_esp="ESP", tab_rage="RAGE",
        tab_players="PLAYERS", tab_settings="SETTINGS", tab_configs="CONFIGS",
        role_murderer="Murderer", role_sheriff="Sheriff", role_innocent="Innocent",
        sec_sheriff="SHERIFF", autoshoot="Auto Shoot (shoot Murderer)",
        sec_autokill="AUTO-KILL", autokill="Auto Kill (knife, if Murderer)",
        sec_farm="FARM", farm="Auto Farm Coins",
        sec_pickup="PICKUP", pickup="Gun pickup",
        sec_roles="ROLES", roles="Role highlight",
        invisible="Invisible", clear_inv="Clear inventory",
        sec_cross="CROSSHAIR", cross="Crosshair", fov="FOV circle", hardaim="Hard aim",
        sec_cross_style="Crosshair style", cross_1="Classic", cross_2="Dot", cross_3="Circle",
        sec_cross_custom="Custom crosshair (PNG)", cross_load="Load vanka_crosshair.png",
        cross_reset="Reset crosshair",
        sec_move="MOVEMENT", fly="Fly", noclip="Noclip", infjump="Infinite jump",
        speed="Speed 50",
        sec_vis="VISUAL", fullbright="Fullbright",
        sec_esp="ESP", esp_main="Enable", esp_health="Health", esp_name="Name",
        esp_dist="Distance", esp_weapon="Weapon", esp_rainbow="Rainbow mode",
        esp_preview="Preview:",
        esp_color_killer="Murderer Color", esp_color_sheriff="Sheriff Color",
        esp_color_innocent="Innocent Color",
        sec_aim="AIM", aimbot="Aimbot", wallcheck="Wall check",
        sec_aim_part="Aim part", aim_head="Head", aim_torso="Torso", aim_random="Random",
        sec_smooth="Smoothness", smooth_slow="Slow", smooth_mid="Medium", smooth_fast="Fast",
        kill_aim="Kill aim target",
        sec_spin="SPINBOT", spin="Spinbot",
        sec_util="UTILITIES", respawn="Respawn", disable_all="TURN OFF ALL",
        plist="PLAYERS LIST", tp="TP", fling="FLING",
        sec_lang="LANGUAGE", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="PANEL COLOR", sec_reload="RELOAD", reload="Reload panel",
        sec_cfg_save="SAVE", cfg_name="Config name", cfg_save="Save",
        cfg_load="Load", cfg_presets="Presets:",
        cfg_default="Default", cfg_aim="For aim", cfg_farm="For farm",
        loaded="Loaded", saved="Saved",
        wait_gun="Waiting for gun", target="Target", killed="Killed",
        fling_run="Flinging", fling_done="Flinged", no_target="No target",
        sheriff_off="Auto Shoot OFF", all_off="All disabled",
        farm_on="Farm ON", farm_off="Farm OFF", farm_full="Bag full", farm_none="No coins",
        inv_on="Invisible ON", inv_off="Invisible OFF",
        cross_loaded="Crosshair loaded", cross_notfound="File not found",
        cfg_saved="Config saved", cfg_loaded="Config loaded", cfg_notfound="Not found",
        load_lang="Select language", load_device="Select device",
        load_pc="PC", load_mobile="Mobile", load_start="Loading...",
        preview_name="Player123", preview_dist="15m",
    },
    zh = {
        title="VANKA 管理员",
        tab_main="主要", tab_visual="视觉", tab_esp="ESP", tab_rage="愤怒",
        tab_players="玩家", tab_settings="设置", tab_configs="配置",
        role_murderer="凶手", role_sheriff="警长", role_innocent="无辜",
        sec_sheriff="警长", autoshoot="自动射击 (射击凶手)",
        sec_autokill="自动击杀", autokill="自动击杀 (刀, 如果你是凶手)",
        sec_farm="农场", farm="自动农场",
        sec_pickup="拾取", pickup="拾取枪支",
        sec_roles="角色", roles="角色高亮",
        invisible="隐身", clear_inv="清空背包",
        sec_cross="准星", cross="准星", fov="FOV", hardaim="硬瞄准",
        sec_cross_style="准星样式", cross_1="经典", cross_2="点", cross_3="圆",
        sec_cross_custom="自定义准星", cross_load="加载 vanka_crosshair.png",
        cross_reset="重置准星",
        sec_move="移动", fly="飞行", noclip="穿墙", infjump="无限跳",
        speed="速度 50",
        sec_vis="视觉", fullbright="全亮",
        sec_esp="ESP", esp_main="启用", esp_health="生命", esp_name="名字",
        esp_dist="距离", esp_weapon="武器", esp_rainbow="彩虹",
        esp_preview="预览:",
        esp_color_killer="凶手颜色", esp_color_sheriff="警长颜色",
        esp_color_innocent="无辜颜色",
        sec_aim="瞄准", aimbot="自瞄", wallcheck="墙检",
        sec_aim_part="瞄准部位", aim_head="头", aim_torso="躯干", aim_random="随机",
        sec_smooth="平滑", smooth_slow="慢", smooth_mid="中", smooth_fast="快",
        kill_aim="击杀瞄准目标",
        sec_spin="旋转", spin="旋转机器人",
        sec_util="工具", respawn="重生", disable_all="关闭所有",
        plist="玩家列表", tp="传送", fling="甩飞",
        sec_lang="语言", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="面板颜色", sec_reload="重载", reload="重载面板",
        sec_cfg_save="保存", cfg_name="配置名", cfg_save="保存",
        cfg_load="加载", cfg_presets="预设:",
        cfg_default="默认", cfg_aim="瞄准", cfg_farm="农场",
        loaded="已加载", saved="已保存",
        wait_gun="等待枪支", target="目标", killed="击杀",
        fling_run="甩飞", fling_done="已甩飞", no_target="无目标",
        sheriff_off="自动射击关闭", all_off="全部关闭",
        farm_on="农场开", farm_off="农场关", farm_full="满包", farm_none="无硬币",
        inv_on="隐身开", inv_off="隐身关",
        cross_loaded="准星加载", cross_notfound="文件未找到",
        cfg_saved="已保存", cfg_loaded="已加载", cfg_notfound="未找到",
        load_lang="选择语言", load_device="选择设备",
        load_pc="电脑", load_mobile="手机", load_start="加载中...",
        preview_name="玩家123", preview_dist="15米",
    }
}
local function T(k) return L[LANG][k] or k end

-- ═════ СОХРАНЕНИЕ ═════
local SAVE_FILE = "vanka_settings_v30.txt"
local SaveData = {
    lang="", device="",
    esp=false, esp_health=true, esp_name=true, esp_dist=true, esp_weapon=true, esp_rainbow=false,
    esp_color_killer={255,60,60}, esp_color_sheriff={60,150,255}, esp_color_innocent={60,220,100},
    cross_style=1, cross_color={255,0,100}, panel_color={255,0,100},
    speed50=false, farm=false, invisible=false,
    aim_part="Head", aim_smooth=0.35, wallcheck=false, custom_cross="",
}
local function serialize()
    local s = ""
    local keys = {"lang","device","esp","esp_health","esp_name","esp_dist","esp_weapon","esp_rainbow","cross_style","speed50","farm","invisible","aim_part","aim_smooth","wallcheck","custom_cross"}
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
            elseif k == "device" then SaveData.device = v
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

-- Устройство (меньшие кнопки для мобилы)
local isMobile = SaveData.device == "mobile"
local PANEL_W = isMobile and 480 or 520
local PANEL_H = isMobile and 620 or 660
local BTN_H = isMobile and 32 or 34
local TOGGLE_H = isMobile and 34 or 36
local FONT_SZ = isMobile and 11 or 12
local HEADER_H = isMobile and 50 or 54

local S = {
    roleHighlight=false, roleHL={},
    aimbot=false, aimbotFOV=200, aimT=nil, hardAim=true,
    autoShootEnabled=false, autoShootThread=nil,
    autoKillEnabled=false, autoKillThread=nil, autoKillList={},
    autoPickup=false, sheriffThread=nil, lastSheriffPos=nil, lastSheriff=nil,
    farmEnabled=false, farmThread=nil,
    spin=false, spinSpeed=30,
    fly=false, noclip=false, infjump=false,
    crosshair=true, fovCircle=true,
    espEnabled=false, espBillboards={},
    speed50Enabled=false, speedThread=nil,
    invisibleEnabled=false, invisibleConn=nil,
    aimPart="Head", aimSmooth=0.35, wallCheck=false,
    conns={}, gui=nil,
    fullbright=false, oldLighting=nil,
    crossStyle=1,
    crossColor=Color3.fromRGB(255,0,100),
    panelColor=Color3.fromRGB(255,0,100),
    espHealth=true, espName=true, espDist=true, espWeapon=true, espRainbow=false,
    espColorKiller=Color3.fromRGB(255,60,60),
    espColorSheriff=Color3.fromRGB(60,150,255),
    espColorInnocent=Color3.fromRGB(60,220,100),
    previewRefs={}, crossImage=nil,
}

local function notify(text, color)
    color = color or S.panelColor
    if not S.gui then return end
    local h = S.gui:FindFirstChild("NotifHolder")
    if not h then return end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 44)
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

-- Переведённое имя роли
local function getRoleDisplay(plr)
    local r = getRole(plr)
    if r == "Murderer" then return T("role_murderer") end
    if r == "Sheriff" then return T("role_sheriff") end
    return T("role_innocent")
end

local function roleColor(plr)
    if S.espRainbow then
        return Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
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

-- ═════ РАБОЧИЙ ФЛИНГ (FE-техника) ═════
local FlingState = { busy = false }
local function feFling(target)
    if FlingState.busy then return end
    if not target or target == LP or not target.Character then
        notify(T("no_target"), Color3.fromRGB(255,60,60))
        return
    end
    local vChar = target.Character
    local vRoot = vChar:FindFirstChild("HumanoidRootPart")
    if not vRoot then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and hum and root) then return end

    FlingState.busy = true
    notify(T("fling_run") .. ": " .. target.Name, Color3.fromRGB(255,0,150))

    local savedCFrame = root.CFrame
    local savedWS, savedJP = hum.WalkSpeed, hum.JumpPower

    pcall(function() hum.Sit = true end)
    hum.WalkSpeed = 0
    hum.JumpPower = 0

    local massBackup = {}
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            massBackup[v] = v.Massless
            v.Massless = true
            v.CanCollide = false
        end
    end

    task.spawn(function()
        local BIG = 9e8
        local t0 = tick()
        while tick() - t0 < 0.4 do
            if not vRoot.Parent or not root.Parent then break end
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.new(math.random(-BIG, BIG), BIG, math.random(-BIG, BIG))
                    v.RotVelocity = Vector3.new(math.random(-BIG, BIG), math.random(-BIG, BIG), math.random(-BIG, BIG))
                end
            end
            pcall(function()
                root.CFrame = vRoot.CFrame + Vector3.new(0, 0.5, 0)
            end)
            RunService.Heartbeat:Wait()
        end

        for part, was in pairs(massBackup) do
            if part.Parent then
                part.Massless = was or false
                part.CanCollide = true
            end
        end
        pcall(function()
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.zero
                    v.RotVelocity = Vector3.zero
                end
            end
            hum.Sit = false
            hum.WalkSpeed = savedWS
            hum.JumpPower = savedJP
            root.CFrame = savedCFrame
        end)

        FlingState.busy = false
        task.wait(1.5)
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local y = target.Character.HumanoidRootPart.Position.Y
            if y > 500 then notify(target.Name .. " В КОСМОСЕ!", Color3.fromRGB(255,100,200))
            else notify(target.Name .. " " .. T("fling_done"), Color3.fromRGB(100,200,255)) end
        end
    end)
end

-- ═════ AUTO SHOOT (Шериф в Мардера) ═════
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
            if S.hardAim then Cam.CFrame = newCF
            else Cam.CFrame = Cam.CFrame:Lerp(newCF, 1 - S.aimSmooth) end
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

-- AUTO KILL (нож)
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
                    nameLbl.Text = plr.Name .. " [" .. getRoleDisplay(plr) .. "]"
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
    main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    main.Position = UDim2.new(0, 20, 0.5, -PANEL_H/2)
    main.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
    main.BorderSizePixel = 0; main.Active = true; main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

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
    top.Size = UDim2.new(1, 0, 0, HEADER_H)
    top.BackgroundColor3 = Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0; top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1,0,0,HEADER_H-28); tf.Position = UDim2.new(0,0,1,-(HEADER_H-28))
    tf.BackgroundColor3 = Color3.fromRGB(22,22,32); tf.BorderSizePixel = 0; tf.Parent = top

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0,36,0,36); li.Position = UDim2.new(0,12,0.5,-18)
        li.BackgroundTransparency = 1; li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit; li.Parent = top
        Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8)
    else
        local he = Instance.new("TextLabel")
        he.Size = UDim2.new(0,36,1,0); he.Position = UDim2.new(0,12,0,0)
        he.BackgroundTransparency = 1; he.Text = "V"
        he.TextColor3 = S.panelColor; he.TextSize = 24
        he.Font = Enum.Font.GothamBold; he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Name = "Title"
    ttl.Size = UDim2.new(1,-160,1,0); ttl.Position = UDim2.new(0,58,0,0)
    ttl.BackgroundTransparency = 1; ttl.Text = T("title")
    ttl.TextColor3 = Color3.new(1,1,1); ttl.TextSize = 15
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left; ttl.Parent = top

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0,30,0,30); minB.Position = UDim2.new(1,-72,0.5,-15)
    minB.BackgroundColor3 = Color3.fromRGB(55,55,70); minB.Text = "−"
    minB.TextColor3 = Color3.new(1,1,1); minB.TextSize = 18
    minB.Font = Enum.Font.GothamBold; minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 8)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0,30,0,30); closeB.Position = UDim2.new(1,-38,0.5,-15)
    closeB.BackgroundColor3 = Color3.fromRGB(255,55,75); closeB.Text = "×"
    closeB.TextColor3 = Color3.new(1,1,1); closeB.TextSize = 18
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
    tabBar.Size = UDim2.new(1,-20,0,42); tabBar.Position = UDim2.new(0,10,0,HEADER_H+6)
    tabBar.BackgroundColor3 = Color3.fromRGB(20,20,28); tabBar.BorderSizePixel = 0; tabBar.Parent = main
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal; tl.Padding = UDim.new(0, 3)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center; tl.Parent = tabBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,-20,1,-(HEADER_H+68)); content.Position = UDim2.new(0,10,0,HEADER_H+54)
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
        b.Size = UDim2.new(0, isMobile and 68 or 78, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(32,32,44); b.Text = ""; b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        tabs[key] = b
        if img then
            local im = Instance.new("ImageLabel")
            im.Size = UDim2.new(0,22,0,22); im.Position = UDim2.new(0.5,-11,0.5,-11)
            im.BackgroundTransparency = 1; im.Image = img
            im.ScaleType = Enum.ScaleType.Fit; im.Parent = b
        else
            b.Text = txt or key:upper()
            b.TextColor3 = Color3.fromRGB(170,170,190); b.TextSize = 10
            b.Font = Enum.Font.GothamBold
        end
        local p = Instance.new("ScrollingFrame")
        p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1
        p.BorderSizePixel = 0; p.ScrollBarThickness = 5
        p.ScrollBarImageColor3 = S.panelColor; p.CanvasSize = UDim2.new(0,0,0,0)
        p.Visible = false; p.Parent = content; pages[key] = p
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0,10); padding.PaddingBottom = UDim.new(0,20)
        padding.PaddingLeft = UDim.new(0,3); padding.PaddingRight = UDim.new(0,3)
        padding.Parent = p
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0,6); lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = p
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            p.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 40)
        end)
        b.MouseButton1Click:Connect(function() switchTab(key) end)
        return p
    end

    local function addBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,BTN_H); b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
        b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.TextSize = FONT_SZ
        b.Font = Enum.Font.GothamMedium; b.TextWrapped = true; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then notify("Error: " .. tostring(err), Color3.fromRGB(255,60,60)) end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1,0,0,TOGGLE_H); row.BackgroundColor3 = Color3.fromRGB(22,22,32)
        row.Text = ""; row.AutoButtonColor = false; row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-70,1,0); lbl.Position = UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency = 1; lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230,230,240); lbl.TextSize = FONT_SZ
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0,42,0,20); sw.Position = UDim2.new(1,-54,0.5,-10)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
        sw.BorderSizePixel = 0; sw.Parent = row
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local kn = Instance.new("Frame")
        kn.Size = UDim2.new(0,16,0,16)
        kn.Position = initial and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        kn.BackgroundColor3 = Color3.new(1,1,1); kn.BorderSizePixel = 0; kn.Parent = sw
        Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)
        local st = initial
        row.MouseButton1Click:Connect(function()
            st = not st
            TweenService:Create(sw, TweenInfo.new(0.15), {
                BackgroundColor3 = st and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
            }):Play()
            TweenService:Create(kn, TweenInfo.new(0.15), {
                Position = st and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
            }):Play()
            cb(st)
        end)
        return row
    end

    local function addLabel(parent, text)
        local w = Instance.new("Frame")
        w.Size = UDim2.new(1,0,0,26); w.BackgroundTransparency = 1; w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0,3,0,16); a.Position = UDim2.new(0,0,0.5,-8)
        a.BackgroundColor3 = S.panelColor; a.BorderSizePixel = 0; a.Parent = w
        Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,-12,1,0); l.Position = UDim2.new(0,10,0,0)
        l.BackgroundTransparency = 1; l.Text = text
        l.TextColor3 = S.panelColor; l.TextSize = FONT_SZ - 1
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = w
    end

    local tabMain     = addTab("main", IMG_MAIN)
    local tabVisual   = addTab("visual", IMG_VIS)
    local tabESP      = addTab("esp", nil, T("tab_esp"))
    local tabRage     = addTab("rage", IMG_RAGE)
    local tabPlayers  = addTab("players", nil, T("tab_players"))
    local tabSettings = addTab("settings", nil, T("tab_settings"))
    local tabConfigs  = addTab("configs", nil, T("tab_configs"))
    switchTab("main")

    -- MAIN
    addLabel(tabMain, T("sec_sheriff"))
    addToggle(tabMain, T("autoshoot"), false, function(v)
        S.autoShootEnabled = v
        if v then startAutoShoot() else stopAutoShoot() end
    end)
    addLabel(tabMain, T("sec_autokill"))
    addToggle(tabMain, T("autokill"), false, function(v)
        S.autoKillEnabled = v
        if v then startAutoKillLoop() else stopAutoKillLoop() end
    end)
    addLabel(tabMain, T("sec_farm"))
    addToggle(tabMain, T("farm"), false, function(v)
        S.farmEnabled = v
        if v then startFarm() else stopFarm() end
    end)
    addLabel(tabMain, T("sec_pickup"))
    addToggle(tabMain, T("pickup"), false, function(v)
        S.autoPickup = v
        if v then startAutoPickup() else stopAutoPickup() end
    end)
    addLabel(tabMain, T("sec_roles"))
    addToggle(tabMain, T("roles"), false, function(v)
        S.roleHighlight = v
        if v then refreshHL() else clearHL() end
    end)
    addToggle(tabMain, T("invisible"), false, function(v) setInvisible(v) end)
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
    addLabel(tabVisual, T("sec_cross"))
    addToggle(tabVisual, T("cross"), true, function(v) S.crosshair = v end)
    addToggle(tabVisual, T("fov"), true, function(v) S.fovCircle = v end)
    addToggle(tabVisual, T("hardaim"), true, function(v) S.hardAim = v end)
    addLabel(tabVisual, T("sec_cross_style"))
    addBtn(tabVisual, T("cross_1"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=1 saveSettings() if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_2"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=2 saveSettings() if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_3"), Color3.fromRGB(60,60,90), function()
        S.crossStyle=3 saveSettings() if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addLabel(tabVisual, T("sec_cross_custom"))
    addBtn(tabVisual, T("cross_load"), Color3.fromRGB(80,60,120), function()
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
            else notify(T("cross_notfound"), Color3.fromRGB(255,60,60)) end
        end
    end)
    addBtn(tabVisual, T("cross_reset"), Color3.fromRGB(120,50,50), function()
        S.crossImage = nil
        SaveData.custom_cross = ""
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addLabel(tabVisual, T("sec_move"))
    addToggle(tabVisual, T("fly"), false, function(v) S.fly = v end)
    addToggle(tabVisual, T("noclip"), false, function(v) S.noclip = v end)
    addToggle(tabVisual, T("infjump"), false, function(v) S.infjump = v end)
    addToggle(tabVisual, T("speed"), false, function(v)
        S.speed50Enabled = v
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
    addLabel(tabVisual, T("sec_vis"))
    addToggle(tabVisual, T("fullbright"), false, function(v)
        if v then
            if not S.oldLighting then
                S.oldLighting = {Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient}
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

    -- ESP
    addLabel(tabESP, T("sec_esp"))
    addToggle(tabESP, T("esp_main"), false, function(v) S.espEnabled = v end)
    addToggle(tabESP, T("esp_health"), true, function(v) S.espHealth = v updatePreview() end)
    addToggle(tabESP, T("esp_name"), true, function(v) S.espName = v updatePreview() end)
    addToggle(tabESP, T("esp_dist"), true, function(v) S.espDist = v updatePreview() end)
    addToggle(tabESP, T("esp_weapon"), true, function(v) S.espWeapon = v updatePreview() end)
    addToggle(tabESP, T("esp_rainbow"), false, function(v) S.espRainbow = v end)

    addLabel(tabESP, T("esp_preview"))
    local previewFrame = Instance.new("Frame")
    previewFrame.Size = UDim2.new(1,0,0,240)
    previewFrame.BackgroundColor3 = Color3.fromRGB(30,30,45)
    previewFrame.BorderSizePixel = 0; previewFrame.Parent = tabESP
    Instance.new("UICorner", previewFrame).CornerRadius = UDim.new(0, 10)
    if IMG_NOOB then
        local noobImg = Instance.new("ImageLabel")
        noobImg.Size = UDim2.new(0,130,0,130); noobImg.Position = UDim2.new(0.5,-65,0.5,-20)
        noobImg.BackgroundTransparency = 1; noobImg.Image = IMG_NOOB
        noobImg.ScaleType = Enum.ScaleType.Fit; noobImg.Parent = previewFrame
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "PrevName"; nameLbl.Size = UDim2.new(0,180,0,18)
        nameLbl.Position = UDim2.new(0.5,-90,0,26); nameLbl.BackgroundTransparency = 1
        nameLbl.Text = T("preview_name") .. " [" .. T("role_innocent") .. "]"
        nameLbl.TextColor3 = S.espColorInnocent
        nameLbl.TextStrokeTransparency = 0; nameLbl.TextSize = 13
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.Parent = previewFrame
        S.previewRefs.nameLbl = nameLbl
        local weaponLbl = Instance.new("TextLabel")
        weaponLbl.Name = "PrevWeapon"; weaponLbl.Size = UDim2.new(0,180,0,18)
        weaponLbl.Position = UDim2.new(0.5,-90,0,44); weaponLbl.BackgroundTransparency = 1
        weaponLbl.Text = "🔫 Gun"; weaponLbl.TextColor3 = Color3.fromRGB(80,180,255)
        weaponLbl.TextStrokeTransparency = 0; weaponLbl.TextSize = 13
        weaponLbl.Font = Enum.Font.GothamBold; weaponLbl.Parent = previewFrame
        S.previewRefs.weaponLbl = weaponLbl
        local hpBg = Instance.new("Frame")
        hpBg.Name = "PrevHpBg"; hpBg.Size = UDim2.new(0,120,0,8)
        hpBg.Position = UDim2.new(0.5,-60,0,64); hpBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        hpBg.BorderSizePixel = 0; hpBg.Parent = previewFrame
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 4)
        local hpFill = Instance.new("Frame")
        hpFill.Size = UDim2.new(1,0,1,0); hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
        hpFill.BorderSizePixel = 0; hpFill.Parent = hpBg
        Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 4)
        S.previewRefs.hpBg = hpBg
        local distLbl = Instance.new("TextLabel")
        distLbl.Name = "PrevDist"; distLbl.Size = UDim2.new(0,180,0,16)
        distLbl.Position = UDim2.new(0.5,-90,0,78); distLbl.BackgroundTransparency = 1
        distLbl.Text = "[" .. T("preview_dist") .. "]"; distLbl.TextColor3 = Color3.new(1,1,1)
        distLbl.TextStrokeTransparency = 0; distLbl.TextSize = 12
        distLbl.Font = Enum.Font.Gotham; distLbl.Parent = previewFrame
        S.previewRefs.distLbl = distLbl
        updatePreview()
    end

    -- RAGE
    addLabel(tabRage, T("sec_aim"))
    addToggle(tabRage, T("aimbot"), false, function(v) S.aimbot = v end)
    addToggle(tabRage, T("wallcheck"), false, function(v) S.wallCheck = v end)
    addLabel(tabRage, T("sec_aim_part"))
    addBtn(tabRage, T("aim_head"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Head"
    end)
    addBtn(tabRage, T("aim_torso"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Torso"
    end)
    addBtn(tabRage, T("aim_random"), Color3.fromRGB(60,60,90), function()
        S.aimPart = "Random"
    end)
    addLabel(tabRage, T("sec_smooth"))
    addBtn(tabRage, T("smooth_slow"), Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.5
    end)
    addBtn(tabRage, T("smooth_mid"), Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.35
    end)
    addBtn(tabRage, T("smooth_fast"), Color3.fromRGB(60,60,90), function()
        S.aimSmooth = 0.15
    end)
    addBtn(tabRage, T("kill_aim"), Color3.fromRGB(170,20,30), function()
        if S.aimT and S.aimT.Character then
            local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end)
    addLabel(tabRage, T("sec_spin"))
    addToggle(tabRage, T("spin"), false, function(v) S.spin = v end)
    addLabel(tabRage, T("sec_util"))
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
    pList.Size = UDim2.new(1,0,0,360)
    pList.BackgroundColor3 = Color3.fromRGB(16,16,24)
    pList.BorderSizePixel = 0; pList.Parent = tabPlayers
    Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 10)
    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1,-10,1,-10); pScroll.Position = UDim2.new(0,5,0,5)
    pScroll.BackgroundTransparency = 1; pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 5; pScroll.ScrollBarImageColor3 = S.panelColor
    pScroll.CanvasSize = UDim2.new(0,0,0,0); pScroll.Parent = pList
    local pLay = Instance.new("UIListLayout")
    pLay.Padding = UDim.new(0, 5); pLay.Parent = pScroll
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
                row.Size = UDim2.new(1,-4,0,42)
                row.BackgroundColor3 = Color3.fromRGB(26,26,36); row.BorderSizePixel = 0
                row.Parent = pScroll
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0,34,0,34); av.Position = UDim2.new(0,4,0.5,-17)
                av.BackgroundColor3 = Color3.fromRGB(40,40,55); av.BorderSizePixel = 0
                av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                av.Parent = row
                Instance.new("UICorner", av).CornerRadius = UDim.new(0, 17)
                local tag = Instance.new("Frame")
                tag.Size = UDim2.new(0,5,0,26); tag.Position = UDim2.new(0,42,0.5,-13)
                tag.BackgroundColor3 = roleColor(plr); tag.BorderSizePixel = 0; tag.Parent = row
                Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)
                local nm = Instance.new("TextLabel")
                nm.Size = UDim2.new(1,-170,1,0); nm.Position = UDim2.new(0,52,0,0)
                nm.BackgroundTransparency = 1; nm.Text = plr.Name
                nm.TextColor3 = Color3.fromRGB(230,230,240); nm.TextSize = 11
                nm.Font = Enum.Font.GothamMedium
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd; nm.Parent = row
                local tpB = Instance.new("TextButton")
                tpB.Size = UDim2.new(0,36,0,26); tpB.Position = UDim2.new(1,-120,0.5,-13)
                tpB.BackgroundColor3 = Color3.fromRGB(40,100,200); tpB.Text = T("tp")
                tpB.TextColor3 = Color3.new(1,1,1); tpB.TextSize = 10
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
                flB.Size = UDim2.new(0,76,0,26); flB.Position = UDim2.new(1,-80,0.5,-13)
                flB.BackgroundColor3 = Color3.fromRGB(180,20,100); flB.Text = T("fling")
                flB.TextColor3 = Color3.new(1,1,1); flB.TextSize = 10
                flB.Font = Enum.Font.GothamBold; flB.Parent = row
                Instance.new("UICorner", flB).CornerRadius = UDim.new(0, 6)
                flB.MouseButton1Click:Connect(function() feFling(plr) end)
                rows[plr] = row
            end
        end
    end
    rebuild()
    Players.PlayerAdded:Connect(function() task.wait(1) rebuild() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.3) rebuild() end)

    -- SETTINGS
    addLabel(tabSettings, T("sec_lang"))
    addBtn(tabSettings, T("lang_ru"), Color3.fromRGB(50,80,150), function()
        if writefile then
            local data = serialize()
            data = string.gsub(data, "lang=[^\n]*", "lang=ru")
            pcall(writefile, SAVE_FILE, data)
        end
        if _G.VankaPanel and _G.VankaPanel.Destroy then
            _G.VankaPanel.Destroy()
            task.wait(0.2)
            loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
        end
    end)
    addBtn(tabSettings, T("lang_en"), Color3.fromRGB(50,80,150), function()
        if writefile then
            local data = serialize()
            data = string.gsub(data, "lang=[^\n]*", "lang=en")
            pcall(writefile, SAVE_FILE, data)
        end
        if _G.VankaPanel and _G.VankaPanel.Destroy then
            _G.VankaPanel.Destroy()
            task.wait(0.2)
            loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
        end
    end)
    addBtn(tabSettings, T("lang_zh"), Color3.fromRGB(50,80,150), function()
        if writefile then
            local data = serialize()
            data = string.gsub(data, "lang=[^\n]*", "lang=zh")
            pcall(writefile, SAVE_FILE, data)
        end
        if _G.VankaPanel and _G.VankaPanel.Destroy then
            _G.VankaPanel.Destroy()
            task.wait(0.2)
            loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
        end
    end)

    addLabel(tabSettings, T("sec_reload"))
    addBtn(tabSettings, T("reload"), Color3.fromRGB(80,50,120), function()
        if _G.VankaPanel and _G.VankaPanel.Destroy then
            _G.VankaPanel.Destroy()
            task.wait(0.2)
            loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
        end
    end)

    addLabel(tabSettings, T("sec_panel"))
    local colorHolder = Instance.new("Frame")
    colorHolder.Size = UDim2.new(1,0,0,120)
    colorHolder.BackgroundColor3 = Color3.fromRGB(22,22,32)
    colorHolder.BorderSizePixel = 0; colorHolder.Parent = tabSettings
    Instance.new("UICorner", colorHolder).CornerRadius = UDim.new(0, 10)
    local colorGrid = Instance.new("UIGridLayout")
    colorGrid.CellSize = UDim2.new(0,48,0,48)
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
            mstk.Color = S.panelColor
            openB.BackgroundColor3 = S.panelColor
            pScroll.ScrollBarImageColor3 = S.panelColor
            for _, tab in pairs(tabs) do
                if tab.BackgroundColor3 ~= Color3.fromRGB(32,32,44) then
                    tab.BackgroundColor3 = S.panelColor
                end
            end
        end)
    end

    -- CONFIGS
    addLabel(tabConfigs, T("sec_cfg_save"))
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1,0,0,BTN_H)
    nameBox.BackgroundColor3 = Color3.fromRGB(22,22,32)
    nameBox.BorderSizePixel = 0
    nameBox.PlaceholderText = T("cfg_name")
    nameBox.Text = ""
    nameBox.TextColor3 = Color3.new(1,1,1)
    nameBox.TextSize = FONT_SZ
    nameBox.Font = Enum.Font.GothamMedium
    nameBox.Parent = tabConfigs
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 7)
    local pad = Instance.new("UIPadding", nameBox)
    pad.PaddingLeft = UDim.new(0, 12)
    addBtn(tabConfigs, T("cfg_save"), Color3.fromRGB(50,120,80), function()
        if not writefile or nameBox.Text == "" then return end
        if makefolder then pcall(makefolder, "vanka_configs") end
        local path = "vanka_configs/" .. nameBox.Text .. ".txt"
        pcall(writefile, path, serialize())
        notify(T("cfg_saved"), Color3.fromRGB(0,200,100))
    end)
    addBtn(tabConfigs, T("cfg_load"), Color3.fromRGB(80,80,150), function()
        if not readfile or nameBox.Text == "" then return end
        local path = "vanka_configs/" .. nameBox.Text .. ".txt"
        local ok, exists = pcall(isfile, path)
        if not ok or not exists then
            notify(T("cfg_notfound"), Color3.fromRGB(255,60,60))
            return
        end
        local ok2, data = pcall(readfile, path)
        if ok2 and data then
            pcall(writefile, SAVE_FILE, data)
            notify(T("cfg_loaded"), Color3.fromRGB(0,200,100))
            task.wait(0.5)
            if _G.VankaPanel and _G.VankaPanel.Destroy then
                _G.VankaPanel.Destroy()
                task.wait(0.2)
                loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
            end
        end
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
    crossH.Visible = false; crossV.Visible = false; crossDot.Visible = false
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

-- ═════ ЗАГРУЗОЧНЫЙ ЭКРАН С ВЫБОРОМ ЯЗЫКА И УСТРОЙСТВА ═════
local function showLoadScreen()
    local lf = Instance.new("Frame")
    lf.Size = UDim2.new(1,0,1,0); lf.BackgroundColor3 = Color3.fromRGB(6,6,12)
    lf.BorderSizePixel = 0; lf.ZIndex = 500; lf.Parent = S.gui

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0,140,0,140); li.Position = UDim2.new(0.5,-70,0.3,-70)
        li.BackgroundTransparency = 1; li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit; li.ZIndex = 501; li.Parent = lf
    end

    local lt = Instance.new("TextLabel")
    lt.Size = UDim2.new(1,0,0,40); lt.Position = UDim2.new(0,0,0.3,90)
    lt.BackgroundTransparency = 1; lt.Text = T("title")
    lt.TextColor3 = Color3.new(1,1,1); lt.TextSize = 28
    lt.Font = Enum.Font.GothamBold; lt.ZIndex = 501; lt.Parent = lf

    -- Если языка нет в сохранении — показать выбор
    if SaveData.lang == "" or SaveData.device == "" then
        local langTitle = Instance.new("TextLabel")
        langTitle.Size = UDim2.new(1,0,0,24); langTitle.Position = UDim2.new(0,0,0.5,-60)
        langTitle.BackgroundTransparency = 1; langTitle.Text = "Select language / Выберите язык / 选择语言"
        langTitle.TextColor3 = Color3.fromRGB(200,200,220); langTitle.TextSize = 14
        langTitle.Font = Enum.Font.GothamMedium; langTitle.ZIndex = 501; langTitle.Parent = lf

        local btnY = -20
        local btnRu = Instance.new("TextButton")
        btnRu.Size = UDim2.new(0,160,0,40); btnRu.Position = UDim2.new(0.5,-165,0.5,btnY)
        btnRu.BackgroundColor3 = Color3.fromRGB(50,80,150); btnRu.Text = "Русский"
        btnRu.TextColor3 = Color3.new(1,1,1); btnRu.TextSize = 14
        btnRu.Font = Enum.Font.GothamBold; btnRu.ZIndex = 501; btnRu.Parent = lf
        Instance.new("UICorner", btnRu).CornerRadius = UDim.new(0, 8)

        local btnEn = Instance.new("TextButton")
        btnEn.Size = UDim2.new(0,160,0,40); btnEn.Position = UDim2.new(0.5,5,0.5,btnY)
        btnEn.BackgroundColor3 = Color3.fromRGB(50,80,150); btnEn.Text = "English"
        btnEn.TextColor3 = Color3.new(1,1,1); btnEn.TextSize = 14
        btnEn.Font = Enum.Font.GothamBold; btnEn.ZIndex = 501; btnEn.Parent = lf
        Instance.new("UICorner", btnEn).CornerRadius = UDim.new(0, 8)

        local btnZh = Instance.new("TextButton")
        btnZh.Size = UDim2.new(0,160,0,40); btnZh.Position = UDim2.new(0.5,-80,0.5,btnY+50)
        btnZh.BackgroundColor3 = Color3.fromRGB(50,80,150); btnZh.Text = "中文"
        btnZh.TextColor3 = Color3.new(1,1,1); btnZh.TextSize = 14
        btnZh.Font = Enum.Font.GothamBold; btnZh.ZIndex = 501; btnZh.Parent = lf
        Instance.new("UICorner", btnZh).CornerRadius = UDim.new(0, 8)

        local function pickLang(l)
            SaveData.lang = l
            if writefile then
                local data = serialize()
                data = string.gsub(data, "lang=[^\n]*", "lang=" .. l)
                pcall(writefile, SAVE_FILE, data)
            end
            lf:Destroy()
            task.wait(0.2)
            if _G.VankaPanel and _G.VankaPanel.Destroy then
                _G.VankaPanel.Destroy()
                task.wait(0.2)
                loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
            end
        end

        btnRu.MouseButton1Click:Connect(function() pickLang("ru") end)
        btnEn.MouseButton1Click:Connect(function() pickLang("en") end)
        btnZh.MouseButton1Click:Connect(function() pickLang("zh") end)
    else
        -- Язык и устройство выбраны — показать прогресс загрузки
        local ls = Instance.new("TextLabel")
        ls.Size = UDim2.new(1,0,0,22); ls.Position = UDim2.new(0,0,0.5,30)
        ls.BackgroundTransparency = 1; ls.Text = T("load_start")
        ls.TextColor3 = Color3.fromRGB(180,180,210); ls.TextSize = 15
        ls.Font = Enum.Font.GothamMedium; ls.ZIndex = 501; ls.Parent = lf

        local bb = Instance.new("Frame")
        bb.Size = UDim2.new(0,320,0,10); bb.Position = UDim2.new(0.5,-160,0.5,60)
        bb.BackgroundColor3 = Color3.fromRGB(28,28,40); bb.BorderSizePixel = 0
        bb.ZIndex = 501; bb.Parent = lf
        Instance.new("UICorner", bb).CornerRadius = UDim.new(1, 0)
        local bf = Instance.new("Frame")
        bf.Size = UDim2.new(0,0,1,0); bf.BackgroundColor3 = S.panelColor
        bf.BorderSizePixel = 0; bf.ZIndex = 502; bf.Parent = bb
        Instance.new("UICorner", bf).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            for i = 1, 100, 5 do
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

-- Запуск
if SaveData.lang == "" or SaveData.device == "" then
    -- Сначала GUI для показа выбора языка
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "VankaSelect_" .. tostring(math.random(1000,9999))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent
    S.gui = gui
    showLoadScreen()
else
    createGUI()
    createOverlays()
    mainLoop()
    setupInfJump()
    if S.speed50Enabled then startSpeed50Loop() end
    task.delay(0.5, function() notify(T("loaded"), Color3.fromRGB(0,200,100)) end)
end

print("[VANKA v30] OK | Lang: " .. LANG .. " | Device: " .. (SaveData.device or "?"))
