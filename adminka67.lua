-- [[ АДМИНКА ВАНЬКА v2.2 - Delta Mobile Edition ]] --

if _G.VankaKill then pcall(_G.VankaKill) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ===== ЛОГОТИП =====
local LOGO = nil
local paths = {"vanya/adminka.png", "vanka/adminka.png", "adminka.png", "vanya/vanya.png", "vanya.png"}
if isfile and getcustomasset then
    for _, p in ipairs(paths) do
        local ok, exists = pcall(isfile, p)
        if ok and exists then
            local ok2, asset = pcall(getcustomasset, p)
            if ok2 and asset and asset ~= "" then
                LOGO = asset
                break
            end
        end
    end
end

-- ===== СОСТОЯНИЕ =====
local S = {
    roles = false,
    aim = false,
    fov = true,
    fovR = 180,
    camper = false,
    camperT = nil,
    wall = false,
    fly = false,
    noclip = false,
    infjump = false,
    speed = 16,
    jump = 50,
    hl = {},
    aimT = nil,
}

-- ===== GUI =====
local parent = (gethui and gethui()) or game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "VankaAdmin"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0, 10, 0.5, -210)
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
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
top.BorderSizePixel = 0
top.Parent = main

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 12)
tc.Parent = top

if LOGO then
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 30, 0, 30)
    img.Position = UDim2.new(0, 8, 0.5, -15)
    img.BackgroundTransparency = 1
    img.Image = LOGO
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = top
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 6)
    ic.Parent = img
else
    local em = Instance.new("TextLabel")
    em.Size = UDim2.new(0, 30, 1, 0)
    em.Position = UDim2.new(0, 8, 0, 0)
    em.BackgroundTransparency = 1
    em.Text = "🔥"
    em.TextSize = 20
    em.Font = Enum.Font.GothamBold
    em.Parent = top
end

local ttl = Instance.new("TextLabel")
ttl.Size = UDim2.new(1, -80, 1, 0)
ttl.Position = UDim2.new(0, 44, 0, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "АДМИНКА ВАНЬКА"
ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
ttl.TextSize = 14
ttl.Font = Enum.Font.GothamBold
ttl.TextXAlignment = Enum.TextXAlignment.Left
ttl.Parent = top

local closeB = Instance.new("TextButton")
closeB.Size = UDim2.new(0, 28, 0, 28)
closeB.Position = UDim2.new(1, -34, 0, 6)
closeB.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
closeB.Text = "×"
closeB.TextColor3 = Color3.new(1, 1, 1)
closeB.TextSize = 18
closeB.Font = Enum.Font.GothamBold
closeB.Parent = top
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = closeB

-- Кнопка-открывашка
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
    openB.TextColor3 = Color3.new(1, 1, 1)
end

-- Скролл
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -55)
scroll.Position = UDim2.new(0, 8, 0, 47)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 100)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = main

local ll = Instance.new("UIListLayout")
ll.Padding = UDim.new(0, 5)
ll.SortOrder = Enum.SortOrder.LayoutOrder
ll.Parent = scroll

ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 10)
end)

-- ===== ХЕЛПЕРЫ =====
local function mkBtn(text, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 34)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.TextWrapped = true
    b.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(cb, b)
        if not ok then warn("Vanka:", err) end
    end)
    return b
end

local function mkToggle(text, state, setter)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -6, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = scroll
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
    sw.Size = UDim2.new(0, 40, 0, 20)
    sw.Position = UDim2.new(1, -48, 0.5, -10)
    sw.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
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
        sw.BackgroundColor3 = new and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
        kn.Position = new and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end)
    return row
end

