-- АДМИНКА ВАНЬКА v21
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")

local LP     = Players.LocalPlayer
local Cam    = workspace.CurrentCamera
local Mouse  = LP:GetMouse()

-- ═════ ЯЗЫК ═════
local LANG = "ru" -- "ru" или "en"

local L = {
    ru = {
        title="АДМИНКА ВАНЬКА", loading="Загрузка", init="Инициализация", logo="Загрузка логотипа",
        connect="Подключение к серверу", modules="Загрузка модулей", ui="Настройка интерфейса",
        update="Проверка обновлений", funcs="Загрузка функций", sync="Синхронизация",
        aim="Настройка прицела", final="Финальная настройка", ready="Готово", load="Загрузка скрипта",
        main="ГЛАВНАЯ", visual="ВИЗУАЛ", rage="РЕЙДЖ", players="ИГРОКИ", settings="НАСТРОЙКИ",
        sheriff_sec="★ ШЕРИФ (пистолет → точные выстрелы)",
        sheriff="ШЕРИФ (точный авто-выстрел)",
        roles_esp="РОЛИ И ESP", esp_roles="Подсветка ролей (К/С/З)",
        autopickup_sec="АВТО-ПОДБОР", autopickup="Авто-подбор (ТП на место смерти Шерифа)",
        clear_sec="ОЧИСТКА", clear_inv="Очистить инвентарь",
        cross_sec="ПРИЦЕЛ", cross="Показывать прицел", fov="Показывать FOV", hardaim="Жёсткий аим",
        move_sec="ДВИЖЕНИЕ", fly="Полёт", noclip="Noclip", infjump="Беск. прыжок",
        spd50="Скорость 50", spd100="Скорость 100",
        pose_sec="★ МЁРТВАЯ ПОЗА", pose="Мёртвая поза (лежу но хожу)",
        vis_sec="ВИЗУАЛ", fullbright="Fullbright",
        killall_sec="KILL ALL (авто)", killall="KILL ALL (проверка роли)",
        aim_sec="АИМ (ручной)", aimbot="Аимбот на Мардера", kill_aim="Убить цель аима",
        spin_sec="СПИНБОТ", spin="Спинбот",
        util_sec="УТИЛИТЫ", respawn="Респавн", disable_all="ВЫКЛЮЧИТЬ ВСЁ",
        lang_sec="ЯЗЫК", lang_ru="Русский", lang_en="English",
        plist="СПИСОК ИГРОКОВ", tp="ТП", fling="ФЛИНГ",
        no_gun="Пистолет не найден", wait_gun="ШЕРИФ: жду пистолет", target="Цель",
        killed="Убил", fling_run="Флингаю", fling_ko="В космосе", fling_done="Отфлингался",
        fling_dead="Уничтожен", no_target="Нет цели", sheriff_off="Шериф ВЫКЛ",
        all_killed="Все убиты", killed_one="Убит", not_killed="Не убит", all_off="Всё выключено",
        pose_on="Мёртвая поза ВКЛ", pose_off="Мёртвая поза ВЫКЛ",
        gun_gone="Пистолет пропал", auto_off="Авто выкл",
    },
    en = {
        title="VANKA ADMIN", loading="Loading", init="Initializing", logo="Loading logo",
        connect="Connecting to server", modules="Loading modules", ui="Configuring UI",
        update="Checking updates", funcs="Loading functions", sync="Synchronizing",
        aim="Setting up aim", final="Final setup", ready="Ready", load="Script loading",
        main="MAIN", visual="VISUAL", rage="RAGE", players="PLAYERS", settings="SETTINGS",
        sheriff_sec="★ SHERIFF (gun → accurate shots)",
        sheriff="SHERIFF (accurate auto-shoot)",
        roles_esp="ROLES & ESP", esp_roles="Role highlight (K/S/I)",
        autopickup_sec="AUTO-PICKUP", autopickup="Auto-pickup (TP to Sheriff death)",
        clear_sec="CLEAR", clear_inv="Clear inventory",
        cross_sec="CROSSHAIR", cross="Show crosshair", fov="Show FOV", hardaim="Hard aim",
        move_sec="MOVEMENT", fly="Fly", noclip="Noclip", infjump="Infinite jump",
        spd50="Speed 50", spd100="Speed 100",
        pose_sec="★ DEAD POSE", pose="Dead pose (lying but walking)",
        vis_sec="VISUAL", fullbright="Fullbright",
        killall_sec="KILL ALL (auto)", killall="KILL ALL (check role)",
        aim_sec="AIM (manual)", aimbot="Aimbot to Murderer", kill_aim="Kill aim target",
        spin_sec="SPINBOT", spin="Spinbot",
        util_sec="UTILITIES", respawn="Respawn", disable_all="TURN OFF ALL",
        lang_sec="LANGUAGE", lang_ru="Русский", lang_en="English",
        plist="PLAYERS LIST", tp="TP", fling="FLING",
        no_gun="Gun not found", wait_gun="SHERIFF: waiting for gun", target="Target",
        killed="Killed", fling_run="Flinging", fling_ko="In space", fling_done="Flinged",
        fling_dead="Destroyed", no_target="No target", sheriff_off="Sheriff OFF",
        all_killed="All killed", killed_one="Killed", not_killed="Not killed", all_off="All disabled",
        pose_on="Dead pose ON", pose_off="Dead pose OFF",
        gun_gone="Gun gone", auto_off="Auto OFF",
    }
}

