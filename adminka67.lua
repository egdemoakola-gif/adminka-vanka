-- Vanka Admin Panel v46
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local shiftKeyAvailable = false
local IS_MOBILE = UIS.TouchEnabled and not UIS.MouseEnabled

local LANG = "ru"
local L = {
    ru = {
        title="АДМИНКА ВАНЬКА",
        tab_main="ГЛАВНАЯ", tab_visual="ВИЗУАЛ", tab_esp="ЕСП", tab_rage="РЕЙДЖ",
        tab_players="ИГРОКИ", tab_settings="НАСТРОЙКИ", tab_configs="КОНФИГИ",
        role_murderer="Мардер", role_sheriff="Шериф", role_innocent="Невиновный",
        sec_sheriff="ШЕРИФ", autoshoot="Авто-выстрел",
        sec_autokill="АВТО-КИЛЛ", autokill="Авто-нож",
        autoTpMurderer="Следование",
        sec_farm="ФАРМ", farm="Авто-фарм", farm_speed="Скорость фарма",
        sec_pickup="ПОДБОР", pickup="Подбор пистолета",
        sec_roles="РОЛИ", roles="Подсветка ролей",
        invisible="Инвиз", clear_inv="Очистить инвентарь",
        sec_cross="ПРИЦЕЛ", cross="Прицел", fov="FOV", hardaim="Хард аим",
        sec_cross_style="Стиль прицела", cross_1="Классик", cross_2="Точка", cross_3="Круг",
        sec_cross_custom="Свой прицел", cross_load="Загрузить PNG",
        cross_reset="Сбросить прицел",
        sec_move="ДВИЖЕНИЕ", fly="Флай", noclip="Ноклип", infjump="Беск. прыжок",
        speed="Спидхак", walkback="Ходьба задом",
        sec_sky="НЕБО",
        sec_vis="ВИЗУАЛ", fullbright="Фулбрайт",
        sec_esp="ЕСП", esp_main="Включить", esp_health="Здоровье", esp_name="Имя",
        esp_dist="Дистанция", esp_weapon="Оружие", esp_rainbow="Радуга",
        esp_preview="Превью:",
        sec_aim="АИМ", aimbot="Аимбот",
        sec_aim_part="Часть тела", aim_head="Голова", aim_torso="Торс", aim_random="Рандом",
        sec_smooth="Плавность", smooth_slow="Плавно", smooth_mid="Средне", smooth_fast="Резко",
        kill_aim="Килл аим",
        sec_trigger="ТРИГГЕР", triggerbot="Триггер-бот",
        trigger_delay="Задержка", trigger_range="Радиус (метры)",
        trigger_target="Часть тела", trigger_ready="Триггер готов",
        sec_spin="СПИНБОТ", spin="Спинбот",
        sec_antiaim="АНТИ-АИМ", antiaim="Анти-аим",
        sec_util="УТИЛИТЫ", respawn="Респавн", disable_all="ВЫКЛЮЧИТЬ ВСЁ",
        plist="СПИСОК ИГРОКОВ", tp="ТП", fling="ФЛИНГ",
        sec_fling="ФЛИНГ",
        sec_lang="ЯЗЫК", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="ЦВЕТ ПАНЕЛИ",
        sec_cfg_save="КОНФИГИ", cfg_name="Имя", cfg_save="Сохранить",
        cfg_load="Загрузить", cfg_presets="Пресеты:",
        cfg_default="Дефолт", cfg_aim="Аим", cfg_farm="Фарм",
        loaded="Загружено", saved="Сохранено",
        wait_gun="Жду пушку", target="Цель", killed="Килл",
        fling_run="Флинг", no_target="Нет цели",
        sheriff_off="Авто-выстрел ВЫКЛ", all_off="Всё выключено",
        farm_on="Фарм ВКЛ", farm_off="Фарм ВЫКЛ", farm_full="Сумка полная", farm_none="Нет монет",
        inv_on="Инвиз ВКЛ", inv_off="Инвиз ВЫКЛ",
        cross_loaded="Прицел загружен", cross_notfound="Файл не найден",
        cfg_saved="Сохранено", cfg_loaded="Загружено", cfg_notfound="Не найдено",
        preview_name="Игрок123", preview_dist="15м",
        lang_changed="Перезапуск...",
        size_saved="Размер сохранён",
        sec_lines="ЛИНИИ", lines="Линии",
        sec_hitbox="ХИТБОКС", hitbox="Хитбоксы",
        saved_msg="Сохранено",
        pickup_tp="ТП...",
        pickup_back="Вернулся",
        walkback_on="Ходьба задом ВКЛ", walkback_off="Ходьба задом ВЫКЛ",
        sky_cosmos="Космос", sky_galaxy="Галактика", sky_dawn="Рассвет",
        sky_sunset="Закат", sky_night="Ночное", sky_purple="Фиолет", sky_clear="Убрать небо",
    },
    en = {
        title="VANKA ADMIN",
        tab_main="MAIN", tab_visual="VISUAL", tab_esp="ESP", tab_rage="RAGE",
        tab_players="PLAYERS", tab_settings="SETTINGS", tab_configs="CONFIGS",
        role_murderer="Murderer", role_sheriff="Sheriff", role_innocent="Innocent",
        sec_sheriff="SHERIFF", autoshoot="Auto-shoot",
        sec_autokill="AUTO-KILL", autokill="Auto-knife",
        autoTpMurderer="Follow",
        sec_farm="FARM", farm="Auto-farm", farm_speed="Farm speed",
        sec_pickup="PICKUP", pickup="Gun pickup",
        sec_roles="ROLES", roles="Role highlight",
        invisible="Invisible", clear_inv="Clear inventory",
        sec_cross="CROSSHAIR", cross="Crosshair", fov="FOV", hardaim="Hard aim",
        sec_cross_style="Crosshair style", cross_1="Classic", cross_2="Dot", cross_3="Circle",
        sec_cross_custom="Custom crosshair", cross_load="Load PNG",
        cross_reset="Reset crosshair",
        sec_move="MOVEMENT", fly="Fly", noclip="Noclip", infjump="Inf jump",
        speed="Speedhack", walkback="Walk backwards",
        sec_sky="SKY",
        sec_vis="VISUAL", fullbright="Fullbright",
        sec_esp="ESP", esp_main="Enable", esp_health="Health", esp_name="Name",
        esp_dist="Distance", esp_weapon="Weapon", esp_rainbow="Rainbow",
        esp_preview="Preview:",
        sec_aim="AIM", aimbot="Aimbot",
        sec_aim_part="Aim part", aim_head="Head", aim_torso="Torso", aim_random="Random",
        sec_smooth="Smoothness", smooth_slow="Slow", smooth_mid="Medium", smooth_fast="Fast",
        kill_aim="Kill aim",
        sec_trigger="TRIGGER", triggerbot="Triggerbot",
        trigger_delay="Delay", trigger_range="Range (studs)",
        trigger_target="Hit part", trigger_ready="Trigger ready",
        sec_spin="SPINBOT", spin="Spinbot",
        sec_antiaim="ANTI-AIM", antiaim="Anti-aim",
        sec_util="UTILITIES", respawn="Respawn", disable_all="TURN OFF ALL",
        plist="PLAYERS", tp="TP", fling="FLING",
        sec_fling="FLING",
        sec_lang="LANGUAGE", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="PANEL COLOR",
        sec_cfg_save="CONFIGS", cfg_name="Name", cfg_save="Save",
        cfg_load="Load", cfg_presets="Presets:",
        cfg_default="Default", cfg_aim="Aim", cfg_farm="Farm",
        loaded="Loaded", saved="Saved",
        wait_gun="Waiting gun", target="Target", killed="Killed",
        fling_run="Fling", no_target="No target",
        sheriff_off="Auto-shoot OFF", all_off="All off",
        farm_on="Farm ON", farm_off="Farm OFF", farm_full="Bag full", farm_none="No coins",
        inv_on="Invisible ON", inv_off="Invisible OFF",
        cross_loaded="Crosshair loaded", cross_notfound="Not found",
        cfg_saved="Saved", cfg_loaded="Loaded", cfg_notfound="Not found",
        preview_name="Player123", preview_dist="15m",
        lang_changed="Restarting...",
        size_saved="Size saved",
        sec_lines="LINES", lines="Lines",
        sec_hitbox="HITBOX", hitboxes="Hitboxes",
        saved_msg="Saved",
        pickup_tp="TP...",
        pickup_back="Returned",
        walkback_on="Walk back ON", walkback_off="Walk back OFF",
        sky_cosmos="Cosmos", sky_galaxy="Galaxy", sky_dawn="Dawn",
        sky_sunset="Sunset", sky_night="Night", sky_purple="Purple", sky_clear="Clear sky",
    },
    zh = {
        title="VANKA 管理员",
        tab_main="主要", tab_visual="视觉", tab_esp="ESP", tab_rage="愤怒",
        tab_players="玩家", tab_settings="设置", tab_configs="配置",
        role_murderer="凶手", role_sheriff="警长", role_innocent="无辜",
        sec_sheriff="警长", autoshoot="自动射击",
        sec_autokill="自动击杀", autokill="自动刀",
        autoTpMurderer="跟踪",
        sec_farm="农场", farm="自动农场", farm_speed="农场速度",
        sec_pickup="拾取", pickup="拾取枪支",
        sec_roles="角色", roles="角色高亮",
        invisible="隐身", clear_inv="清空背包",
        sec_cross="准星", cross="准星", fov="FOV", hardaim="硬瞄准",
        sec_cross_style="样式", cross_1="经典", cross_2="点", cross_3="圆",
        sec_cross_custom="自定义准星", cross_load="加载 PNG",
        cross_reset="重置准星",
        sec_move="移动", fly="飞行", noclip="穿墙", infjump="无限跳",
        speed="加速", walkback="倒着走",
        sec_sky="天空",
        sec_vis="视觉", fullbright="全亮",
        sec_esp="ESP", esp_main="启用", esp_health="生命", esp_name="名字",
        esp_dist="距离", esp_weapon="武器", esp_rainbow="彩虹",
        esp_preview="预览:",
        sec_aim="瞄准", aimbot="自瞄",
        sec_aim_part="瞄准部位", aim_head="头", aim_torso="躯干", aim_random="随机",
        sec_smooth="平滑", smooth_slow="慢", smooth_mid="中", smooth_fast="快",
        kill_aim="击杀瞄准",
        sec_trigger="扳机", triggerbot="扳机机器人",
        trigger_delay="延迟", trigger_range="半径 (米)",
        trigger_target="部位", trigger_ready="扳机就绪",
        sec_spin="旋转", spin="旋转机器人",
        sec_antiaim="防瞄准", antiaim="防瞄准",
        sec_util="工具", respawn="重生", disable_all="关闭所有",
        plist="玩家", tp="传送", fling="甩飞",
        sec_fling="甩飞",
        sec_lang="语言", lang_ru="Русский", lang_en="English", lang_zh="中文",
        sec_panel="面板颜色",
        sec_cfg_save="配置", cfg_name="名字", cfg_save="保存",
        cfg_load="加载", cfg_presets="预设:",
        cfg_default="默认", cfg_aim="瞄准", cfg_farm="农场",
        loaded="已加载", saved="已保存",
        wait_gun="等待枪支", target="目标", killed="击杀",
        fling_run="甩飞", no_target="无目标",
        sheriff_off="自动射击关", all_off="全部关闭",
        farm_on="农场开", farm_off="农场关", farm_full="满包", farm_none="无硬币",
        inv_on="隐身开", inv_off="隐身关",
        cross_loaded="准星加载", cross_notfound="未找到",
        cfg_saved="已保存", cfg_loaded="已加载", cfg_notfound="未找到",
        preview_name="玩家123", preview_dist="15米",
        lang_changed="重启中...",
        size_saved="尺寸已保存",
        sec_lines="线", lines="线",
        sec_hitbox="碰撞箱", hitbox="碰撞箱",
        saved_msg="已保存",
        pickup_tp="传送...",
        pickup_back="已返回",
        walkback_on="倒着走开", walkback_off="倒着走关",
        sky_cosmos="宇宙", sky_galaxy="银河", sky_dawn="黎明",
        sky_sunset="日落", sky_night="夜晚", sky_purple="紫色", sky_clear="清除天空",
    }
}

