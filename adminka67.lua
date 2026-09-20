-- ◆ АДМИНКА ВАНЬКА v15 ◆
if _G.VankaPanel and _G.VankaPanel.Destroy then pcall(_G.VankaPanel.Destroy) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local Mouse = LP:GetMouse()

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

local S = {
    roleHighlight=false, roleHL={},
    aimbot=false, aimbotFOV=200, aimT=nil,
    hardAim=true,
    autoTPShoot=false,
    autoPickup=false, sheriffThread=nil, lastSheriffPos=nil, lastSheriff=nil,
    camper=false, camperT=nil,
    spin=false, spinSpeed=30,
    fly=false, noclip=false, infjump=false,
    crosshair=true, fovCircle=true,
    killAllEnabled=false, killList={}, killThread=nil, killLoopThread=nil,
    conns={}, gui=nil,
    fullbright=false, oldLighting=nil,
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
    s.Color = color
    s.Thickness = 2
    s.Parent = n
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = n
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 14, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.TextSize = 12
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.Parent = n
    n.Position = UDim2.new(1, 320, 0, 0)
    TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,0)}):Play()
    task.delay(3, function()
        local t = TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1,320,0,0)})
        t:Play()
        t.Completed:Connect(function() n:Destroy() end)
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

-- ═════ АВТО-ПОДБОР (простой ТП на место смерти Шерифа) ═════
local function startAutoPickup()
    if S.sheriffThread then return end
    S.lastSheriff = nil
    S.lastSheriffPos = nil
    
    S.sheriffThread = task.spawn(function()
        notify("Авто-подбор ВКЛ (слежу за Шерифом)", Color3.fromRGB(60,150,255))
        
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
            
            -- Обновляем позицию Шерифа пока жив
            if currentSheriff and currentPos then
                S.lastSheriffPos = currentPos
            end
            
            -- Шериф пропал → умер, ТП на его место и обратно
            if S.lastSheriff and not currentSheriff and S.lastSheriffPos then
                notify("Шериф умер! ТП на место...", Color3.fromRGB(255,220,0))
                task.wait(0.4) -- даём серверу создать пистолет
                
                if LP.Character then
                    local myHrp = LP.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        local myPos = myHrp.CFrame
                        
                        -- ТП на место смерти
                        pcall(function()
                            myHrp.CFrame = S.lastSheriffPos + Vector3.new(0, 3, 0)
                        end)
                        task.wait(1) -- стоим 1 секунду (подбираем всё что рядом)
                        
                        -- ТП обратно
                        pcall(function()
                            myHrp.CFrame = myPos
                        end)
                        
                        notify("ТП назад", Color3.fromRGB(0,200,100))
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

-- ═════ АВТО-ТП К МАРДЕРУ + ВЫСТРЕЛ ═════
local function autoTPShootMurderer()
    local target = S.aimT
    if not target or not target.Character then return end
    if getRole(target) ~= "Murderer" then return end
    
    if not hasGunInHand() then
        if not equipGun() then return end
        task.wait(0.15)
    end
    
    local myChar = LP.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp or not targetHrp then return end
    
    local myPos = myHrp.CFrame
    
    pcall(function()
        myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
    end)
    task.wait(0.05)
    
    local tool = myChar:FindFirstChildOfClass("Tool")
    if tool and isGun(tool) then
        for i = 1, 3 do
            pcall(function() tool:Activate() end)
            task.wait(0.05)
        end
    end
    
    task.wait(0.1)
    pcall(function()
        if myHrp and myHrp.Parent then
            myHrp.CFrame = myPos
        end
    end)
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

local function fling(target)
    if not target or target == LP or not target.Character then
        notify("Нет цели", Color3.fromRGB(255,60,60))
        return
    end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not myHrp then return end
    notify("ФЛИНГ: " .. target.Name, Color3.fromRGB(255,0,150))
    local myPos = myHrp.CFrame
    task.spawn(function()
        for _, p in ipairs(target.Character:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LP) end) end
        end
        for i = 1, 100 do
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then break end
            if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then break end
            local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not tHrp then break end
            pcall(function()
                LP.Character.HumanoidRootPart.CFrame = tHrp.CFrame
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-1e5,1e5), math.random(-1e5,1e5), math.random(-1e5,1e5))
                LP.Character.HumanoidRootPart.RotVelocity = Vector3.new(1e5, 1e5, 1e5)
            end)
            task.wait()
        end
        for i = 1, 30 do
            if not target.Character then break end
            local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not tHrp then break end
            pcall(function()
                tHrp.Velocity = Vector3.new(1e6, 1e6, 1e6)
                tHrp.RotVelocity = Vector3.new(1e6, 1e6, 1e6)
            end)
            task.wait()
        end
        task.wait(0.5)
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = myPos
                LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end)
        task.wait(2)
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local y = target.Character.HumanoidRootPart.Position.Y
            if y > 500 then notify(target.Name .. " В КОСМОСЕ!", Color3.fromRGB(255,100,200))
            else notify(target.Name .. " отфлингован", Color3.fromRGB(100,200,255)) end
        else
            notify(target.Name .. " УНИЧТОЖЕН!", Color3.fromRGB(255,0,100))
        end
    end)
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
            if not target then notify("ВСЕ УБИТЫ ✓", Color3.fromRGB(0,200,100)) break end
            local ok = killOneTarget(target)
            S.killList[target] = true
            if ok then notify("Убит: " .. target.Name, Color3.fromRGB(255,100,100))
            else notify("Не убит: " .. target.Name, Color3.fromRGB(200,150,50)) end
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
        notify("KILL ALL: жду роль Мардера...", Color3.fromRGB(255,150,0))
        while S.killAllEnabled do
            local myRole = getRole(LP)
            if myRole == "Murderer" then
                if not S.killThread then
                    notify("Я МАРДЕР! Убиваю...", Color3.fromRGB(255,0,100))
                    startAutoKillAll()
                end
            else
                if S.killThread then
                    stopAutoKillAll()
                    notify("Раунд кончился, жду...", Color3.fromRGB(150,150,150))
                end
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
    main.Size = UDim2.new(0, 380, 0, 500)
    main.Position = UDim2.new(0, 15, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(13,13,20)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local mstk = Instance.new("UIStroke")
    mstk.Color = Color3.fromRGB(255,0,100)
    mstk.Thickness = 2
    mstk.Parent = main

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 46)
    top.BackgroundColor3 = Color3.fromRGB(22,22,32)
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 20)
    tf.Position = UDim2.new(0, 0, 1, -20)
    tf.BackgroundColor3 = Color3.fromRGB(22,22,32)
    tf.BorderSizePixel = 0
    tf.Parent = top

    if LOGO then
        local li = Instance.new("ImageLabel")
        li.Size = UDim2.new(0, 32, 0, 32)
        li.Position = UDim2.new(0, 10, 0.5, -16)
        li.BackgroundTransparency = 1
        li.Image = LOGO
        li.ScaleType = Enum.ScaleType.Fit
        li.Parent = top
        Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8)
    else
        local he = Instance.new("TextLabel")
        he.Size = UDim2.new(0, 32, 1, 0)
        he.Position = UDim2.new(0, 10, 0, 0)
        he.BackgroundTransparency = 1
        he.Text = "V"
        he.TextColor3 = Color3.fromRGB(255,0,100)
        he.TextSize = 22
        he.Font = Enum.Font.GothamBold
        he.Parent = top
    end

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -130, 1, 0)
    ttl.Position = UDim2.new(0, 50, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = "АДМИНКА ВАНЬКА v15"
    ttl.TextColor3 = Color3.new(1,1,1)
    ttl.TextSize = 14
    ttl.Font = Enum.Font.GothamBold
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = top

    local minB = Instance.new("TextButton")
    minB.Size = UDim2.new(0, 28, 0, 28)
    minB.Position = UDim2.new(1, -70, 0, 9)
    minB.BackgroundColor3 = Color3.fromRGB(55,55,70)
    minB.Text = "−"
    minB.TextColor3 = Color3.new(1,1,1)
    minB.TextSize = 18
    minB.Font = Enum.Font.GothamBold
    minB.Parent = top
    Instance.new("UICorner", minB).CornerRadius = UDim.new(0, 7)

    local closeB = Instance.new("TextButton")
    closeB.Size = UDim2.new(0, 28, 0, 28)
    closeB.Position = UDim2.new(1, -38, 0, 9)
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
    tabBar.Size = UDim2.new(1, -16, 0, 38)
    tabBar.Position = UDim2.new(0, 8, 0, 52)
    tabBar.BackgroundColor3 = Color3.fromRGB(20,20,28)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 4)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tl.Parent = tabBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 1, -146)
    content.Position = UDim2.new(0, 8, 0, 98)
    content.BackgroundTransparency = 1
    content.Parent = main

    local tabs, pages = {}, {}
    local function switchTab(name)
        for k, p in pairs(pages) do p.Visible = (k == name) end
        for k, b in pairs(tabs) do
            b.BackgroundColor3 = (k == name) and Color3.fromRGB(255,0,100) or Color3.fromRGB(32,32,44)
        end
    end

    local function addTab(key, img)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 84, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(32,32,44)
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = tabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
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
            b.Text = key:upper()
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
        b.BackgroundColor3 = color or Color3.fromRGB(40,40,60)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.TextSize = 12
        b.Font = Enum.Font.GothamMedium
        b.TextWrapped = true
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        b.MouseButton1Click:Connect(function()
            local ok, err = pcall(cb, b)
            if not ok then notify("Ошибка: " .. tostring(err), Color3.fromRGB(255,60,60)) end
        end)
        return b
    end

    local function addToggle(parent, text, initial, cb)
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -6, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(22,22,32)
        row.Text = ""
        row.AutoButtonColor = false
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
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
        w.Size = UDim2.new(1, -6, 0, 24)
        w.BackgroundTransparency = 1
        w.Parent = parent
        local a = Instance.new("Frame")
        a.Size = UDim2.new(0, 3, 0, 14)
        a.Position = UDim2.new(0, 0, 0.5, -7)
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

    local tabMain    = addTab("main", IMG_MAIN)
    local tabVisual  = addTab("visual", IMG_VIS)
    local tabRage    = addTab("rage", IMG_RAGE)
    local tabPlayers = addTab("players", nil)
    switchTab("main")

    addLabel(tabMain, "РОЛИ И ESP")
    addToggle(tabMain, "Подсветка ролей (К/С/З)", false, function(v)
        S.roleHighlight = v
        if v then refreshHL() else clearHL() end
    end)
    addBtn(tabMain, "Обновить подсветку", Color3.fromRGB(40,80,160), function() refreshHL() end)

    addLabel(tabMain, "АВТО-КАМПЕР")
    addToggle(tabMain, "Кампер за Шерифом", false, function(v)
        S.camper = v
        if not v then S.camperT = nil end
    end)
    addBtn(tabMain, "Найти Шерифа", Color3.fromRGB(80,60,130), function()
        S.camperT = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and getRole(plr) == "Sheriff" then
                S.camperT = plr
                notify("Шериф: " .. plr.Name, Color3.fromRGB(60,150,255))
                break
            end
        end
    end)

    addLabel(tabMain, "АВТО-ПОДБОР (ТП на место смерти Шерифа)")
    addToggle(tabMain, "Авто-подбор (ТП на 1 сек)", false, function(v)
        S.autoPickup = v
        if v then startAutoPickup() else stopAutoPickup() end
    end)
    addBtn(tabMain, "ТП на место сейчас", Color3.fromRGB(200,150,0), function()
        if not S.lastSheriffPos then
            notify("Позиция Шерифа неизвестна", Color3.fromRGB(255,60,60))
            return
        end
        if LP.Character then
            local myHrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                local myPos = myHrp.CFrame
                pcall(function() myHrp.CFrame = S.lastSheriffPos + Vector3.new(0, 3, 0) end)
                task.wait(1)
                pcall(function() myHrp.CFrame = myPos end)
                notify("ТП на место + назад", Color3.fromRGB(0,200,100))
            end
        end
    end)

    addLabel(tabMain, "ОЧИСТКА")
    addBtn(tabMain, "Очистить инвентарь", Color3.fromRGB(60,60,70), function()
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

    addLabel(tabVisual, "ПРИЦЕЛ")
    addToggle(tabVisual, "Показывать прицел", true, function(v) S.crosshair = v end)
    addToggle(tabVisual, "Показывать FOV", true, function(v) S.fovCircle = v end)
    addToggle(tabVisual, "Жёсткий аим", true, function(v) S.hardAim = v end)
    addBtn(tabVisual, "FOV +20", Color3.fromRGB(60,60,90), function()
        S.aimbotFOV = math.min(S.aimbotFOV + 20, 600)
        notify("FOV: " .. S.aimbotFOV, Color3.fromRGB(100,200,255))
    end)
    addBtn(tabVisual, "FOV -20", Color3.fromRGB(60,60,90), function()
        S.aimbotFOV = math.max(S.aimbotFOV - 20, 40)
        notify("FOV: " .. S.aimbotFOV, Color3.fromRGB(100,200,255))
    end)

    addLabel(tabVisual, "ДВИЖЕНИЕ")
    addToggle(tabVisual, "Полёт", false, function(v) S.fly = v end)
    addToggle(tabVisual, "Noclip", false, function(v) S.noclip = v end)
    addToggle(tabVisual, "Беск. прыжок", false, function(v) S.infjump = v end)
    addBtn(tabVisual, "Скорость 16", Color3.fromRGB(60,60,90), function()
        if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 16 end end
    end)
    addBtn(tabVisual, "Скорость 50", Color3.fromRGB(60,60,90), function()
        if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 50 end end
    end)
    addBtn(tabVisual, "Скорость 100", Color3.fromRGB(60,60,90), function()
        if LP.Character then local h = LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = 100 end end
    end)

    addLabel(tabVisual, "ВИЗУАЛ")
    addToggle(tabVisual, "Fullbright", false, function(v)
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

    addLabel(tabRage, "KILL ALL (авто)")
    addToggle(tabRage, "KILL ALL (проверка роли)", false, function(v)
        S.killAllEnabled = v
        if v then startKillAllLoop() else stopKillAllLoop() end
    end)
    addBtn(tabRage, "Сбросить чёрный список", Color3.fromRGB(80,80,80), function()
        S.killList = {}
        notify("Список сброшен", Color3.fromRGB(150,150,150))
    end)

    addLabel(tabRage, "АИМ (только Мардер)")
    addToggle(tabRage, "Аимбот на Мардера", false, function(v) S.aimbot = v end)
    addToggle(tabRage, "Авто-ТП к Мардеру + выстрел", false, function(v) S.autoTPShoot = v end)
    addBtn(tabRage, "Убить цель аима", Color3.fromRGB(170,20,30), function()
        if S.aimT and S.aimT.Character then
            local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end)

    addLabel(tabRage, "СПИНБОТ")
    addToggle(tabRage, "Спинбот", false, function(v) S.spin = v end)
    addBtn(tabRage, "Скорость 30", Color3.fromRGB(60,60,90), function(b) S.spinSpeed = 30 b.Text = "Скорость 30" end)
    addBtn(tabRage, "Скорость 60", Color3.fromRGB(60,60,90), function(b) S.spinSpeed = 60 b.Text = "Скорость 60" end)
    addBtn(tabRage, "Скорость 120", Color3.fromRGB(60,60,90), function(b) S.spinSpeed = 120 b.Text = "Скорость 120" end)

    addLabel(tabRage, "УТИЛИТЫ")
    addBtn(tabRage, "Respawn", Color3.fromRGB(100,60,150), function()
        if LP.Character then LP.Character:BreakJoints() end
    end)
    addBtn(tabRage, "ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180,0,100), function()
        S.aimbot=false S.autoTPShoot=false S.camper=false S.camperT=nil
        S.roleHighlight=false S.fly=false S.noclip=false S.infjump=false
        S.spin=false S.autoPickup=false
        S.killAllEnabled=false S.killList={}
        stopKillAllLoop()
        stopAutoPickup()
        clearHL()
        if LP.Character then
            local h = LP.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed=16 h.JumpPower=50 end
        end
        notify("Всё выключено", Color3.fromRGB(255,60,60))
    end)

    addLabel(tabPlayers, "СПИСОК ИГРОКОВ")
    local pList = Instance.new("Frame")
    pList.Size = UDim2.new(1, -6, 0, 340)
    pList.BackgroundColor3 = Color3.fromRGB(16,16,24)
    pList.BorderSizePixel = 0
    pList.Parent = tabPlayers
    Instance.new("UICorner", pList).CornerRadius = UDim.new(0, 8)
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
                tpB.Text = "ТП"
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
                flB.Text = "ФЛИНГ"
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

    closeB.MouseButton1Click:Connect(function()
        pcall(clearHL)
        stopKillAllLoop()
        stopAutoPickup()
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

local crossH, crossV, crossDot, fovCircle, targetInfo

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

    targetInfo = Instance.new("TextLabel")
    targetInfo.Size = UDim2.new(0, 240, 0, 24)
    targetInfo.Position = UDim2.new(0.5, -120, 0, 40)
    targetInfo.BackgroundColor3 = Color3.fromRGB(20,20,30)
    targetInfo.BackgroundTransparency = 0.3
    targetInfo.Text = ""
    targetInfo.TextColor3 = Color3.fromRGB(255,100,150)
    targetInfo.TextSize = 12
    targetInfo.Font = Enum.Font.GothamBold
    targetInfo.Visible = false
    targetInfo.Parent = S.gui
    Instance.new("UICorner", targetInfo).CornerRadius = UDim.new(0, 6)
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
                if S.hardAim then
                    Cam.CFrame = CFrame.new(Cam.CFrame.Position, cl.Character.Head.Position)
                else
                    local t = CFrame.new(Cam.CFrame.Position, cl.Character.Head.Position)
                    Cam.CFrame = Cam.CFrame:Lerp(t, 0.35)
                end
                if targetInfo then
                    targetInfo.Visible = true
                    targetInfo.Text = "ЦЕЛЬ: " .. cl.Name .. " [МАРДЕР]"
                end
            else
                S.aimT = nil
                if targetInfo then targetInfo.Visible = false end
            end
        elseif targetInfo then
            targetInfo.Visible = false
        end

        if S.autoTPShoot and S.aimT and S.aimT.Character then
            if getRole(S.aimT) == "Murderer" then
                task.spawn(autoTPShootMurderer)
            end
        end

        if S.spin and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed * dt * 60), 0)
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
                    if plr ~= LP and plr.Character and getRole(plr) == "Sheriff" then
                        S.camperT = plr break
                    end
                end
            end
            if S.camperT and S.camperT.Character then
                local t = S.camperT.Character:FindFirstChild("HumanoidRootPart")
                local m = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if t and m then pcall(function() m.CFrame = t.CFrame * CFrame.new(0,0,3) end) end
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
            li.Size = UDim2.new(0,160,0,160)
            li.Position = UDim2.new(0.5,-80,0.5,-150)
            li.BackgroundTransparency = 1
            li.Image = LOGO
            li.ScaleType = Enum.ScaleType.Fit
            li.ZIndex = 501
            li.Parent = lf
        end

        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1,0,0,36)
        lt.Position = UDim2.new(0,0,0.5,30)
        lt.BackgroundTransparency = 1
        lt.Text = "АДМИНКА ВАНЬКА"
        lt.TextColor3 = Color3.new(1,1,1)
        lt.TextSize = 26
        lt.Font = Enum.Font.GothamBold
        lt.ZIndex = 501
        lt.Parent = lf

        local ls = Instance.new("TextLabel")
        ls.Size = UDim2.new(1,0,0,22)
        ls.Position = UDim2.new(0,0,0.5,70)
        ls.BackgroundTransparency = 1
        ls.Text = "Загрузка: 0%"
        ls.TextColor3 = Color3.fromRGB(180,180,210)
        ls.TextSize = 15
        ls.Font = Enum.Font.GothamMedium
        ls.ZIndex = 501
        ls.Parent = lf

        local bb = Instance.new("Frame")
        bb.Size = UDim2.new(0,320,0,10)
        bb.Position = UDim2.new(0.5,-160,0.5,130)
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
            {p=10,t="Загрузка...",d=0.4},
            {p=30,t="Подключение...",d=0.4},
            {p=50,t="Модули...",d=0.4},
            {p=70,t="Интерфейс...",d=0.4},
            {p=90,t="Почти готово...",d=0.4},
            {p=100,t="Готово!",d=0.6},
        }
        for _, st in ipairs(stages) do
            ls.Text = "Загрузка: " .. st.p .. "%"
            local tw = TweenService:Create(bf, TweenInfo.new(st.d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(st.p/100, 0, 1, 0)
            })
            tw:Play()
            task.wait(st.d)
        end
        task.wait(0.3)
        TweenService:Create(lf, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        for _, c in ipairs(lf:GetDescendants()) do
            if c:IsA("TextLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.5), {TextTransparency = 1}):Play() end)
            elseif c:IsA("ImageLabel") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.5), {ImageTransparency = 1}):Play() end)
            elseif c:IsA("Frame") then
                pcall(function() TweenService:Create(c, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() end)
            end
        end
        task.wait(0.6)
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
        if S.gui then pcall(function() S.gui:Destroy() end) end
        _G.VankaPanel = nil
    end
}

createGUI()
createOverlays()
mainLoop()
setupInfJump()
runLoading()

task.delay(6, function() notify("Админка v15 загружена!", Color3.fromRGB(255,0,100)) end)

print("[VANKA v15] OK")