local function T(key) return L[LANG][key] or key end

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

local LOGO     = downloadImg("vanya.png")
local IMG_MAIN = downloadImg("main.png")
local IMG_VIS  = downloadImg("visial.png")
local IMG_RAGE = downloadImg("rage.png")

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
    deadPose=false, deadAnim=nil,
    conns={}, gui=nil, panel=nil,
    fullbright=false, oldLighting=nil,
    uiRefs={},
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

-- ═════════════════════════════════════════════════════════════════
-- ФЛИНГ v21: РЕАЛЬНО РАБОЧИЙ
-- Метод: Weld жертвы к якорю + сверх-скорость через AssemblyLinearVelocity
-- ═════════════════════════════════════════════════════════════════
local function fling(target)
    if not target or target == LP or not target.Character then
        notify(T("no_target"), Color3.fromRGB(255,60,60))
        return
    end
    local tChar = target.Character
    local tHrp = tChar:FindFirstChild("HumanoidRootPart")
    local tHum = tChar:FindFirstChildOfClass("Humanoid")
    if not tHrp or not tHum then return end
    
    notify(T("fling_run") .. ": " .. target.Name, Color3.fromRGB(255,0,150))
    
    task.spawn(function()
        -- 1) Захват network ownership на ВСЕХ частях
        for _, p in ipairs(tChar:GetDescendants()) do
            if p:IsA("BasePart") then 
                pcall(function() p:SetNetworkOwner(LP) end) 
            end
        end
        
        -- 2) Сохраняем оригинальную позицию
        local origCF = tHrp.CFrame
        local origY = origCF.Position.Y
        
        -- 3) Создаём НЕВИДИМЫЙ якорь (невидимая часть)
        local anchor = Instance.new("Part")
        anchor.Size = Vector3.new(1, 1, 1)
        anchor.Transparency = 1
        anchor.CanCollide = false
        anchor.Anchored = true
        anchor.CFrame = origCF
        anchor.Parent = workspace
        
        -- 4) Weld ВСЕХ частей тела жертвы к якорю
        local welds = {}
        for _, p in ipairs(tChar:GetDescendants()) do
            if p:IsA("BasePart") and p ~= tHrp then
                local w = Instance.new("WeldConstraint")
                w.Part0 = p
                w.Part1 = tHrp
                w.Parent = p
                table.insert(welds, w)
            end
        end
        
        -- 5) Убираем все существующие Motor6D/Weld жертвы
        for _, m in ipairs(tChar:GetDescendants()) do
            if m:IsA("Motor6D") or (m:IsA("Weld") and not m:IsDescendantOf(tHrp)) then
                pcall(function() m:Destroy() end)
            end
        end
        
        -- 6) Создаём BodyVelocity с огромной силой на HRP
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(1e5, 1e5, 1e5)
        bv.Parent = tHrp
        
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(1e5, 1e5, 1e5)
        bav.Parent = tHrp
        
        -- 7) ХАОТИЧНЫЕ ВРЕЗАНИЯ МЕЖДУ ТЕЛОМ
        local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local wasAnchored = false
        if myHrp then
            wasAnchored = myHrp.Anchored
            -- НЕ якорим чтобы не застрять, но отключаем коллизию
        end
        
        local startTime = tick()
        local hitCount = 0
        
        while tick() - startTime < 2.5 do
            if not target.Character or not target.Character.Parent then break end
            local curHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not curHrp then break end
            
            -- Случайная точка сферы вокруг жертвы
            local a1 = math.random() * math.pi * 2
            local a2 = math.random() * math.pi - math.pi/2
            local r = math.random(1, 3)
            local ox = math.cos(a1) * math.cos(a2) * r
            local oy = math.sin(a2) * r
            local oz = math.sin(a1) * math.cos(a2) * r
            
            if myHrp then
                pcall(function()
                    myHrp.CFrame = curHrp.CFrame * CFrame.new(ox, oy, oz)
                end)
            end
            
            -- Обновляем velocity жертвы СВЕЖИМИ случайными значениями
            pcall(function()
                curHrp.AssemblyLinearVelocity = Vector3.new(
                    math.random(-5000, 5000),
                    math.random(3000, 8000),
                    math.random(-5000, 5000)
                )
                curHrp.AssemblyAngularVelocity = Vector3.new(
                    math.random(-500, 500),
                    math.random(-500, 500),
                    math.random(-500, 500)
                )
                bv.Velocity = Vector3.new(
                    math.random(-3000, 3000),
                    math.random(2000, 5000),
                    math.random(-3000, 3000)
                )
            end)
            
            hitCount = hitCount + 1
            task.wait()
        end
        
        -- 8) Убираем BodyVelocity
        if bv then pcall(function() bv:Destroy() end) end
        if bav then pcall(function() bav:Destroy() end) end
        
        -- 9) Оставляем всё как есть (тело продолжает лететь само)
        -- Просто удаляем якорь, оставляя скорость
        if anchor then pcall(function() anchor:Destroy() end) end
        
        if myHrp and wasAnchored ~= nil then
            myHrp.Anchored = wasAnchored
        end
        
        -- 10) ПРОВЕРКА РЕАЛЬНОГО РЕЗУЛЬТАТА
        task.wait(1.5)
        local finalHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if finalHRP then
            local newY = finalHRP.Position.Y
            local rise = newY - origY
            
            if newY > 500 then
                notify(target.Name .. " " .. T("fling_ko") .. "!", Color3.fromRGB(255,100,200))
            elseif rise > 20 then
                notify(target.Name .. " " .. T("fling_done") .. " (+" .. math.floor(rise) .. " studs)", Color3.fromRGB(100,200,255))
            else
                notify(target.Name .. " не откинуло", Color3.fromRGB(255,150,50))
            end
        else
            notify(target.Name .. " " .. T("fling_dead"), Color3.fromRGB(255,0,100))
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════
-- ШЕРИФ v21: точный авто-выстрел
-- ═════════════════════════════════════════════════════════════════
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
                if currentTarget then notify(T("gun_gone"), Color3.fromRGB(150,150,150)); currentTarget = nil end
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
                            if h and h.Health > 0 then
                                currentTarget = plr
                                notify(T("target") .. ": " .. plr.Name, Color3.fromRGB(255,0,100))
                                break
                            end
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
                notify(T("killed") .. " " .. currentTarget.Name .. "!", Color3.fromRGB(0,255,100))
                currentTarget = nil
                task.wait(0.2)
                continue
            end
            
            -- Захват контроля
            for _, p in ipairs(tChar:GetDescendants()) do
                if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
            end
            
            local hitbox = findHead(tChar)
            if not hitbox then task.wait(0.05) continue end
            
            -- ТП за спину
            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHrp and tHrp then
                pcall(function()
                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
                    myHrp.Velocity = Vector3.new(0, 0, 0)
                end)
            end
            
            -- Точная наводка камеры
            local targetPos = hitbox.Position
            for _ = 1, 4 do
                local newCF = CFrame.new(Cam.CFrame.Position, targetPos)
                Cam.CFrame = Cam.CFrame:Lerp(newCF, 0.9)
            end
            
            -- Проверка точности
            local lookDir = Cam.CFrame.LookVector
            local toTarget = (targetPos - Cam.CFrame.Position).Unit
            local dot = lookDir:Dot(toTarget)
            
            if dot > 0.999 then
                -- Точно наведён — 15 выстрелов
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if tool and isGun(tool) then
                    for i = 1, 15 do
                        pcall(function() tool:Activate() end)
                    end
                end
            elseif dot > 0.995 then
                -- Почти наведён — доворачиваем и стреляем
                local newCF = CFrame.new(Cam.CFrame.Position, targetPos)
                Cam.CFrame = newCF
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if tool and isGun(tool) then
                    for i = 1, 10 do
                        pcall(function() tool:Activate() end)
                    end
                end
            end
            
            task.wait()
        end
        
        S.autoGunThread = nil
        notify(T("sheriff_off"), Color3.fromRGB(150,150,150))
    end)