local function T(k) return L[LANG][k] or k end

local function detectDevice()
    local touch = UIS.TouchEnabled
    local keyboard = UIS.KeyboardEnabled
    local mouse = UIS.MouseEnabled
    if keyboard and mouse and not touch then
        return "pc"
    elseif touch and not keyboard then
        local s = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0)
        if s.X >= 900 or s.Y >= 700 then
            return "tablet"
        end
        return "mobile"
    elseif touch and keyboard then
        return "tablet"
    end
    return "pc"
end

local SAVE_FILE = "vanka_settings_v46.txt"
local SaveData = {
    lang = "ru", device = "",
    panel_w = 540, panel_h = 660, panel_x = 20, panel_y = 0,
    esp = false, esp_health = true, esp_name = true, esp_dist = true, esp_weapon = true, esp_rainbow = false,
    esp_color_killer = {255, 60, 60}, esp_color_sheriff = {60, 150, 255}, esp_color_innocent = {60, 220, 100},
    cross_style = 1, cross_color = {255, 0, 100}, panel_color = {255, 0, 100},
    speed50 = false, speed_value = 50, farm = false, invisible = false,
    aim_part = "Head", aim_smooth = 0.35, wallcheck = false, custom_cross = "",
    autoshoot = false, autokill = false, autotp = false, pickup = false, roles = false,
    cross = true, fov = true, hardaim = true, fly = false, noclip = false, infjump = false,
    fullbright = false, aimbot = false, spin = false,
    hitbox = false, lines = false,
    antiaim = false,
    walkback = false,
    sky_name = "",
    triggerbot = false, trigger_delay = 0.05, trigger_range = 200, trigger_target = "Head",
    farm_speed = 80,
}

local function serialize()
    local s = ""
    local keys = {
        "lang", "device", "panel_w", "panel_h", "panel_x", "panel_y",
        "esp", "esp_health", "esp_name", "esp_dist", "esp_weapon", "esp_rainbow",
        "cross_style", "speed50", "speed_value", "farm", "invisible",
        "aim_part", "aim_smooth", "wallcheck", "custom_cross",
        "autoshoot", "autokill", "autotp", "pickup", "roles",
        "cross", "fov", "hardaim", "fly", "noclip", "infjump",
        "fullbright", "aimbot", "spin", "hitbox", "lines", "antiaim", "walkback", "sky_name",
        "triggerbot", "trigger_delay", "trigger_range", "trigger_target", "farm_speed"
    }
    for _, k in ipairs(keys) do
        local v = SaveData[k]
        if type(v) == "boolean" then
            s = s .. k .. "=" .. tostring(v) .. "\n"
        elseif type(v) == "number" then
            s = s .. k .. "=" .. tostring(v) .. "\n"
        elseif type(v) == "string" then
            s = s .. k .. "=" .. v .. "\n"
        end
    end
    s = s .. "cross_color=" .. table.concat(SaveData.cross_color, ",") .. "\n"
    s = s .. "panel_color=" .. table.concat(SaveData.panel_color, ",") .. "\n"
    s = s .. "esp_color_killer=" .. table.concat(SaveData.esp_color_killer, ",") .. "\n"
    s = s .. "esp_color_sheriff=" .. table.concat(SaveData.esp_color_sheriff, ",") .. "\n"
    s = s .. "esp_color_innocent=" .. table.concat(SaveData.esp_color_innocent, ",") .. "\n"
    return s
end

local function saveSettings()
    if writefile then
        pcall(writefile, SAVE_FILE, serialize())
    end
end

local function loadSettings()
    if not readfile or not isfile then return end
    local ok = pcall(isfile, SAVE_FILE)
    if not ok or not isfile(SAVE_FILE) then return end
    local ok2, data = pcall(readfile, SAVE_FILE)
    if not ok2 or not data then return end
    for line in string.gmatch(data, "[^\n]+") do
        local k, v = string.match(line, "([%w_]+)=(.+)")
        if k and v then
            if k == "lang" then LANG = v
            elseif k == "device" then SaveData.device = v
            elseif k == "panel_w" then SaveData.panel_w = tonumber(v) or 540
            elseif k == "panel_h" then SaveData.panel_h = tonumber(v) or 660
            elseif k == "panel_x" then SaveData.panel_x = tonumber(v) or 20
            elseif k == "panel_y" then SaveData.panel_y = tonumber(v) or 0
            elseif k == "esp" then SaveData.esp = (v == "true")
            elseif k == "esp_health" then SaveData.esp_health = (v == "true")
            elseif k == "esp_name" then SaveData.esp_name = (v == "true")
            elseif k == "esp_dist" then SaveData.esp_dist = (v == "true")
            elseif k == "esp_weapon" then SaveData.esp_weapon = (v == "true")
            elseif k == "esp_rainbow" then SaveData.esp_rainbow = (v == "true")
            elseif k == "autoshoot" then SaveData.autoshoot = (v == "true")
            elseif k == "autokill" then SaveData.autokill = (v == "true")
            elseif k == "autotp" then SaveData.autotp = (v == "true")
            elseif k == "pickup" then SaveData.pickup = (v == "true")
            elseif k == "roles" then SaveData.roles = (v == "true")
            elseif k == "cross" then SaveData.cross = (v == "true")
            elseif k == "fov" then SaveData.fov = (v == "true")
            elseif k == "hardaim" then SaveData.hardaim = (v == "true")
            elseif k == "fly" then SaveData.fly = (v == "true")
            elseif k == "noclip" then SaveData.noclip = (v == "true")
            elseif k == "infjump" then SaveData.infjump = (v == "true")
            elseif k == "fullbright" then SaveData.fullbright = (v == "true")
            elseif k == "aimbot" then SaveData.aimbot = (v == "true")
            elseif k == "spin" then SaveData.spin = (v == "true")
            elseif k == "hitbox" then SaveData.hitbox = (v == "true")
            elseif k == "lines" then SaveData.lines = (v == "true")
            elseif k == "antiaim" then SaveData.antiaim = (v == "true")
            elseif k == "walkback" then SaveData.walkback = (v == "true")
            elseif k == "sky_name" then SaveData.sky_name = v
            elseif k == "speed50" then SaveData.speed50 = (v == "true")
            elseif k == "speed_value" then SaveData.speed_value = tonumber(v) or 50
            elseif k == "farm" then SaveData.farm = (v == "true")
            elseif k == "farm_speed" then SaveData.farm_speed = tonumber(v) or 80
            elseif k == "invisible" then SaveData.invisible = (v == "true")
            elseif k == "wallcheck" then SaveData.wallcheck = (v == "true")
            elseif k == "cross_style" then SaveData.cross_style = tonumber(v) or 1
            elseif k == "aim_smooth" then SaveData.aim_smooth = tonumber(v) or 0.35
            elseif k == "aim_part" then SaveData.aim_part = v
            elseif k == "custom_cross" then SaveData.custom_cross = v
            elseif k == "triggerbot" then SaveData.triggerbot = (v == "true")
            elseif k == "trigger_delay" then SaveData.trigger_delay = tonumber(v) or 0.05
            elseif k == "trigger_range" then SaveData.trigger_range = tonumber(v) or 200
            elseif k == "trigger_target" then SaveData.trigger_target = v
            elseif k == "cross_color" then
                local r, g, b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.cross_color = {tonumber(r), tonumber(g), tonumber(b)} end
            elseif k == "panel_color" then
                local r, g, b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.panel_color = {tonumber(r), tonumber(g), tonumber(b)} end
            elseif k == "esp_color_killer" then
                local r, g, b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_killer = {tonumber(r), tonumber(g), tonumber(b)} end
            elseif k == "esp_color_sheriff" then
                local r, g, b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_sheriff = {tonumber(r), tonumber(g), tonumber(b)} end
            elseif k == "esp_color_innocent" then
                local r, g, b = string.match(v, "(%d+),(%d+),(%d+)")
                if r then SaveData.esp_color_innocent = {tonumber(r), tonumber(g), tonumber(b)} end
            end
        end
    end
end
loadSettings()

local GH = "https://raw.githubusercontent.com/egdemoakola-gif/adminka-vanka/main/"
local function downloadImg(name)
    local file = "vanka_" .. name
    if isfile and getcustomasset then
        if isfile(file) then
            local ok, a = pcall(getcustomasset, file)
            if ok and a and a ~= "" then
                return a
            end
        end
    end
    if writefile and getcustomasset then
        local ok, data = pcall(function() return game:HttpGet(GH .. name, true) end)
        if ok and data and #data > 100 then
            pcall(writefile, file, data)
            local ok2, a = pcall(getcustomasset, file)
            if ok2 and a and a ~= "" then
                return a
            end
        end
    end
    return nil
end

local LOGO = downloadImg("vanya.png")
local IMG_MAIN = downloadImg("main.png")
local IMG_VIS = downloadImg("visial.png")
local IMG_RAGE = downloadImg("rage.png")
local IMG_NOOB = downloadImg("Roblox-Noob-Blocky-Avatar-Transparent-PNG.png")

local detectedDevice = SaveData.device
if detectedDevice == "" or detectedDevice == nil then
    detectedDevice = detectDevice()
    SaveData.device = detectedDevice
    saveSettings()
end

local isMobile = (detectedDevice == "mobile" or detectedDevice == "tablet")
local PANEL_W = math.clamp(SaveData.panel_w or 540, 400, 1200)
local PANEL_H = math.clamp(SaveData.panel_h or 660, 400, 1200)
local BTN_H = isMobile and 32 or 34
local TOGGLE_H = isMobile and 34 or 36
local FONT_SZ = isMobile and 11 or 12
local HEADER_H = isMobile and 50 or 54
local FARM_SPEED = SaveData.farm_speed or 80

local S = {
    roleHighlight = SaveData.roles, roleHL = {},
    aimbot = SaveData.aimbot, aimbotFOV = 200, aimT = nil, hardAim = SaveData.hardaim,
    autoShootEnabled = SaveData.autoshoot, autoShootThread = nil,
    autoKillEnabled = SaveData.autokill, autoKillThread = nil, autoKillList = {}, autoKillLoopThread = nil,
    autoTpEnabled = SaveData.autotp, autoTpThread = nil,
    autoPickup = SaveData.pickup, sheriffThread = nil, lastSheriffPos = nil, lastSheriff = nil,
    farmEnabled = SaveData.farm, farmThread = nil,
    spin = SaveData.spin, spinSpeed = 30,
    fly = SaveData.fly, noclip = SaveData.noclip, infjump = SaveData.infjump,
    flyBV = nil, flySpeedValue = 50,
    crosshair = SaveData.cross, fovCircle = SaveData.fov,
    espEnabled = SaveData.esp, espBillboards = {},
    speed50Enabled = SaveData.speed50, speedThread = nil, speedValue = SaveData.speed_value or 50,
    speedRespawnConn = nil,
    invisibleEnabled = SaveData.invisible, invisibleConn = nil,
    aimPart = SaveData.aim_part or "Head",
    aimSmooth = SaveData.aim_smooth or 0.35,
    wallCheck = SaveData.wallcheck or false,
    conns = {}, gui = nil, panel = nil,
    fullbright = SaveData.fullbright, oldLighting = nil,
    crossStyle = SaveData.cross_style or 1,
    crossColor = Color3.fromRGB(SaveData.cross_color[1], SaveData.cross_color[2], SaveData.cross_color[3]),
    panelColor = Color3.fromRGB(SaveData.panel_color[1], SaveData.panel_color[2], SaveData.panel_color[3]),
    espHealth = SaveData.esp_health, espName = SaveData.esp_name,
    espDist = SaveData.esp_dist, espWeapon = SaveData.esp_weapon, espRainbow = SaveData.esp_rainbow,
    espColorKiller = Color3.fromRGB(SaveData.esp_color_killer[1], SaveData.esp_color_killer[2], SaveData.esp_color_killer[3]),
    espColorSheriff = Color3.fromRGB(SaveData.esp_color_sheriff[1], SaveData.esp_color_sheriff[2], SaveData.esp_color_sheriff[3]),
    espColorInnocent = Color3.fromRGB(SaveData.esp_color_innocent[1], SaveData.esp_color_innocent[2], SaveData.esp_color_innocent[3]),
    previewRefs = {}, crossImage = nil,
    flingRunning = false, flingThread = nil, flingConns = {}, flingTargetName = "",
    hitbox = SaveData.hitbox, lines = SaveData.lines,
    espLines = {}, linesHolder = nil,
    antiAim = SaveData.antiaim or false,
    pickupBusy = false,
    flingCamConn = nil,
    walkBack = SaveData.walkback or false, walkBackThread = nil,
    skyData = nil, skyAtmo = nil,
    shiftForced = false,
    triggerbot = SaveData.triggerbot, triggerDelay = SaveData.trigger_delay or 0.05,
    triggerRange = SaveData.trigger_range or 200, triggerTarget = SaveData.trigger_target or "Head",
    triggerThread = nil, triggerConn = nil,
    _aimFireConn = nil,
}