local function mkLabel(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = "▸ " .. text
    l.TextColor3 = color or Color3.fromRGB(255, 0, 100)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = scroll
    return l
end

-- ===== РОЛИ =====
local function getRole(plr)
    if not plr.Character then return nil end
    local function has(name)
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

-- ===== FOV КРУГ =====
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

-- ===== КНОПКИ =====
mkLabel("РОЛИ")

mkToggle("Подсветка ролей (К/С/З)", false, function(v)
    S.roles = v
    if v then refreshHL() else clearHL() end
end)

mkBtn("🔄 Обновить подсветку", Color3.fromRGB(40, 80, 160), function()
    refreshHL()
end)

mkLabel("ДЕЙСТВИЯ")

mkBtn("💀 Убить всех", Color3.fromRGB(170, 20, 30), function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                pcall(function() h.Health = 0 end)
            end
        end
    end
end)

mkBtn("🔪 Выдать Нож", Color3.fromRGB(120, 30, 30), function()
    if not LP.Backpack then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") then t:Destroy() end
    end
    local k = Instance.new("Tool")
    k.Name = "Knife"
    k.RequiresHandle = false
    k.Parent = LP.Backpack
end)

mkBtn("🔫 Выдать Пистолет", Color3.fromRGB(30, 60, 130), function()
    if not LP.Backpack then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") then t:Destroy() end
    end
    local g = Instance.new("Tool")
    g.Name = "Gun"
    g.RequiresHandle = false
    g.Parent = LP.Backpack
end)

mkBtn("🧹 Очистить инвентарь", Color3.fromRGB(60, 60, 60), function()
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

mkLabel("АВТО-КАМПЕР")

mkToggle("Кампер (за Шерифом)", false, function(v)
    S.camper = v
    if not v then S.camperT = nil end
end)

mkBtn("🔄 Найти Шерифа", Color3.fromRGB(80, 60, 130), function()
    S.camperT = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and getRole(plr) == "s" then
            S.camperT = plr
            break
        end
    end
end)

mkLabel("АИМ")

mkToggle("Аимбот", false, function(v) S.aim = v end)
mkToggle("Показывать FOV", true, function(v) S.fov = v end)

mkBtn("➕ FOV +20", Color3.fromRGB(60, 60, 90), function()
    S.fovR = math.min(S.fovR + 20, 500)
end)

mkBtn("➖ FOV -20", Color3.fromRGB(60, 60, 90), function()
    S.fovR = math.max(S.fovR - 20, 40)
end)

mkToggle("Стрельба через стены", false, function(v) S.wall = v end)

mkBtn("💥 Убить цель аима", Color3.fromRGB(170, 20, 30), function()
    if S.aimT and S.aimT.Character then
        local h = S.aimT.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

mkLabel("ДВИЖЕНИЕ")

mkToggle("Полёт (WASD+Space)", false, function(v) S.fly = v end)
mkToggle("Noclip", false, function(v) S.noclip = v end)
mkToggle("Беск. прыжок", false, function(v) S.infjump = v end)

mkBtn("⚡ Скорость 16", Color3.fromRGB(60, 60, 90), function()
    S.speed = 16
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end)

mkBtn("⚡ Скорость 50", Color3.fromRGB(60, 60, 90), function()
    S.speed = 50
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 50 end
    end
end)

mkBtn("⚡ Скорость 100", Color3.fromRGB(60, 60, 90), function()
    S.speed = 100
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 100 end
    end
end)

mkLabel("УТИЛИТЫ")

mkBtn("🔃 Respawn", Color3.fromRGB(100, 60, 150), function()
    if LP.Character then LP.Character:BreakJoints() end
end)

mkBtn("⛔ ВЫКЛЮЧИТЬ ВСЁ", Color3.fromRGB(180, 0, 100), function()
    S.aim = false
    S.wall = false
    S.camper = false
    S.camperT = nil
    S.roles = false
    S.fly = false
    S.noclip = false
    S.infjump = false
    clearHL()
    if LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = 16
            h.JumpPower = 50
        end
    end
end)

-- ===== ЦИКЛ =====
local conn = RunService.RenderStepped:Connect(function()
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
                        if d < S.fovR and d < dist then
                            dist = d
                            closest = plr
                        end
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
                    S.camperT = plr
                    break
                end
            end
        end
        if S.camperT and S.camperT.Character then
            local t = S.camperT.Character:FindFirstChild("HumanoidRootPart")
            local m = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if t and m then
                pcall(function()
                    m.CFrame = t.CFrame * CFrame.new(0, 0, 3)
                end)
            end
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
            if dir.Magnitude > 0 then
                hrp.Velocity = dir.Unit * 60
            else
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end

    if S.noclip and LP.Character then
        for _, p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
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
        if h and h.Health > 0 then
            pcall(function() h:TakeDamage(200) end)
        end
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

closeB.MouseButton1Click:Connect(cleanup)

openB.MouseButton1Click:Connect(function()
    main.Visible = true
    openB.Visible = false
end)

closeB.MouseButton1Click:Connect(function()
    main.Visible = false
    openB.Visible = true
end)

print("[VANKA v2.2] Загружено! Логотип: " .. (LOGO and "OK" or "NO"))