end

local function stopAutoGunPlay()
    S.autoGunPlay = false
    S.autoGunThread = nil
end

-- ═════ АВТО-ПОДБОР ═════
local function startAutoPickup()
    if S.sheriffThread then return end
    S.lastSheriff = nil
    S.lastSheriffPos = nil
    S.sheriffThread = task.spawn(function()
        while S.autoPickup do
            local currentSheriff = nil
            local currentPos = nil
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    if getRole(plr) == "Sheriff" then
                        currentSheriff = plr
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then currentPos = hrp.CFrame end
                        break
                    end
                end
            end
            if currentSheriff and currentPos then S.lastSheriffPos = currentPos end
            if S.lastSheriff and not currentSheriff and S.lastSheriffPos then
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
            S.lastSheriff = currentSheriff
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

-- ═════ МЁРТВАЯ ПОЗА ═════
local DEATH_ANIM_ID = "rbxassetid://282574440"

local function toggleDeadPose(enabled)
    S.deadPose = enabled
    if not LP.Character then return end
    local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then animator = Instance.new("Animator") animator.Parent = humanoid end
    
    if enabled then
        if not S.deadAnim then
            local anim = Instance.new("Animation")
            anim.AnimationId = DEATH_ANIM_ID
            S.deadAnim = animator:LoadAnimation(anim)
            S.deadAnim.Looped = true
            S.deadAnim.Priority = Enum.AnimationPriority.Action4
        end
        if S.deadAnim then pcall(function() S.deadAnim:Play(0.1) end) end
        pcall(function() humanoid.PlatformStand = false end)
        notify(T("pose_on"), Color3.fromRGB(150,50,150))
    else
        if S.deadAnim then pcall(function() S.deadAnim:Stop(0.1) end) end
        notify(T("pose_off"), Color3.fromRGB(150,150,150))
    end
end

-- ═════ ESP ═════
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

-- ═════ KILL ALL ═════
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
            if not target then notify(T("all_killed"), Color3.fromRGB(0,200,100)) break end
            local ok = killOneTarget(target)
            S.killList[target] = true
            if ok then notify(T("killed_one") .. ": " .. target.Name, Color3.fromRGB(255,100,100))
            else notify(T("not_killed") .. ": " .. target.Name, Color3.fromRGB(200,150,50)) end
            task.wait(0.3)
        end
        S.killThread = nil
    end)