local function notify(text, color)
    color = color or Color3.fromRGB(255, 0, 100)
    if not S.gui then return end
    local h = S.gui:FindFirstChild("NotifHolder")
    if not h then return end
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 260, 0, 40)
    n.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    n.BorderSizePixel = 0
    n.Parent = h
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1.5
    s.Parent = n
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = n
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -14, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 12
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.Parent = n
    n.Position = UDim2.new(1, 280, 0, 0)
    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(3, function()
        local t = TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1, 280, 0, 0)})
        t:Play()
        t.Completed:Connect(function() n:Destroy() end)
    end)
end

local function getRole(plr)
    if not plr then return "Innocent" end
    local backpack = plr:FindFirstChildOfClass("Backpack")
    local character = plr.Character

    if backpack then
        if backpack:FindFirstChild("Knife") then return "Murderer" end
        if backpack:FindFirstChild("Gun") then return "Sheriff" end
    end
    if character then
        if character:FindFirstChild("Knife") then return "Murderer" end
        if character:FindFirstChild("Gun") then return "Sheriff" end
    end
    return "Innocent"
end

local function getRoleDisplay(plr)
    local r = getRole(plr)
    if r == "Murderer" then
        return T("role_murderer")
    end
    if r == "Sheriff" then
        return T("role_sheriff")
    end
    return T("role_innocent")
end

local function roleColor(plr)
    if S.espRainbow then
        return Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
    end
    local r = getRole(plr)
    if r == "Murderer" then
        return S.espColorKiller
    end
    if r == "Sheriff" then
        return S.espColorSheriff
    end
    return S.espColorInnocent
end

local function isGun(t)
    if not t or not t.Name then return false end
    local n = string.lower(t.Name)
    return string.find(n, "gun") or string.find(n, "pistol") or string.find(n, "revolver")
end

local function isKnife(t)
    if not t or not t.Name then return false end
    local n = string.lower(t.Name)
    return string.find(n, "knife") or string.find(n, "dagger") or string.find(n, "sword")
end