end

local function stopAutoKillAll()
    S.killList = {}
    S.killThread = nil
end

local function startKillAllLoop()
    if S.killLoopThread then return end
    S.killLoopThread = task.spawn(function()
        while S.killAllEnabled do
            local myRole = getRole(LP)
            if myRole == "Murderer" then
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

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 420, 0, 560)
    main.Position = UDim2.new(0, 15, 0.5, -280)
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
    mstk.Color = Color3.fromRGB(255,0,100)
    mstk.Thickness = 2
    mstk.Parent = main

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 24)
    tf.Position = UDim2.new(0, 0, 1, -24)
    tf.BackgroundColor3 = Color3.fromRGB(22,22,32)
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
        he.TextColor3 = Color3.fromRGB(255,0,100)
        he.TextSize = 24
        he.Font = Enum.Font.GothamBold
        he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -140, 1, 0)
    ttl.Position = UDim2.new(0, 56, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = T("title") .. " v21"
    ttl.TextColor3 = Color3.new(1,1,1)
    ttl.TextSize = 15
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = top
    S.uiRefs.title = ttl

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0, 30, 0, 30)
    minB.Position = UDim2.new(1, -74, 0, 10)
    minB.BackgroundColor3 = Color3.fromRGB(55,55,70)
    minB.Text = "−"
    minB.TextColor3 = Color3.new(1,1,1)
    minB.TextSize = 18
    minB.Font = Enum.Font.GothamBold
    minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 7)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0, 30, 0, 30)
    closeB.Position = UDim2.new(1, -40, 0, 10)
    closeB.BackgroundColor3 = Color3.fromRGB(255,55,75)
    closeB.Text = "×"
    closeB.TextColor3 = Color3.new(1,1,1)
    closeB.TextSize = 18
    closeB.Font = Enum.Font.GothamBold
    closeB.Parent = top
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, 7)

    local openB = Instance.new("TextButton")
    openB.Size = UDim2.new(0, 55, 0, 55)
    openB.Position = UDim2.new(0, 15, 0.5, -27)
    openB.BackgroundColor3 = Color3.fromRGB(255,0,100)
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

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 40)
    tabBar.Position = UDim2.new(0, 10, 0, 56)
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
    content.Size = UDim2.new(1, -20, 1, -160)
    content.Position = UDim2.new(0, 10, 0, 104)
    content.BackgroundTransparency = 1
    content.Parent = main

    local tabs, pages = {}, {}
    local function switchTab(name)
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and Color3.fromRGB(255,0,100) or Color3.fromRGB(32,32,44)
        end
    end

    local function addTab(key, img, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 90, 0, 32)
        b.BackgroundColor3 = Color3.fromRGB(32,32,44)
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        tabs[key] = b
        if img then
            local im = Instance.new("ImageLabel")
            im.Size = UDim2.new(0, 24, 0, 24)
            im.Position = UDim2.new(0.5, -12, 0.5, -12)
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
        p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = Color3.fromRGB(255,0,100)
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
        b.Size = UDim2.new(1, -6, 0, 34)
        b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.TextSize = 12
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
        row.Size = UDim2.new(1, -6, 0, 38)
        row.BackgroundColor3 = Color3.fromRGB(22,22,32)
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -64, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(230,230,240)
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0, 42, 0, 20)
        sw.Position = UDim2.new(1, -52, 0.5, -10)
        sw.BackgroundColor3 = initial and Color3.fromRGB(0,200,100) or Color3.fromRGB(55,55,70)
        sw.BorderSizePixel = 0
        sw.Parent = row
        Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
        local kn = Instance.new("Frame")
        kn.Size = UDim2.new(0, 16, 0, 16)
        kn.Position = initial and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
                Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            cb(st)
        end)
        return row
    end

    local function addLabel(parent, text)
        local w = Instance.new("Frame")
        w.Size = UDim2.new(1, -6, 0, 26)
        w.BackgroundTransparency = 1
        w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0, 3, 0, 16)
        a.Position = UDim2.new(0, 0, 0.5, -8)
        a.BackgroundColor3 = Color3.fromRGB(255,0,100)
        a.BorderSizePixel = 0
        a.Parent = w
        Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -12, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(255,100,150)
        l.TextSize = 11
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = w
    end

    -- Табы
    local tabMain    = addTab("main", IMG_MAIN)
    local tabVisual  = addTab("visual", IMG_VIS)
    local tabRage    = addTab("rage", IMG_RAGE)
    local tabPlayers = addTab("players", nil, T("players"))
    local tabSettings = addTab("settings", nil, T("settings"))
    switchTab("main")

    -- ═ MAIN ═
    addLabel(tabMain, T("sheriff_sec"))
    addToggle(tabMain, T("sheriff"), false, function(v)
        S.autoGunPlay = v
        if v then startAutoGunPlay() else stopAutoGunPlay() end
    end)

    addLabel(tabMain, T("roles_esp"))
    addToggle(tabMain, T("esp_roles"), false, function(v)
        S.roleHighlight = v
        if v then refreshHL() else clearHL() end
    end)

    addLabel(tabMain, T("autopickup_sec"))
    addToggle(tabMain, T("autopickup"), false, function(v)
        S.autoPickup = v
        if v then startAutoPickup() else stopAutoPickup() end
    end)

    addLabel(tabMain, T("clear_sec"))
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

    addLabel(tabVisual, T("move_sec"))
    addToggle(tabVisual, T("fly"), false, function(v) S.fly = v end)
    addToggle(tabVisual, T("noclip"), false, function(v) S.noclip = v end)
    addToggle(tabVisual, T("infjump"), false, function(v) S.infjump = v end)
    addBtn(tabVisual, T("spd50"), Color3.fromRGB(60,60,90), function()
        if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 50 end end
    end)
    addBtn(tabVisual, T("spd100"), Color3.fromRGB(60,60,90), function()
        if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 100 end end
    end)

    addLabel(tabVisual, T("pose_sec"))
    addToggle(tabVisual, T("pose"), false, function(v) toggleDeadPose(v) end)

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

    -- ═ RAGE ═
    addLabel(tabRage, T("killall_sec"))
    addToggle(tabRage, T("killall"), false, function(v)
        S.killAllEnabled = v
        if v then startKillAllLoop() else stopKillAllLoop() end
    end)

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
        S.autoGunPlay=false S.deadPose=false
        stopKillAllLoop() stopAutoPickup() stopAutoGunPlay()
        if S.deadAnim then pcall(function() S.deadAnim:Stop() end) end
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
    pList.Size = UDim2.new(1, -6, 0, 340)
    pList.BackgroundColor3 = Color3.fromRGB(16,16,24)
    pList.BorderSizePixel = 0
    pList.Parent = tabPlayers
    Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 10)
    local pScroll = Instance.new("ScrollingFrame")
    pScroll.Size = UDim2.new(1, -10, 1, -10)
    pScroll.Position = UDim2.new(0, 5, 0, 5)
    pScroll.BackgroundTransparency = 1
    pScroll.BorderSizePixel = 0
    pScroll.ScrollBarThickness = 4
    pScroll.ScrollBarImageColor3 = Color3.fromRGB(255,0,100)
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
                row.Size = UDim2.new(1, -4, 0, 42)
                row.BackgroundColor3 = Color3.fromRGB(26,26,36)
                row.BorderSizePixel = 0
                row.Parent = pScroll
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0, 32, 0, 32)
                av.Position = UDim2.new(0, 5, 0.5, -16)
                av.BackgroundColor3 = Color3.fromRGB(40,40,55)
                av.BorderSizePixel = 0
                av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                av.Parent = row
                Instance.new("UICorner", av).CornerRadius = UDim.new(0, 16)

                local tag = Instance.new("Frame")
                tag.Size = UDim2.new(0, 6, 0, 26)
                tag.Position = UDim2.new(0, 41, 0.5, -13)
                tag.BackgroundColor3 = roleColor(plr)
                tag.BorderSizePixel = 0
                tag.Parent = row
                Instance.new("UICorner", tag).CornerRadius = UDim.new(1, 0)

                local nm = Instance.new("TextLabel")
                nm.Size = UDim2.new(1, -170, 1, 0)
                nm.Position = UDim2.new(0, 54, 0, 0)
                nm.BackgroundTransparency = 1
                nm.Text = plr.Name
                nm.TextColor3 = Color3.fromRGB(230,230,240)
                nm.TextSize = 11
                nm.Font = Enum.Font.GothamMedium
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.TextTruncate = Enum.TextTruncate.AtEnd
                nm.Parent = row

                local tpB = Instance.new("TextButton")
                tpB.Size = UDim2.new(0, 34, 0, 26)
                tpB.Position = UDim2.new(1, -118, 0.5, -13)
                tpB.BackgroundColor3 = Color3.fromRGB(40,100,200)
                tpB.Text = T("tp")
                tpB.TextColor3 = Color3.new(1,1,1)
                tpB.TextSize = 10
                tpB.Font = Enum.Font.GothamBold
                tpB.Parent = row
                Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, 5)
                tpB.MouseButton1Click:Connect(function()
                    if plr.Character and LP.Character then
                        local t = plr.Character:FindFirstChild("HumanoidRootPart")
                        local m = LP.Character:FindFirstChild("HumanoidRootPart")
                        if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0,0,4) end) end
                    end
                end)

                local flB = Instance.new("TextButton")
                flB.Size = UDim2.new(0, 60, 0, 26)
                flB.Position = UDim2.new(1, -80, 0.5, -13)
                flB.BackgroundColor3 = Color3.fromRGB(180,20,100)
                flB.Text = T("fling")
                flB.TextColor3 = Color3.new(1,1,1)
                flB.TextSize = 10
                flB.Font = Enum.Font.GothamBold
                flB.Parent = row
                Instance.new("UICorner", flB).CornerRadius = UDim.new(0, 5)
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
        S.gui:Destroy()
        _G.VankaPanel = nil
        task.wait(0.1)
        local scr = game:GetService("CoreGui")
        pcall(function()
            loadstring(game:HttpGet(GH .. "../refs/heads/main/adminka67.lua"))()
        end)
    end)
    addBtn(tabSettings, T("lang_en"), Color3.fromRGB(50,80,150), function()
        LANG = "en"
        notify("Change language by editing LANG variable in script", Color3.fromRGB(200,200,100))
    end)

    closeB.MouseButton1Click:Connect(function()
        pcall(clearHL)
        stopKillAllLoop()
        stopAutoPickup()
        stopAutoGunPlay()
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
local crossH, crossV, crossDot, fovCircle

local function createOverlays()
    crossH = Instance.new("Frame")
    crossH.Size = UDim2.new(0, 16, 0, 2)
    crossH.Position = UDim2.new(0.5, -8, 0.5, -1)
    crossH.BackgroundColor3 = Color3.fromRGB(255,0,100)
    crossH.BorderSizePixel = 0
    crossH.Parent = S.gui

    crossV = Instance.new("Frame")
    crossV.Size = UDim2.new(0, 2, 0, 16)
    crossV.Position = UDim2.new(0.5, -1, 0.5, -8)
    crossV.BackgroundColor3 = Color3.fromRGB(255,0,100)
    crossV.BorderSizePixel = 0
    crossV.Parent = S.gui

    crossDot = Instance.new("Frame")
    crossDot.Size = UDim2.new(0, 4, 0, 4)
    crossDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    crossDot.BackgroundColor3 = Color3.new(1,1,1)
    crossDot.BorderSizePixel = 0
    crossDot.Parent = S.gui
    Instance.new("UICorner", crossDot).CornerRadius = UDim.new(1, 0)

    fovCircle = Instance.new("Frame")
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Size = UDim2.new(0, 400, 0, 400)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.Parent = S.gui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    local fs = Instance.new("UIStroke")
    fs.Color = Color3.fromRGB(255,0,100)
    fs.Thickness = 1.5
    fs.Transparency = 0.35
    fs.Parent = fovCircle
end

local function mainLoop()
    local conn = RunService.RenderStepped:Connect(function(dt)
        if not S.gui then return end
        if crossH then
            local show = S.crosshair
            crossH.Visible = show
            crossV.Visible = show
            crossDot.Visible = show
        end
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
        ls.Text = T("load") .. ": 0%"
        ls.TextColor3 = Color3.fromRGB(180,180,210)
        ls.TextSize = 15
        ls.Font = Enum.Font.GothamMedium
        ls.ZIndex = 501
        ls.Parent = lf

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1,0,0,18)
        sub.Position = UDim2.new(0,0,0.5,100)
        sub.BackgroundTransparency = 1
        sub.Text = T("init") .. "..."
        sub.TextColor3 = Color3.fromRGB(120,120,150)
        sub.TextSize = 12
        sub.Font = Enum.Font.Gotham
        sub.ZIndex = 501
        sub.Parent = lf

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
        bf.BackgroundColor3 = Color3.fromRGB(255,0,100)
        bf.BorderSizePixel = 0
        bf.ZIndex = 502
        bf.Parent = bb
        Instance.new("UICorner", bf).CornerRadius = UDim.new(1,0)

        local stages = {
            {p=5,   t=T("init"),    d=0.7},
            {p=12,  t=T("logo"),    d=0.7},
            {p=20,  t=T("connect"), d=0.8},
            {p=30,  t=T("modules"), d=0.7},
            {p=40,  t=T("ui"),      d=0.8},
            {p=50,  t=T("update"),  d=0.7},
            {p=60,  t=T("funcs"),   d=0.8},
            {p=70,  t=T("sync"),    d=0.7},
            {p=80,  t=T("aim"),     d=0.8},
            {p=90,  t=T("final"),   d=0.7},
            {p=100, t=T("ready"),   d=0.9},
        }
        for _, st in ipairs(stages) do
            ls.Text = T("load") .. ": " .. st.p .. "%"
            sub.Text = st.t .. "..."
            local tw = TweenService:Create(bf, TweenInfo.new(st.d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(st.p/100, 0, 1, 0)
            })
            tw:Play()
            task.wait(st.d)
        end
        task.wait(0.5)
        TweenService:Create(lf, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
        for _, c in ipairs(lf:GetDescendants()) do
            if c:IsA("TextLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.7), {TextTransparency = 1}):Play() end)
            elseif c:IsA("ImageLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.7), {ImageTransparency = 1}):Play() end)
            elseif c:IsA("Frame") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play() end)
            end
        end
        task.wait(0.8)
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
        if S.gui then pcall(function() S.gui:Destroy() end) end
        _G.VankaPanel = nil
    end
}

createGUI()
createOverlays()
mainLoop()
setupInfJump()
runLoading()

print("[VANKA v21] OK")