local function getToolInHand(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChildOfClass("Tool")
end

local function getHandPart(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChild("RightHand")
        or plr.Character:FindFirstChild("Right Arm")
        or plr.Character:FindFirstChild("LeftHand")
        or plr.Character:FindFirstChild("Left Arm")
end

local function hasGunInHand()
    if not LP.Character then return false end
    local t = LP.Character:FindFirstChildOfClass("Tool")
    return t and isGun(t)
end

local function hasGunAnywhere()
    if hasGunInHand() then
        return true
    end
    if not LP.Backpack then
        return false
    end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and isGun(t) then
            return true
        end
    end
    return false
end

local function equipGun()
    if not LP.Backpack or not LP.Character then
        return false
    end
    local hm = LP.Character:FindFirstChildOfClass("Humanoid")
    if not hm then
        return false
    end
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
            if t:IsA("Tool") and isKnife(t) then
                return t
            end
        end
    end
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and isKnife(t) then
                return t
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
        if hm then
            pcall(function() hm:EquipTool(k) end)
            task.wait(0.15)
        end
    end
    return k
end

local function getAimPart(tChar)
    if not tChar then return nil end
    if S.aimPart == "Random" then
        local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
        for _ = 1, 3 do
            local pick = parts[math.random(1, #parts)]
            local p = tChar:FindFirstChild(pick)
            if p then return p end
        end
        return tChar:FindFirstChild("Head")
    elseif S.aimPart == "Torso" then
        return tChar:FindFirstChild("UpperTorso")
            or tChar:FindFirstChild("Torso")
            or tChar:FindFirstChild("HumanoidRootPart")
            or tChar:FindFirstChild("Head")
    else
        return tChar:FindFirstChild(S.aimPart) or tChar:FindFirstChild("Head")
    end
end

local function getTargetPartFor(player, mode)
    if not player or not player.Character then return nil end
    if mode == "Head" then
        return player.Character:FindFirstChild("Head")
    elseif mode == "Torso" then
        return player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
    elseif mode == "Random" then
        local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
        return player.Character:FindFirstChild(parts[math.random(1, #parts)])
    end
    return player.Character:FindFirstChild("Head")
end

local SKY_PRESETS = {
    {name = "sky_cosmos",
        Bk = "rbxassetid://1600951421", Dn = "rbxassetid://1600951283",
        Ft = "rbxassetid://1600951537", Lf = "rbxassetid://1600951625",
        Rt = "rbxassetid://1600951733", Up = "rbxassetid://1600951155",
        StarCount = 3000, Sun = 0, Moon = 0, Clock = 0},
    {name = "sky_galaxy",
        Bk = "rbxassetid://12064107", Dn = "rbxassetid://12064152",
        Ft = "rbxassetid://12064121", Lf = "rbxassetid://12063984",
        Rt = "rbxassetid://12064115", Up = "rbxassetid://12064110",
        StarCount = 5000, Sun = 0, Moon = 0, Clock = 0},
    {name = "sky_night",
        Bk = "rbxassetid://159460308", Dn = "rbxassetid://159460252",
        Ft = "rbxassetid://159460224", Lf = "rbxassetid://159460180",
        Rt = "rbxassetid://159460143", Up = "rbxassetid://159460115",
        StarCount = 4000, Sun = 0, Moon = 20, Clock = 0},
    {name = "sky_sunset",
        Bk = "rbxassetid://190012845", Dn = "rbxassetid://190012834",
        Ft = "rbxassetid://190012826", Lf = "rbxassetid://190012820",
        Rt = "rbxassetid://190012816", Up = "rbxassetid://190012810",
        StarCount = 800, Sun = 40, Moon = 0, Clock = 18},
    {name = "sky_dawn",
        Bk = "rbxassetid://190012845", Dn = "rbxassetid://190012834",
        Ft = "rbxassetid://190012826", Lf = "rbxassetid://190012820",
        Rt = "rbxassetid://190012816", Up = "rbxassetid://190012810",
        StarCount = 1500, Sun = 25, Moon = 0, Clock = 6},
    {name = "sky_purple",
        Bk = "rbxassetid://1618859413", Dn = "rbxassetid://1618859125",
        Ft = "rbxassetid://1618858846", Lf = "rbxassetid://1618858536",
        Rt = "rbxassetid://1618858239", Up = "rbxassetid://1618857974",
        StarCount = 2500, Sun = 0, Moon = 0, Clock = 0},
}

local function applySky(preset)
    if S.skyData then pcall(function() S.skyData:Destroy() end) S.skyData = nil end
    if S.skyAtmo then pcall(function() S.skyAtmo:Destroy() end) S.skyAtmo = nil end
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then pcall(function() obj:Destroy() end) end
    end
    task.wait(0.25)
    if not preset then return end
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "VankaAtmosphere"
    atmo.Density = 0.4
    atmo.Offset = 0.25
    atmo.Color = Color3.fromRGB(199, 199, 199)
    atmo.Decay = Color3.fromRGB(106, 112, 125)
    atmo.Glare = 0
    atmo.Haze = 0
    atmo.Parent = Lighting
    S.skyAtmo = atmo
    local sky = Instance.new("Sky")
    sky.Name = "VankaSky"
    sky.SkyboxBk = preset.Bk
    sky.SkyboxDn = preset.Dn
    sky.SkyboxFt = preset.Ft
    sky.SkyboxLf = preset.Lf
    sky.SkyboxRt = preset.Rt
    sky.SkyboxUp = preset.Up
    sky.StarCount = preset.StarCount or 3000
    sky.SunAngularSize = preset.Sun or 21
    sky.MoonAngularSize = preset.Moon or 10
    sky.Parent = Lighting
    S.skyData = sky
    Lighting.Brightness = 2
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.Ambient = Color3.fromRGB(120, 120, 140)
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 140)
    if preset.Clock then Lighting.ClockTime = preset.Clock end
    task.delay(0.5, function()
        if sky and sky.Parent then
            local id = sky.SkyboxBk
            sky.SkyboxBk = ""
            task.wait(0.1)
            sky.SkyboxBk = id
        end
    end)
end

local function clearSky()
    if S.skyData then pcall(function() S.skyData:Destroy() end) S.skyData = nil end
    if S.skyAtmo then pcall(function() S.skyAtmo:Destroy() end) S.skyAtmo = nil end
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then pcall(function() obj:Destroy() end) end
    end
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then pcall(function() obj:Destroy() end) end
    end
end

local function startAutoShoot()
    if S.autoShootThread then return end
    S.autoShootThread = task.spawn(function()
        notify(T("wait_gun") .. "...", Color3.fromRGB(255, 200, 0))
        while S.autoShootEnabled do
            local myChar = LP.Character
            if not myChar or not myChar.Parent then
                task.wait(0.1)
                continue
            end
            local myHum = myChar:FindFirstChildOfClass("Humanoid")
            if not myHum then task.wait(0.1) continue end
            local murderer = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local bp = plr:FindFirstChildOfClass("Backpack")
                    local ch = plr.Character
                    if (bp and bp:FindFirstChild("Knife")) or (ch and ch:FindFirstChild("Knife")) then
                        murderer = plr
                        break
                    end
                end
            end
            if not murderer or not murderer.Character then
                task.wait(0.1)
                continue
            end
            local gun = myChar:FindFirstChild("Gun") or (LP.Backpack and LP.Backpack:FindFirstChild("Gun"))
            if not gun then
                task.wait(0.1)
                continue
            end
            if gun.Parent ~= myChar then
                pcall(function() myHum:EquipTool(gun) end)
                task.wait(0.1)
            end
            local gunTool = myChar:FindFirstChild("Gun")
            if not gunTool then task.wait(0.1) continue end
            local knifeServer = gunTool:FindFirstChild("KnifeServer")
            local shootGun = knifeServer and knifeServer:FindFirstChild("ShootGun")
            if not shootGun then task.wait(0.1) continue end
            local tChar = murderer.Character
            local tHRP = tChar:FindFirstChild("HumanoidRootPart")
            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            if not tHRP or not tHum then task.wait(0.1) continue end
            local shootOffset = 3.5
            local args = {
                [1] = 1,
                [2] = tHRP.Position + tHum.MoveDirection * shootOffset,
                [3] = "AH"
            }
            pcall(function()
                shootGun:InvokeServer(unpack(args))
            end)
            task.wait(0.1)
        end
        S.autoShootThread = nil
        notify(T("sheriff_off"), Color3.fromRGB(150, 150, 150))
    end)
end

local function stopAutoShoot()
    S.autoShootEnabled = false
    S.autoShootThread = nil
end

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

local function findMurdererSilent()
    if not LP.Character then return nil end
    local myHrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    local closest, closestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if getRole(plr) == "Murderer" then
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                local part = getTargetPartFor(plr, S.triggerTarget or "Head")
                if h and h.Health > 0 and part then
                    local d = (part.Position - myHrp.Position).Magnitude
                    if d < (S.triggerRange or 200) and d < closestDist then
                        closestDist = d
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

local function silentFire(target)
    if not target or not target.Character then return end
    local part = getTargetPartFor(target, S.triggerTarget or "Head")
    if not part then return end
    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
    if not tool or not isGun(tool) then
        return
    end
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    local shootOffset = 3.5
    local args = {
        [1] = 1,
        [2] = tHum.Parent.HumanoidRootPart.Position + tHum.MoveDirection * shootOffset,
        [3] = "AH"
    }
    pcall(function()
        tool.KnifeServer.ShootGun:InvokeServer(unpack(args))
    end)
end

local function triggerFire()
    if not S.triggerbot then return end
    if getRole(LP) ~= "Sheriff" then return end
    if not hasGunInHand() then
        equipGun()
        return
    end
    local target = findMurdererSilent()
    if target then silentFire(target) end
end

local function startTriggerbot()
    if S.triggerThread then return end
    S.triggerThread = task.spawn(function()
        while S.triggerbot do
            if getRole(LP) == "Sheriff" then
                if not hasGunInHand() then equipGun() end
                local target = findMurdererSilent()
                if target then silentFire(target) end
            end
            task.wait(S.triggerDelay or 0.05)
        end
        S.triggerThread = nil
    end)
    if S.triggerConn then return end
    S.triggerConn = UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not S.triggerbot then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            triggerFire()
        end
    end)
end

local function stopTriggerbot()
    S.triggerbot = false
    S.triggerThread = nil
    if S.triggerConn then
        pcall(function() S.triggerConn:Disconnect() end)
        S.triggerConn = nil
    end
end

local function startAutoKill()
    if S.autoKillThread then return end
    S.autoKillList = {}
    S.autoKillThread = task.spawn(function()
        if getRole(LP) ~= "Murderer" then
            S.autoKillThread = nil
            return
        end
        while S.autoKillEnabled do
            local target = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 and not S.autoKillList[plr] then
                        target = plr
                        break
                    end
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

local function stopAutoKill()
    S.autoKillList = {}
    S.autoKillThread = nil
end

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

local function startAutoTp()
    if S.autoTpThread then return end
    S.autoTpThread = task.spawn(function()
        while S.autoTpEnabled do
            local murderer = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "Murderer" then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        murderer = plr
                        break
                    end
                end
            end
            if murderer and murderer.Character then
                local tHrp = murderer.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if tHrp and myHrp then
                    pcall(function()
                        local behind = -tHrp.CFrame.LookVector
                        myHrp.CFrame = CFrame.new(tHrp.Position + behind * 11 + Vector3.new(0, 2, 0), tHrp.Position)
                    end)
                end
            end
            task.wait(0.05)
        end
        S.autoTpThread = nil
    end)
end

local function stopAutoTp()
    S.autoTpEnabled = false
    S.autoTpThread = nil
end

local function flingCleanup()
    for _, c in ipairs(S.flingConns) do
        pcall(function()
            if c and c.Disconnect then c:Disconnect() end
        end)
    end
    S.flingConns = {}
end

local function flingStop(silent)
    S.flingRunning = false
    if S.flingCamConn then
        pcall(function() S.flingCamConn:Disconnect() end)
        S.flingCamConn = nil
    end
    Cam.CameraType = Enum.CameraType.Custom
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then Cam.CameraSubject = h end
    end
    if S.flingThread then
        pcall(task.cancel, S.flingThread)
        S.flingThread = nil
    end
    flingCleanup()
    S.flingTargetName = ""
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.UseJumpPower = true
        end
    end
    if not silent then
        notify("Флинг остановлен", Color3.fromRGB(200, 200, 200))
    end
end

local function flingStart(targetName)
    if S.flingRunning then return end
    if not targetName or targetName == "" then
        notify(T("no_target"), Color3.fromRGB(255, 60, 60))
        return
    end
    local target = Players:FindFirstChild(targetName)
    if not target then
        notify("Игрок не найден", Color3.fromRGB(255, 60, 60))
        return
    end

    local myChar = LP.Character
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not (myChar and myHum and myRoot) then
        notify("Ошибка: нет персонажа", Color3.fromRGB(255, 60, 60))
        return
    end

    local tChar = target.Character
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tHead = tChar and tChar:FindFirstChild("Head")
    if not (tChar and tHum and tRoot) then
        notify("У цели нет частей", Color3.fromRGB(255, 60, 60))
        return
    end
    if tHum.Sit then
        notify("Цель сидит", Color3.fromRGB(255, 60, 60))
        return
    end

    S.flingRunning = true
    S.flingTargetName = targetName

    local oldPos = myRoot.CFrame
    local oldMyAutoRotate = myHum.AutoRotate
    local oldTargetPlatformStand = tHum.PlatformStand
    local oldTargetAutoRotate = tHum.AutoRotate

    workspace.CurrentCamera.CameraSubject = tHead or tRoot or tHum
    pcall(function() myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
    myHum.AutoRotate = false

    for _, p in ipairs(tChar:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function() p:SetNetworkOwner(LP) end)
        end
    end

    task.spawn(function()
        pcall(function()
            tHum.PlatformStand = true
            tHum.AutoRotate = false
            tHum:ChangeState(Enum.HumanoidStateType.Physics)
        end)

        local t0 = tick()
        while tick() - t0 < 1 do
            if not tRoot or not tRoot.Parent or not tHum or tHum.Health <= 0 then
                break
            end
            local rand = Vector3.new(math.random(-100, 100), math.random(0, 100), math.random(-100, 100))
            local massiveVel = Vector3.new(9e8, 9e8, 9e8) + rand * 1e6
            local massiveRot = Vector3.new(9e9, 9e9, 9e9)
            pcall(function()
                tRoot.AssemblyLinearVelocity = massiveVel
                tRoot.AssemblyAngularVelocity = massiveRot
            end)
            for _, p in ipairs(tChar:GetDescendants()) do
                if p:IsA("BasePart") and p ~= tRoot then
                    pcall(function()
                        p.AssemblyLinearVelocity = massiveVel
                        p.AssemblyAngularVelocity = massiveRot
                    end)
                end
            end
            RunService.Stepped:Wait()
        end

        task.wait(0.2)
        myRoot.CFrame = oldPos
        pcall(function()
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
            myRoot.Velocity = Vector3.zero
            myRoot.RotVelocity = Vector3.zero
        end)
        myHum.AutoRotate = oldMyAutoRotate
        pcall(function() myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
        workspace.CurrentCamera.CameraSubject = myHum

        task.delay(1.5, function()
            if tHum and tHum.Parent then
                pcall(function()
                    tHum.PlatformStand = oldTargetPlatformStand
                    tHum.AutoRotate = oldTargetAutoRotate
                end)
            end
        end)

        S.flingRunning = false
        S.flingTargetName = ""
    end)
end

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
                    if plr.Character and obj:IsDescendantOf(plr.Character) then used = true; break end
                    if plr.Backpack and obj:IsDescendantOf(plr.Backpack) then used = true; break end
                end
                if not used then
                    local d = (part.Position - myHrp.Position).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closest = {obj = obj, part = part}
                    end
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
        notify(T("farm_on"), Color3.fromRGB(0, 200, 100))
        local savedNoclip = S.noclip
        S.noclip = true
        local bv = Instance.new("BodyVelocity")
        bv.Name = "VankaFarmBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        local currentCoin = nil
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not S.farmEnabled then
                if conn then conn:Disconnect() end
                return
            end
            local char = LP.Character
            if not char then
                bv.Velocity = Vector3.zero
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                bv.Velocity = Vector3.zero
                return
            end
            if bv.Parent ~= hrp then
                bv.Parent = hrp
            end
            if isBagFull() then
                S.farmEnabled = false
                return
            end
            if not currentCoin or not currentCoin.part or not currentCoin.part.Parent then
                currentCoin = findCoin()
                if not currentCoin then
                    bv.Velocity = Vector3.zero
                    return
                end
            end
            local targetPos = currentCoin.part.Position
            local myPos = hrp.Position
            local flatDelta = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
            local dist = flatDelta.Magnitude
            if dist < 2.5 then
                bv.Velocity = Vector3.zero
                currentCoin = nil
                return
            end
            local speed = FARM_SPEED
            if dist < 8 then
                speed = FARM_SPEED * (dist / 8)
                if speed < 10 then speed = 10 end
            end
            bv.Velocity = flatDelta.Unit * speed
        end)
        while S.farmEnabled do
            task.wait(0.1)
        end
        if conn then conn:Disconnect() end
        pcall(function() bv:Destroy() end)
        S.noclip = savedNoclip
        notify(T("farm_off"), Color3.fromRGB(150, 150, 150))
        S.farmThread = nil
    end)
end

local function stopFarm()
    S.farmEnabled = false
    S.farmThread = nil
end

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
                    nameLbl.Name = "NameLbl"
                    nameLbl.Size = UDim2.new(1, 0, 0, 16)
                    nameLbl.Position = UDim2.new(0, 0, 0, 0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.TextStrokeTransparency = 0
                    nameLbl.TextSize = 12
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.Parent = bb
                    local weaponLbl = Instance.new("TextLabel")
                    weaponLbl.Name = "WeaponLbl"
                    weaponLbl.Size = UDim2.new(1, 0, 0, 16)
                    weaponLbl.Position = UDim2.new(0, 0, 0, 16)
                    weaponLbl.BackgroundTransparency = 1
                    weaponLbl.TextStrokeTransparency = 0
                    weaponLbl.TextSize = 13
                    weaponLbl.Font = Enum.Font.GothamBold
                    weaponLbl.Parent = bb
                    local distLbl = Instance.new("TextLabel")
                    distLbl.Name = "DistLbl"
                    distLbl.Size = UDim2.new(1, 0, 0, 14)
                    distLbl.Position = UDim2.new(0, 0, 0, 32)
                    distLbl.BackgroundTransparency = 1
                    distLbl.TextStrokeTransparency = 0
                    distLbl.TextSize = 11
                    distLbl.Font = Enum.Font.Gotham
                    distLbl.Parent = bb
                    local hpBg = Instance.new("Frame")
                    hpBg.Name = "HpBg"
                    hpBg.Size = UDim2.new(0, 120, 0, 6)
                    hpBg.Position = UDim2.new(0.5, -60, 0, 50)
                    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    hpBg.BorderSizePixel = 0
                    hpBg.Parent = bb
                    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)
                    local hpFill = Instance.new("Frame")
                    hpFill.Name = "HpFill"
                    hpFill.Size = UDim2.new(1, 0, 1, 0)
                    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    hpFill.BorderSizePixel = 0
                    hpFill.Parent = hpBg
                    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 3)
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
                                weaponLbl.Text = tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                                local hand = getHandPart(plr)
                                if hand and not hand:FindFirstChild("VankaHandHL") then
                                    local hl = Instance.new("Highlight")
                                    hl.Name = "VankaHandHL"
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillTransparency = 0.3
                                    hl.Parent = hand
                                end
                            elseif isGun(tool) then
                                weaponLbl.Text = tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(80, 180, 255)
                                local hand = getHandPart(plr)
                                if hand and not hand:FindFirstChild("VankaHandHL") then
                                    local hl = Instance.new("Highlight")
                                    hl.Name = "VankaHandHL"
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.FillColor = Color3.fromRGB(50, 150, 255)
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillTransparency = 0.3
                                    hl.Parent = hand
                                end
                            else
                                weaponLbl.Text = tool.Name
                                weaponLbl.TextColor3 = Color3.fromRGB(255, 200, 80)
                            end
                        else
                            weaponLbl.Text = ""
                        end
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
                        distLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                            if pct > 0.6 then
                                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            elseif pct > 0.3 then
                                hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                            else
                                hpFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateGunESP()
    if not S.roleHighlight then return end
    local gunDrop = workspace:FindFirstChild("GunDrop")
    local existing = S.gui and S.gui:FindFirstChild("VankaGunESP")
    if gunDrop then
        if not existing then
            local hl = Instance.new("Highlight")
            hl.Name = "VankaGunESP"
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillColor = Color3.fromRGB(255, 255, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 0)
            hl.FillTransparency = 0.3
            hl.OutlineTransparency = 0
            hl.Adornee = gunDrop
            hl.Parent = S.gui
        else
            existing.Adornee = gunDrop
            existing.Enabled = true
        end
    else
        if existing then
            existing.Enabled = false
        end
    end
end

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
        notify(T("inv_on"), Color3.fromRGB(150, 50, 150))
    else
        if S.invisibleConn then
            S.invisibleConn:Disconnect()
            S.invisibleConn = nil
        end
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
        notify(T("inv_off"), Color3.fromRGB(150, 150, 150))
    end
end

local function applySpeedValue()
    if not S.speed50Enabled then return end
    local char = LP.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local target = S.speedValue or 50
    if h.WalkSpeed ~= target then
        h.WalkSpeed = target
    end
end

local function startSpeed50Loop()
    if S.speedThread then return end
    S.speedThread = task.spawn(function()
        while S.speed50Enabled do
            applySpeedValue()
            task.wait(0.05)
        end
        S.speedThread = nil
    end)
end

local function startWalkBack()
    if S.walkBackThread then return end
    S.walkBackThread = task.spawn(function()
        notify(T("walkback_on"), Color3.fromRGB(0, 200, 100))
        while S.walkBack do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0.1 then
                    local pos = hrp.Position
                    hrp.CFrame = CFrame.lookAt(pos, pos - moveDir.Unit)
                end
            end
            RunService.RenderStepped:Wait()
        end
        S.walkBackThread = nil
        notify(T("walkback_off"), Color3.fromRGB(150, 150, 150))
    end)
end

local function stopWalkBack()
    S.walkBack = false
    S.walkBackThread = nil
end

local function hookSpeedRespawn()
    if S.speedRespawnConn then return end
    S.speedRespawnConn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if S.speed50Enabled then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = S.speedValue or 50 end
        end
    end)
end

local function startAutoPickup()
    if S.sheriffThread then return end
    S.lastSheriff = nil
    S.lastSheriffPos = nil
    S.sheriffThread = task.spawn(function()
        while S.autoPickup do
            local curSheriff, curPos = nil, nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and getRole(plr) == "Sheriff" then
                    curSheriff = plr
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then curPos = hrp.Position end
                    break
                end
            end
            if curSheriff and curPos then S.lastSheriffPos = curPos end
            if S.lastSheriff and not curSheriff and S.lastSheriffPos and not S.pickupBusy then
                S.pickupBusy = true
                local deathPos = S.lastSheriffPos
                S.lastSheriffPos = nil
                task.spawn(function()
                    task.wait(0.3)
                    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if not myHrp then
                        S.pickupBusy = false
                        return
                    end
                    local mySavedPos = myHrp.CFrame
                    pcall(function()
                        myHrp.CFrame = CFrame.new(deathPos + Vector3.new(0, 2, 0))
                        myHrp.AssemblyLinearVelocity = Vector3.zero
                    end)
                    notify(T("pickup_tp"), Color3.fromRGB(0, 200, 100))
                    task.wait(1)
                    local myHrp2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp2 then
                        pcall(function()
                            myHrp2.CFrame = mySavedPos
                            myHrp2.AssemblyLinearVelocity = Vector3.zero
                        end)
                        notify(T("pickup_back"), Color3.fromRGB(150, 200, 255))
                    end
                    task.wait(0.5)
                    S.pickupBusy = false
                end)
            end
            S.lastSheriff = curSheriff
            task.wait(0.2)
        end
        S.sheriffThread = nil
    end)
end

local function stopAutoPickup()
    S.autoPickup = false
    S.sheriffThread = nil
    S.lastSheriff = nil
    S.lastSheriffPos = nil
    S.pickupBusy = false
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
                hl.Name = "VankaRoleHL"
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
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

local function updatePreview()
    local refs = S.previewRefs
    if refs.nameLbl then refs.nameLbl.Visible = S.espName end
    if refs.distLbl then refs.distLbl.Visible = S.espDist end
    if refs.hpBg then refs.hpBg.Visible = S.espHealth end
    if refs.weaponLbl then refs.weaponLbl.Visible = S.espWeapon end
end

local showLoading

local AIM_BIND = "VankaAimLock"
local aimBound = false

local function setAimbotVisual(state)
    if not S.gui then return end
    local row = S.gui:FindFirstChild("AimToggleRow", true)
    if not row then return end
    local sw = row:FindFirstChild("Switch")
    local kn = row:FindFirstChild("Knob")
    if sw then
        TweenService:Create(sw, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
        }):Play()
    end
    if kn then
        TweenService:Create(kn, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end
end

local function restoreMouse()
    pcall(function()
        if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        end
        if not UIS.MouseIconEnabled then
            UIS.MouseIconEnabled = true
        end
    end)
end

local function aimFireIntercept()
    if not S.aimbot then return end
    if not S.aimT or not S.aimT.Character then return end
    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
    if not tool or not isGun(tool) then return end
    local tPart = getAimPart(S.aimT.Character)
    if not tPart then return end
    local tHum = S.aimT.Character:FindFirstChildOfClass("Humanoid")
    if not tHum then return end
    local shootOffset = 3.5
    local args = {
        [1] = 1,
        [2] = tHum.Parent.HumanoidRootPart.Position + tHum.MoveDirection * shootOffset,
        [3] = "AH"
    }
    pcall(function()
        tool.KnifeServer.ShootGun:InvokeServer(unpack(args))
    end)
end

local function setAimbot(state, silent)
    S.aimbot = state
    SaveData.aimbot = state
    saveSettings()
    setAimbotVisual(state)

    if state then
        if not S._aimFireConn then
            S._aimFireConn = UIS.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                   and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                aimFireIntercept()
            end)
        end
        if not aimBound then
            aimBound = true
            local lastSeen = 0
            RunService:BindToRenderStep(AIM_BIND, Enum.RenderPriority.Camera.Value + 1, function(dt)
                if not S.aimbot then
                    if aimBound then
                        aimBound = false
                        pcall(function() RunService:UnbindFromRenderStep(AIM_BIND) end)
                    end
                    restoreMouse()
                    S.aimT = nil
                    return
                end
                if S.flingRunning then return end

                local ok, err = pcall(function()
                    local myChar = LP.Character
                    if not myChar or not myChar.Parent then return end
                    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                    if not myHrp or not myHrp.Parent then return end
                    local myHrpPos = myHrp.Position
                    if myHrpPos.X ~= myHrpPos.X then return end

                    local closest, closestDist = nil, math.huge
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character then
                            local pHum = plr.Character:FindFirstChildOfClass("Humanoid")
                            if pHum and pHum.Health > 0 then
                                if getRole(plr) == "Murderer" then
                                    local part = getAimPart(plr.Character)
                                    if part and part.Parent then
                                        local pPos = part.Position
                                        if pPos.X == pPos.X then
                                            local d = (pPos - myHrpPos).Magnitude
                                            if d < closestDist then
                                                closestDist = d
                                                closest = plr
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    S.aimT = closest

                    if closest and closest.Character then
                        lastSeen = os.clock()
                        local tPart = getAimPart(closest.Character)
                        if tPart and tPart.Parent then
                            local tPos = tPart.Position
                            if tPos.X == tPos.X then
                                local camPos = Cam.CFrame.Position
                                if camPos.X == camPos.X then
                                    local delta = (tPos - camPos).Magnitude
                                    if delta > 0.5 then
                                        local desired = CFrame.lookAt(camPos, tPos)
                                        if S.hardAim then
                                            Cam.CFrame = desired
                                        else
                                            local lerp = math.clamp(1 - (S.aimSmooth or 0.35), 0.08, 1)
                                            Cam.CFrame = Cam.CFrame:Lerp(desired, lerp)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if lastSeen > 0 and (os.clock() - lastSeen) > 2 then
                            if aimBound then
                                aimBound = false
                                pcall(function() RunService:UnbindFromRenderStep(AIM_BIND) end)
                            end
                            restoreMouse()
                            S.aimT = nil
                            S.aimbot = false
                            SaveData.aimbot = false
                            saveSettings()
                            setAimbotVisual(false)
                            if not silent then
                                notify("Мардер пропал — аим ВЫКЛ", Color3.fromRGB(150, 150, 150))
                            end
                        end
                    end
                end)
                if not ok then
                    warn("[Vanka aim] " .. tostring(err))
                end
            end)
        end
    else
        if aimBound then
            aimBound = false
            pcall(function() RunService:UnbindFromRenderStep(AIM_BIND) end)
        end
        if S._aimFireConn then
            pcall(function() S._aimFireConn:Disconnect() end)
            S._aimFireConn = nil
        end
        restoreMouse()
        S.aimT = nil
    end
end

local function createGUI()
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "VankaPanel_" .. tostring(math.random(1000, 9999))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent
    S.gui = gui

    local nh = Instance.new("Frame")
    nh.Name = "NotifHolder"
    nh.Size = UDim2.new(0, 280, 1, -20)
    nh.Position = UDim2.new(1, -300, 0, 10)
    nh.BackgroundTransparency = 1
    nh.Parent = gui
    local nl = Instance.new("UIListLayout")
    nl.Padding = UDim.new(0, 8)
    nl.SortOrder = Enum.SortOrder.LayoutOrder
    nl.Parent = nh

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    PANEL_W = math.clamp(SaveData.panel_w or 540, 400, 1200)
    PANEL_H = math.clamp(SaveData.panel_h or 660, 400, 1200)
    main.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    main.Position = UDim2.new(0, SaveData.panel_x or 20, 0.5, -(PANEL_H / 2) + (SaveData.panel_y or 0))
    main.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    S.panel = main

    local panelReady = false
    task.delay(0.6, function() panelReady = true end)

    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 26, 0, 26)
    resizeHandle.Position = UDim2.new(1, -30, 1, -30)
    resizeHandle.BackgroundColor3 = S.panelColor
    resizeHandle.BackgroundTransparency = 0.3
    resizeHandle.Text = "R"
    resizeHandle.TextColor3 = Color3.new(1, 1, 1)
    resizeHandle.TextSize = 12
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 15
    resizeHandle.Parent = main
    Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 8)

    local resizing = false
    local resizeStartMouse
    local resizeStartSize

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStartMouse = UIS:GetMouseLocation()
            resizeStartSize = main.AbsoluteSize
            resizeHandle.BackgroundTransparency = 0.05
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local cur = UIS:GetMouseLocation()
            local dx = cur.X - resizeStartMouse.X
            local dy = cur.Y - resizeStartMouse.Y
            local newW = math.clamp(resizeStartSize.X + dx, 400, 1200)
            local newH = math.clamp(resizeStartSize.Y + dy, 400, 1200)
            main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch) then
            resizing = false
            resizeHandle.BackgroundTransparency = 0.3
            SaveData.panel_w = main.AbsoluteSize.X
            SaveData.panel_h = main.AbsoluteSize.Y
            saveSettings()
            PANEL_W = main.AbsoluteSize.X
            PANEL_H = main.AbsoluteSize.Y
            notify(T("size_saved") .. ": " .. math.floor(main.AbsoluteSize.X) .. "x" .. math.floor(main.AbsoluteSize.Y), Color3.fromRGB(0, 200, 100))
        end
    end)

    local saveLock = false
    local function debouncedSave()
        if saveLock then return end
        saveLock = true
        task.delay(0.4, function()
            saveLock = false
            pcall(saveSettings)
        end)
    end

    main:GetPropertyChangedSignal("Position"):Connect(function()
        if resizing or not panelReady then return end
        SaveData.panel_x = main.Position.X.Offset
        SaveData.panel_y = main.Position.Y.Offset + (main.AbsoluteSize.Y / 2)
        debouncedSave()
    end)

    main:GetPropertyChangedSignal("Size"):Connect(function()
        if resizing or not panelReady then return end
        SaveData.panel_w = main.AbsoluteSize.X
        SaveData.panel_h = main.AbsoluteSize.Y
        debouncedSave()
    end)

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
    top.Size = UDim2.new(1, 0, 0, HEADER_H)
    top.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, HEADER_H - 28)
    tf.Position = UDim2.new(0, 0, 1, -(HEADER_H - 28))
    tf.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    tf.BorderSizePixel = 0
    tf.Parent = top

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0, 36, 0, 36)
        li.Position = UDim2.new(0, 12, 0.5, -18)
        li.BackgroundTransparency = 1
        li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit
        li.Parent = top
        Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8)
    else
        local he = Instance.new("TextLabel")
        he.Size = UDim2.new(0, 36, 1, 0)
        he.Position = UDim2.new(0, 12, 0, 0)
        he.BackgroundTransparency = 1
        he.Text = "V"
        he.TextColor3 = S.panelColor
        he.TextSize = 24
        he.Font = Enum.Font.GothamBold
        he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Name = "Title"
    ttl.Size = UDim2.new(1, -160, 1, 0)
    ttl.Position = UDim2.new(0, 58, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = T("title")
    ttl.TextColor3 = Color3.new(1, 1, 1)
    ttl.TextSize = 15
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = top

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0, 30, 0, 30)
    minB.Position = UDim2.new(1, -72, 0.5, -15)
    minB.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    minB.Text = "-"
    minB.TextColor3 = Color3.new(1, 1, 1)
    minB.TextSize = 18
    minB.Font = Enum.Font.GothamBold
    minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 8)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0, 30, 0, 30)
    closeB.Position = UDim2.new(1, -38, 0.5, -15)
    closeB.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
    closeB.Text = "X"
    closeB.TextColor3 = Color3.new(1, 1, 1)
    closeB.TextSize = 16
    closeB.Font = Enum.Font.GothamBold
    closeB.Parent = top
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 8)

    local openB = Instance.new("TextButton")
    openB.Size = UDim2.new(0, 55, 0, 55)
    openB.Position = UDim2.new(0, 15, 0.5, -27)
    openB.BackgroundColor3 = S.panelColor
    openB.Text = "V"
    openB.TextColor3 = Color3.new(1, 1, 1)
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

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 42)
    tabBar.Position = UDim2.new(0, 10, 0, HEADER_H + 6)
    tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)

    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 3)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tl.Parent = tabBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -(HEADER_H + 68))
    content.Position = UDim2.new(0, 10, 0, HEADER_H + 54)
    content.BackgroundTransparency = 1
    content.Parent = main

    local tabs, pages = {}, {}
    local function switchTab(name)
        for k, p in pairs(pages) do
            p.Visible = (k == name)
        end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and S.panelColor or Color3.fromRGB(32, 32, 44)
        end
    end

    local function addTab(key, img, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 78, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        tabs[key] = b
        if img then
            local im = Instance.new("ImageLabel")
            im.Size = UDim2.new(0, 22, 0, 22)
            im.Position = UDim2.new(0.5, -11, 0.5, -11)
            im.BackgroundTransparency = 1
            im.Image = img
            im.ScaleType = Enum.ScaleType.Fit
            im.Parent = b
        else
            b.Text = txt or key:upper()
            b.TextColor3 = Color3.fromRGB(170, 170, 190)
            b.TextSize = 10
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
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 20)
        padding.PaddingLeft = UDim.new(0, 3)
        padding.PaddingRight = UDim.new(0, 3)
        padding.Parent = p
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = p
        lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            p.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 40)
        end)
        b.MouseButton1Click:Connect(function() switchTab(key) end)
        return p
    end

    local function addBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, BTN_H)
        b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = FONT_SZ
        b.Font = Enum.Font.GothamMedium
        b.TextWrapped = true
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then
                notify("Err: " .. tostring(err), Color3.fromRGB(255, 60, 60))
            else
                notify(T("saved_msg"), Color3.fromRGB(0, 200, 100))
            end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, TOGGLE_H)
        row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
        lbl.TextSize = FONT_SZ
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local sw = Instance.new("Frame")
        sw.Name = "Switch"
        sw.Size = UDim2.new(0, 42, 0, 20)
        sw.Position = UDim2.new(1, -54, 0.5, -10)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
        sw.BorderSizePixel = 0
        sw.Parent = row
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local kn = Instance.new("Frame")
        kn.Name = "Knob"
        kn.Size = UDim2.new(0, 16, 0, 16)
        kn.Position = initial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        kn.BackgroundColor3 = Color3.new(1, 1, 1)
        kn.BorderSizePixel = 0
        kn.Parent = sw
        Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)
        local st = initial
        row.MouseButton1Click:Connect(function()
            st = not st
            TweenService:Create(sw, TweenInfo.new(0.15), {
                BackgroundColor3 = st and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 70)
            }):Play()
            TweenService:Create(kn, TweenInfo.new(0.15), {
                Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            cb(st)
            notify(T("saved_msg"), Color3.fromRGB(0, 200, 100))
        end)
        return row
    end

    local function addLabel(parent, text)
        local w = Instance.new("Frame")
        w.Size = UDim2.new(1, 0, 0, 26)
        w.BackgroundTransparency = 1
        w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0, 3, 0, 16)
        a.Position = UDim2.new(0, 0, 0.5, -8)
        a.BackgroundColor3 = S.panelColor
        a.BorderSizePixel = 0
        a.Name = "Accent"
        a.Parent = w
        Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -12, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = S.panelColor
        l.TextSize = FONT_SZ - 1
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Name = "AccentLabel"
        l.Parent = w
    end

    local function addTextBox(parent, default, placeholder)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, 0, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        box.BorderSizePixel = 0
        box.Text = tostring(default)
        box.PlaceholderText = placeholder or ""
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = FONT_SZ
        box.ClearTextOnFocus = false
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
        local p = Instance.new("UIPadding", box)
        p.PaddingLeft = UDim.new(0, 12)
        return box
    end

    local tabMain = addTab("main", IMG_MAIN)
    local tabVisual = addTab("visual", IMG_VIS)
    local tabESP = addTab("esp", nil, T("tab_esp"))
    local tabRage = addTab("rage", IMG_RAGE)
    local tabPlayers = addTab("players", nil, T("tab_players"))
    local tabSettings = addTab("settings", nil, T("tab_settings"))
    local tabConfigs = addTab("configs", nil, T("tab_configs"))
    switchTab("main")

    addLabel(tabMain, T("sec_sheriff"))
    addToggle(tabMain, T("autoshoot"), SaveData.autoshoot, function(v)
        S.autoShootEnabled = v
        SaveData.autoshoot = v
        saveSettings()
        if v then
            startAutoShoot()
        else
            stopAutoShoot()
        end
    end)

    addLabel(tabMain, T("sec_autokill"))
    addToggle(tabMain, T("autokill"), SaveData.autokill, function(v)
        S.autoKillEnabled = v
        SaveData.autokill = v
        saveSettings()
        if v then
            startAutoKillLoop()
        else
            stopAutoKillLoop()
        end
    end)

    addToggle(tabMain, T("autoTpMurderer"), SaveData.autotp, function(v)
        S.autoTpEnabled = v
        SaveData.autotp = v
        saveSettings()
        if v then
            startAutoTp()
        else
            stopAutoTp()
        end
    end)

    addLabel(tabMain, T("sec_farm"))
    addToggle(tabMain, T("farm"), S.farmEnabled, function(v)
        S.farmEnabled = v
        SaveData.farm = v
        saveSettings()
        if v then
            startFarm()
        else
            stopFarm()
        end
    end)

    addLabel(tabMain, T("farm_speed"))
    local farmSpeedBox = addTextBox(tabMain, FARM_SPEED, "80")
    farmSpeedBox.FocusLost:Connect(function()
        local v = tonumber(farmSpeedBox.Text)
        if v and v >= 10 and v <= 500 then
            FARM_SPEED = v
            SaveData.farm_speed = v
            saveSettings()
            notify("Скорость фарма: " .. v, Color3.fromRGB(0, 200, 100))
        else
            farmSpeedBox.Text = tostring(FARM_SPEED)
            notify("Скорость 10-500", Color3.fromRGB(255, 60, 60))
        end
    end)

    addLabel(tabMain, T("sec_pickup"))
    addToggle(tabMain, T("pickup"), SaveData.pickup, function(v)
        S.autoPickup = v
        SaveData.pickup = v
        saveSettings()
        if v then
            startAutoPickup()
        else
            stopAutoPickup()
        end
    end)

    addLabel(tabMain, T("sec_roles"))
    addToggle(tabMain, T("roles"), SaveData.roles, function(v)
        S.roleHighlight = v
        SaveData.roles = v
        saveSettings()
        if v then
            refreshHL()
        else
            clearHL()
            local existing = S.gui and S.gui:FindFirstChild("VankaGunESP")
            if existing then existing.Enabled = false end
        end
    end)

    addToggle(tabMain, T("invisible"), S.invisibleEnabled, function(v)
        setInvisible(v)
    end)

    addBtn(tabMain, T("clear_inv"), Color3.fromRGB(60, 60, 70), function()
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

    addLabel(tabVisual, T("sec_cross"))
    addToggle(tabVisual, T("cross"), SaveData.cross, function(v)
        S.crosshair = v
        SaveData.cross = v
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addToggle(tabVisual, T("fov"), SaveData.fov, function(v)
        S.fovCircle = v
        SaveData.fov = v
        saveSettings()
    end)
    addToggle(tabVisual, T("hardaim"), SaveData.hardaim, function(v)
        S.hardAim = v
        SaveData.hardaim = v
        saveSettings()
    end)

    addLabel(tabVisual, T("sec_cross_style"))
    addBtn(tabVisual, T("cross_1"), Color3.fromRGB(60, 60, 90), function()
        S.crossStyle = 1
        SaveData.cross_style = 1
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_2"), Color3.fromRGB(60, 60, 90), function()
        S.crossStyle = 2
        SaveData.cross_style = 2
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)
    addBtn(tabVisual, T("cross_3"), Color3.fromRGB(60, 60, 90), function()
        S.crossStyle = 3
        SaveData.cross_style = 3
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)

    addLabel(tabVisual, T("sec_cross_custom"))
    addBtn(tabVisual, T("cross_load"), Color3.fromRGB(80, 60, 120), function()
        if isfile and getcustomasset then
            local ok, exists = pcall(isfile, "vanka_crosshair.png")
            if ok and exists then
                local ok2, asset = pcall(getcustomasset, "vanka_crosshair.png")
                if ok2 and asset and asset ~= "" then
                    S.crossImage = asset
                    SaveData.custom_cross = "vanka_crosshair.png"
                    saveSettings()
                    if _G.VankaUpdateCross then _G.VankaUpdateCross() end
                    notify(T("cross_loaded"), Color3.fromRGB(0, 200, 100))
                end
            else
                notify(T("cross_notfound"), Color3.fromRGB(255, 60, 60))
            end
        end
    end)
    addBtn(tabVisual, T("cross_reset"), Color3.fromRGB(120, 50, 50), function()
        S.crossImage = nil
        SaveData.custom_cross = ""
        saveSettings()
        if _G.VankaUpdateCross then _G.VankaUpdateCross() end
    end)

    addLabel(tabVisual, T("sec_move"))
    addToggle(tabVisual, T("fly"), SaveData.fly, function(v)
        S.fly = v
        SaveData.fly = v
        saveSettings()
        if not v and S.flyBV then
            pcall(function() S.flyBV:Destroy() end)
            S.flyBV = nil
        end
    end)
    addToggle(tabVisual, T("noclip"), SaveData.noclip, function(v)
        S.noclip = v
        SaveData.noclip = v
        saveSettings()
    end)
    addToggle(tabVisual, T("infjump"), SaveData.infjump, function(v)
        S.infjump = v
        SaveData.infjump = v
        saveSettings()
    end)

    addLabel(tabVisual, T("speed"))
    local speedBox = addTextBox(tabVisual, S.speedValue or 50, "Скорость 16-500")
    speedBox.FocusLost:Connect(function()
        local v = tonumber(speedBox.Text)
        if v and v > 0 and v <= 500 then
            S.speedValue = v
            SaveData.speed_value = v
            saveSettings()
            if S.speed50Enabled and LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = v end
            end
            notify("Скорость: " .. v, Color3.fromRGB(0, 200, 100))
        else
            speedBox.Text = tostring(S.speedValue or 50)
            notify("Скорость 1-500", Color3.fromRGB(255, 60, 60))
        end
    end)

    addToggle(tabVisual, T("speed"), S.speed50Enabled, function(v)
        S.speed50Enabled = v
        SaveData.speed50 = v
        saveSettings()
        if v then
            startSpeed50Loop()
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = S.speedValue or 50 end
            end
        else
            if LP.Character then
                local h = LP.Character:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = 16 end
            end
        end
    end)

    addToggle(tabVisual, T("walkback"), SaveData.walkback, function(v)
        S.walkBack = v
        SaveData.walkback = v
        saveSettings()
        if v then
            startWalkBack()
        else
            stopWalkBack()
        end
    end)

    addLabel(tabVisual, T("sec_sky"))
    addBtn(tabVisual, T("sky_cosmos"), Color3.fromRGB(40, 40, 80), function()
        applySky(SKY_PRESETS[1])
        SaveData.sky_name = "sky_cosmos"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_galaxy"), Color3.fromRGB(60, 30, 90), function()
        applySky(SKY_PRESETS[2])
        SaveData.sky_name = "sky_galaxy"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_dawn"), Color3.fromRGB(120, 70, 60), function()
        applySky(SKY_PRESETS[3])
        SaveData.sky_name = "sky_dawn"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_sunset"), Color3.fromRGB(140, 80, 50), function()
        applySky(SKY_PRESETS[4])
        SaveData.sky_name = "sky_sunset"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_night"), Color3.fromRGB(30, 30, 60), function()
        applySky(SKY_PRESETS[5])
        SaveData.sky_name = "sky_night"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_purple"), Color3.fromRGB(80, 40, 120), function()
        applySky(SKY_PRESETS[6])
        SaveData.sky_name = "sky_purple"
        saveSettings()
    end)
    addBtn(tabVisual, T("sky_clear"), Color3.fromRGB(80, 40, 40), function()
        clearSky()
        SaveData.sky_name = ""
        saveSettings()
    end)

    addLabel(tabVisual, T("sec_vis"))
    addToggle(tabVisual, T("fullbright"), SaveData.fullbright, function(v)
        S.fullbright = v
        SaveData.fullbright = v
        saveSettings()
        if v then
            if not S.oldLighting then
                S.oldLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient
                }
            end
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
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

    addLabel(tabESP, T("sec_esp"))
    addToggle(tabESP, T("esp_main"), S.espEnabled, function(v)
        S.espEnabled = v
        SaveData.esp = v
        saveSettings()
    end)
    addToggle(tabESP, T("esp_health"), S.espHealth, function(v)
        S.espHealth = v
        SaveData.esp_health = v
        saveSettings()
        updatePreview()
    end)
    addToggle(tabESP, T("esp_name"), S.espName, function(v)
        S.espName = v
        SaveData.esp_name = v
        saveSettings()
        updatePreview()
    end)
    addToggle(tabESP, T("esp_dist"), S.espDist, function(v)
        S.espDist = v
        SaveData.esp_dist = v
        saveSettings()
        updatePreview()
    end)
    addToggle(tabESP, T("esp_weapon"), S.espWeapon, function(v)
        S.espWeapon = v
        SaveData.esp_weapon = v
        saveSettings()
        updatePreview()
    end)
    addToggle(tabESP, T("esp_rainbow"), S.espRainbow, function(v)
        S.espRainbow = v
        SaveData.esp_rainbow = v
        saveSettings()
    end)

    addLabel(tabESP, T("sec_hitbox"))
    addToggle(tabESP, T("hitbox"), SaveData.hitbox, function(v)
        S.hitbox = v
        SaveData.hitbox = v
        saveSettings()
        if S.previewRefs.hitbox then S.previewRefs.hitbox.Visible = v end
        if not v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        local hl = part:FindFirstChild("VankaHitboxHL")
                        if hl then hl:Destroy() end
                    end
                end
            end
        end
    end)

    addLabel(tabESP, T("sec_lines"))
    addToggle(tabESP, T("lines"), SaveData.lines, function(v)
        S.lines = v
        SaveData.lines = v
        saveSettings()
        if not v then
            for _, att in pairs(S.espLines) do
                pcall(function() att:Destroy() end)
            end
            S.espLines = {}
        end
    end)

    addLabel(tabESP, T("esp_preview"))
    local previewFrame = Instance.new("Frame")
    previewFrame.Size = UDim2.new(1, 0, 0, 240)
    previewFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    previewFrame.BorderSizePixel = 0
    previewFrame.Parent = tabESP
    Instance.new("UICorner", previewFrame).CornerRadius = UDim.new(0, 10)
    if IMG_NOOB then
        local oldHb = previewFrame:FindFirstChild("PrevHitbox")
        if oldHb then oldHb:Destroy() end
        local noobImg = Instance.new("ImageLabel")
        noobImg.Size = UDim2.new(0, 130, 0, 130)
        noobImg.Position = UDim2.new(0.5, -65, 0.5, -20)
        noobImg.BackgroundTransparency = 1
        noobImg.Image = IMG_NOOB
        noobImg.ScaleType = Enum.ScaleType.Fit
        noobImg.Parent = previewFrame
        local noobStroke = Instance.new("UIStroke")
        noobStroke.Color = S.panelColor
        noobStroke.Thickness = 2
        noobStroke.Transparency = 0.3
        noobStroke.Parent = noobImg
        S.previewRefs.noob = noobImg
        S.previewRefs.noobStroke = noobStroke

        local hbFrame = Instance.new("Frame")
        hbFrame.Name = "PrevHitbox"
        hbFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        hbFrame.Size = UDim2.new(0, 90, 0, 100)
        hbFrame.Position = UDim2.new(0.5, 0, 0.5, 15)
        hbFrame.BackgroundTransparency = 1
        hbFrame.BorderSizePixel = 0
        hbFrame.Visible = false
        hbFrame.ZIndex = 5
        hbFrame.Parent = previewFrame
        local hbStroke = Instance.new("UIStroke")
        hbStroke.Color = Color3.fromRGB(255, 50, 50)
        hbStroke.Thickness = 2
        hbStroke.Parent = hbFrame
        local hbLabel = Instance.new("TextLabel")
        hbLabel.Size = UDim2.new(0, 60, 0, 14)
        hbLabel.Position = UDim2.new(0.5, -30, -0.15, 0)
        hbLabel.BackgroundTransparency = 1
        hbLabel.Text = "HITBOX"
        hbLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        hbLabel.TextSize = 10
        hbLabel.Font = Enum.Font.GothamBold
        hbLabel.Parent = hbFrame
        S.previewRefs.hitbox = hbFrame

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "PrevName"
        nameLbl.Size = UDim2.new(0, 180, 0, 18)
        nameLbl.Position = UDim2.new(0.5, -90, 0, 26)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = T("preview_name") .. " [" .. T("role_innocent") .. "]"
        nameLbl.TextColor3 = S.espColorInnocent
        nameLbl.TextStrokeTransparency = 0
        nameLbl.TextSize = 13
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Parent = previewFrame
        S.previewRefs.nameLbl = nameLbl

        local weaponLbl = Instance.new("TextLabel")
        weaponLbl.Name = "PrevWeapon"
        weaponLbl.Size = UDim2.new(0, 180, 0, 18)
        weaponLbl.Position = UDim2.new(0.5, -90, 0, 44)
        weaponLbl.BackgroundTransparency = 1
        weaponLbl.Text = "Gun"
        weaponLbl.TextColor3 = Color3.fromRGB(80, 180, 255)
        weaponLbl.TextStrokeTransparency = 0
        weaponLbl.TextSize = 13
        weaponLbl.Font = Enum.Font.GothamBold
        weaponLbl.Parent = previewFrame
        S.previewRefs.weaponLbl = weaponLbl

        local hpBg = Instance.new("Frame")
        hpBg.Name = "PrevHpBg"
        hpBg.Size = UDim2.new(0, 120, 0, 8)
        hpBg.Position = UDim2.new(0.5, -60, 0, 64)
        hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        hpBg.BorderSizePixel = 0
        hpBg.Parent = previewFrame
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 4)
        local hpFill = Instance.new("Frame")
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hpFill.BorderSizePixel = 0
        hpFill.Parent = hpBg
        Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 4)
        S.previewRefs.hpBg = hpBg

        local distLbl = Instance.new("TextLabel")
        distLbl.Name = "PrevDist"
        distLbl.Size = UDim2.new(0, 180, 0, 16)
        distLbl.Position = UDim2.new(0.5, -90, 0, 78)
        distLbl.BackgroundTransparency = 1
        distLbl.Text = "[" .. T("preview_dist") .. "]"
        distLbl.TextColor3 = Color3.new(1, 1, 1)
        distLbl.TextStrokeTransparency = 0
        distLbl.TextSize = 12
        distLbl.Font = Enum.Font.Gotham
        distLbl.Parent = previewFrame
        S.previewRefs.distLbl = distLbl
        updatePreview()
    end

    addLabel(tabRage, T("sec_aim"))
    local aimbotRow = addToggle(tabRage, T("aimbot"), SaveData.aimbot, function(v)
        setAimbot(v)
        if v then
            notify("Аим: мардер в прицеле", Color3.fromRGB(0, 200, 100))
        end
    end)
    aimbotRow.Name = "AimToggleRow"

    addLabel(tabRage, T("sec_aim_part"))
    addBtn(tabRage, T("aim_head"), Color3.fromRGB(60, 60, 90), function()
        S.aimPart = "Head"
        SaveData.aim_part = "Head"
        saveSettings()
    end)
    addBtn(tabRage, T("aim_torso"), Color3.fromRGB(60, 60, 90), function()
        S.aimPart = "Torso"
        SaveData.aim_part = "Torso"
        saveSettings()
    end)
    addBtn(tabRage, T("aim_random"), Color3.fromRGB(60, 60, 90), function()
        S.aimPart = "Random"
        SaveData.aim_part = "Random"
        saveSettings()
    end)

    addLabel(tabRage, T("sec_smooth"))
    addBtn(tabRage, T("smooth_slow"), Color3.fromRGB(60, 60, 90), function()
        S.aimSmooth = 0.35
        SaveData.aim_smooth = 0.35
        saveSettings()
    end)
    addBtn(tabRage, T("smooth_mid"), Color3.fromRGB(60, 60, 90), function()
        S.aimSmooth = 0.15
        SaveData.aim_smooth = 0.15
        saveSettings()
    end)
    addBtn(tabRage, T("smooth_fast"), Color3.fromRGB(60, 60, 90), function()
        S.aimSmooth = 0.05
        SaveData.aim_smooth = 0.05
        saveSettings()
    end)

    addToggle(tabRage, T("kill_aim"), false, function(v)
        if v then
            S.hardAim = true
            SaveData.hardaim = true
            saveSettings()
        else
            S.hardAim = false
            SaveData.hardaim = false
            saveSettings()
        end
    end)

    addLabel(tabRage, T("sec_trigger"))
    addToggle(tabRage, T("triggerbot"), SaveData.triggerbot, function(v)
        S.triggerbot = v
        SaveData.triggerbot = v
        saveSettings()
        if v then startTriggerbot() else stopTriggerbot() end
    end)

    addLabel(tabRage, T("trigger_delay"))
    local trigDelayBox = addTextBox(tabRage, S.triggerDelay, "0.05")
    trigDelayBox.FocusLost:Connect(function()
        local v = tonumber(trigDelayBox.Text)
        if v and v >= 0.01 and v <= 1 then
            S.triggerDelay = v
            SaveData.trigger_delay = v
            saveSettings()
        else
            trigDelayBox.Text = tostring(S.triggerDelay)
        end
    end)

    addLabel(tabRage, T("trigger_range"))
    local trigRangeBox = addTextBox(tabRage, S.triggerRange, "200")
    trigRangeBox.FocusLost:Connect(function()
        local v = tonumber(trigRangeBox.Text)
        if v and v >= 10 and v <= 1000 then
            S.triggerRange = v
            SaveData.trigger_range = v
            saveSettings()
        else
            trigRangeBox.Text = tostring(S.triggerRange)
        end
    end)

    addLabel(tabRage, T("trigger_target"))
    addBtn(tabRage, T("aim_head"), Color3.fromRGB(60, 60, 90), function()
        S.triggerTarget = "Head"
        SaveData.trigger_target = "Head"
        saveSettings()
    end)
    addBtn(tabRage, T("aim_torso"), Color3.fromRGB(60, 60, 90), function()
        S.triggerTarget = "Torso"
        SaveData.trigger_target = "Torso"
        saveSettings()
    end)
    addBtn(tabRage, T("aim_random"), Color3.fromRGB(60, 60, 90), function()
        S.triggerTarget = "Random"
        SaveData.trigger_target = "Random"
        saveSettings()
    end)

    addLabel(tabRage, T("sec_spin"))
    addToggle(tabRage, T("spin"), SaveData.spin, function(v)
        S.spin = v
        SaveData.spin = v
        saveSettings()
    end)

    addLabel(tabRage, T("sec_antiaim"))
    addToggle(tabRage, T("antiaim"), SaveData.antiaim, function(v)
        S.antiAim = v
        SaveData.antiaim = v
        saveSettings()
    end)

    addLabel(tabRage, T("sec_util"))
    addBtn(tabRage, T("respawn"), Color3.fromRGB(60, 60, 90), function()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end)
    addBtn(tabRage, T("disable_all"), Color3.fromRGB(150, 30, 30), function()
        S.aimbot = false
        SaveData.aimbot = false
        setAimbotVisual(false)
        if aimBound then
            aimBound = false
            pcall(function() RunService:UnbindFromRenderStep(AIM_BIND) end)
        end
        restoreMouse()
        S.triggerbot = false
        SaveData.triggerbot = false
        stopTriggerbot()
        S.spin = false
        SaveData.spin = false
        S.antiAim = false
        SaveData.antiaim = false
        saveSettings()
        notify(T("all_off"), Color3.fromRGB(200, 200, 200))
    end)

    addLabel(tabPlayers, T("plist"))
    local playerRows = {}
    local function refreshPlayerList()
        for _, r in pairs(playerRows) do
            if r and r.Parent then r:Destroy() end
        end
        playerRows = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 36)
                row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                row.BorderSizePixel = 0
                row.Parent = tabPlayers
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size = UDim2.new(1, -140, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = plr.Name .. " [" .. getRoleDisplay(plr) .. "]"
                nameLbl.TextColor3 = roleColor(plr)
                nameLbl.TextSize = FONT_SZ
                nameLbl.Font = Enum.Font.GothamMedium
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = row

                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(0, 55, 0, 28)
                tpBtn.Position = UDim2.new(1, -125, 0.5, -14)
                tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
                tpBtn.Text = T("tp")
                tpBtn.TextColor3 = Color3.new(1, 1, 1)
                tpBtn.TextSize = FONT_SZ - 1
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.Parent = row
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
                tpBtn.MouseButton1Click:Connect(function()
                    if plr.Character then
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and tHrp then
                            hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                end)

                local flingBtn = Instance.new("TextButton")
                flingBtn.Size = UDim2.new(0, 60, 0, 28)
                flingBtn.Position = UDim2.new(1, -65, 0.5, -14)
                flingBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
                flingBtn.Text = T("fling")
                flingBtn.TextColor3 = Color3.new(1, 1, 1)
                flingBtn.TextSize = FONT_SZ - 1
                flingBtn.Font = Enum.Font.GothamBold
                flingBtn.Parent = row
                Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0, 6)
                flingBtn.MouseButton1Click:Connect(function()
                    flingStart(plr.Name)
                end)

                table.insert(playerRows, row)
            end
        end
    end
    refreshPlayerList()
    Players.PlayerAdded:Connect(function() task.wait(0.5) refreshPlayerList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1) refreshPlayerList() end)

    addLabel(tabSettings, T("sec_lang"))
    addBtn(tabSettings, T("lang_ru"), Color3.fromRGB(60, 60, 90), function()
        LANG = "ru"
        SaveData.lang = "ru"
        saveSettings()
        notify(T("lang_changed"), Color3.fromRGB(255, 200, 0))
    end)
    addBtn(tabSettings, T("lang_en"), Color3.fromRGB(60, 60, 90), function()
        LANG = "en"
        SaveData.lang = "en"
        saveSettings()
        notify(T("lang_changed"), Color3.fromRGB(255, 200, 0))
    end)
    addBtn(tabSettings, T("lang_zh"), Color3.fromRGB(60, 60, 90), function()
        LANG = "zh"
        SaveData.lang = "zh"
        saveSettings()
        notify(T("lang_changed"), Color3.fromRGB(255, 200, 0))
    end)

    addLabel(tabSettings, T("sec_panel"))
    local colorPresets = {
        {255, 0, 100}, {0, 200, 100}, {0, 150, 255}, {255, 150, 0}, {150, 50, 200}, {255, 255, 255}
    }
    for _, c in ipairs(colorPresets) do
        addBtn(tabSettings, "Цвет " .. c[1] .. "," .. c[2] .. "," .. c[3], Color3.fromRGB(c[1], c[2], c[3]), function()
            S.panelColor = Color3.fromRGB(c[1], c[2], c[3])
            SaveData.panel_color = {c[1], c[2], c[3]}
            saveSettings()
            local mstk = main:FindFirstChild("MainStroke")
            if mstk then mstk.Color = S.panelColor end
        end)
    end

    addLabel(tabConfigs, T("sec_cfg_save"))
    local cfgNameBox = addTextBox(tabConfigs, "", T("cfg_name"))
    addBtn(tabConfigs, T("cfg_save"), Color3.fromRGB(0, 150, 80), function()
        local n = cfgNameBox.Text
        if n and n ~= "" and writefile then
            pcall(writefile, "vanka_cfg_" .. n .. ".txt", serialize())
            notify(T("cfg_saved") .. ": " .. n, Color3.fromRGB(0, 200, 100))
        end
    end)
    addBtn(tabConfigs, T("cfg_load"), Color3.fromRGB(60, 60, 150), function()
        local n = cfgNameBox.Text
        if n and n ~= "" and readfile and isfile then
            local fname = "vanka_cfg_" .. n .. ".txt"
            local ok = pcall(isfile, fname)
            if ok and isfile(fname) then
                local ok2, data = pcall(readfile, fname)
                if ok2 and data then
                    SAVE_FILE = fname
                    loadSettings()
                    notify(T("cfg_loaded") .. ": " .. n, Color3.fromRGB(0, 200, 100))
                end
            else
                notify(T("cfg_notfound"), Color3.fromRGB(255, 60, 60))
            end
        end
    end)

    addLabel(tabConfigs, T("cfg_presets"))
    addBtn(tabConfigs, T("cfg_default"), Color3.fromRGB(60, 60, 90), function()
        SAVE_FILE = "vanka_settings_v46.txt"
        loadSettings()
    end)

    closeB.MouseButton1Click:Connect(function()
        main.Visible = false
        openB.Visible = true
    end)
    openB.MouseButton1Click:Connect(function()
        main.Visible = true
        openB.Visible = false
    end)
    minB.MouseButton1Click:Connect(function()
        main.Visible = false
        openB.Visible = true
    end)

    local crossFrame = Instance.new("Frame")
    crossFrame.Name = "VankaCrosshair"
    crossFrame.Size = UDim2.new(0, 24, 0, 24)
    crossFrame.Position = UDim2.new(0.5, -12, 0.5, -12)
    crossFrame.BackgroundTransparency = 1
    crossFrame.BorderSizePixel = 0
    crossFrame.Parent = gui

    local crossLines = {}
    for i = 1, 4 do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = S.crossColor
        line.BorderSizePixel = 0
        line.Visible = false
        line.Parent = crossFrame
        crossLines[i] = line
    end

    local crossDot = Instance.new("Frame")
    crossDot.Size = UDim2.new(0, 2, 0, 2)
    crossDot.Position = UDim2.new(0.5, -1, 0.5, -1)
    crossDot.BackgroundColor3 = S.crossColor
    crossDot.BorderSizePixel = 0
    crossDot.Visible = false
    crossDot.Parent = crossFrame

    local crossCircle = Instance.new("Frame")
    crossCircle.Size = UDim2.new(1, 0, 1, 0)
    crossCircle.BackgroundTransparency = 1
    crossCircle.Visible = false
    crossCircle.Parent = crossFrame
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = S.crossColor
    circleStroke.Thickness = 1
    circleStroke.Parent = crossCircle
    Instance.new("UICorner", crossCircle).CornerRadius = UDim.new(1, 0)

    local crossImageLabel = Instance.new("ImageLabel")
    crossImageLabel.Size = UDim2.new(1, 0, 1, 0)
    crossImageLabel.BackgroundTransparency = 1
    crossImageLabel.Visible = false
    crossImageLabel.Parent = crossFrame

    _G.VankaUpdateCross = function()
        if not S.crosshair then
            crossFrame.Visible = false
            return
        end
        crossFrame.Visible = true
        for _, l in ipairs(crossLines) do l.Visible = false end
        crossDot.Visible = false
        crossCircle.Visible = false
        crossImageLabel.Visible = false

        if S.crossImage then
            crossImageLabel.Image = S.crossImage
            crossImageLabel.Visible = true
        elseif S.crossStyle == 1 then
            local l1 = crossLines[1]
            l1.Size = UDim2.new(0, 1, 0, 6)
            l1.Position = UDim2.new(0.5, -0.5, 0, 0)
            l1.BackgroundColor3 = S.crossColor
            l1.Visible = true
            local l2 = crossLines[2]
            l2.Size = UDim2.new(0, 1, 0, 6)
            l2.Position = UDim2.new(0.5, -0.5, 1, -6)
            l2.BackgroundColor3 = S.crossColor
            l2.Visible = true
            local l3 = crossLines[3]
            l3.Size = UDim2.new(0, 6, 0, 1)
            l3.Position = UDim2.new(0, 0, 0.5, -0.5)
            l3.BackgroundColor3 = S.crossColor
            l3.Visible = true
            local l4 = crossLines[4]
            l4.Size = UDim2.new(0, 6, 0, 1)
            l4.Position = UDim2.new(1, -6, 0.5, -0.5)
            l4.BackgroundColor3 = S.crossColor
            l4.Visible = true
        elseif S.crossStyle == 2 then
            crossDot.Visible = true
            crossDot.BackgroundColor3 = S.crossColor
        elseif S.crossStyle == 3 then
            crossCircle.Visible = true
            circleStroke.Color = S.crossColor
        end
    end
    _G.VankaUpdateCross()

    local fovFrame = Instance.new("Frame")
    fovFrame.Name = "VankaFOV"
    fovFrame.Size = UDim2.new(0, S.aimbotFOV * 2, 0, S.aimbotFOV * 2)
    fovFrame.Position = UDim2.new(0.5, -S.aimbotFOV, 0.5, -S.aimbotFOV)
    fovFrame.BackgroundTransparency = 1
    fovFrame.BorderSizePixel = 0
    fovFrame.Visible = false
    fovFrame.Parent = gui
    Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(1, 0)
    local fovStroke = Instance.new("UIStroke")
    fovStroke.Color = S.panelColor
    fovStroke.Thickness = 1
    fovStroke.Transparency = 0.5
    fovStroke.Parent = fovFrame

    local lastESPUpdate = 0
    local lastHLUpdate = 0
    local lastHitboxUpdate = 0

    RunService.RenderStepped:Connect(function(dt)
        if panelReady and S.crosshair then
            crossFrame.Visible = true
        elseif not S.crosshair then
            crossFrame.Visible = false
        end

        fovFrame.Visible = S.fovCircle and S.aimbot
        if fovFrame.Visible then
            fovFrame.Position = UDim2.new(0.5, -S.aimbotFOV, 0.5, -S.aimbotFOV)
        end

        local now = tick()

        if S.espEnabled then
            if now - lastESPUpdate > 0.1 then
                updateESP()
                lastESPUpdate = now
            end
        elseif next(S.espBillboards) then
            updateESP()
        end

        if S.roleHighlight then
            if now - lastHLUpdate > 0.15 then
                refreshHL()
                updateGunESP()
                lastHLUpdate = now
            end
        end

        if S.hitbox then
            if now - lastHitboxUpdate > 0.5 then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        for _, part in ipairs(plr.Character:GetDescendants()) do
                            if part:IsA("BasePart") and not part:FindFirstChild("VankaHitboxHL") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "VankaHitboxHL"
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.FillTransparency = 0.5
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = part
                            end
                        end
                    end
                end
                lastHitboxUpdate = now
            end
        end

        if S.lines then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head and not head:FindFirstChild("VankaLine") then
                        local att = Instance.new("Attachment")
                        att.Name = "VankaLine"
                        att.Parent = head
                        S.espLines[plr] = att
                    end
                end
            end
        end

        if S.fly and LP.Character then
            local char = LP.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                if not S.flyBV or S.flyBV.Parent ~= hrp then
                    if S.flyBV then S.flyBV:Destroy() end
                    S.flyBV = Instance.new("BodyVelocity")
                    S.flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    S.flyBV.Parent = hrp
                end
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                S.flyBV.Velocity = moveDir * (S.flySpeedValue or 50)
            end
        elseif S.flyBV then
            S.flyBV:Destroy()
            S.flyBV = nil
        end

        if S.noclip and LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end

        if S.spin and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed), 0)
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if S.infjump and LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if S.speed50Enabled then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = S.speedValue or 50 end
        end
        if S.invisibleEnabled then
            applyInvisible()
        end
        if S.autoShootEnabled then
            stopAutoShoot()
            startAutoShoot()
        end
    end)

    if S.roleHighlight then refreshHL() end
    hookSpeedRespawn()

    _G.VankaPanel = {
        Destroy = function()
            pcall(function()
                if S.gui then S.gui:Destroy() end
            end)
        end
    }
end

createGUI()
