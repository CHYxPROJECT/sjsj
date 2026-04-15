-- ============================================================
--   BLOX PANEL  ·  by NanaChan
--   Blox Fruits  ·  Compatible with Delta Executor
--   VERSION: 5.0 (With Casanova Silent Aim)
-- ============================================================

-- ============================================================
--  [0] INTRO
-- ============================================================
local function RunIntro()
    local TS2 = game:GetService("TweenService")
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "BloxIntro"
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 999
    pcall(function() introGui.Parent = game:GetService("CoreGui") end)
    if not introGui.Parent then
        introGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local bg = Instance.new("Frame", introGui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    bg.BorderSizePixel = 0

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1,0,0,70)
    title.Position = UDim2.new(0,0,0.3,0)
    title.BackgroundTransparency = 1
    title.Text = "BLOX PANEL"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 50
    title.TextScaled = false
    title.TextStrokeTransparency = 0.3
    title.TextStrokeColor3 = Color3.fromRGB(0, 80, 160)
    title.TextTransparency = 1

    local sub1 = Instance.new("TextLabel", bg)
    sub1.Size = UDim2.new(1,0,0,24)
    sub1.Position = UDim2.new(0,0,0.3,78)
    sub1.BackgroundTransparency = 1
    sub1.Text = "by NanaChan"
    sub1.TextColor3 = Color3.fromRGB(150, 200, 255)
    sub1.Font = Enum.Font.GothamBold
    sub1.TextSize = 16
    sub1.TextTransparency = 1

    local sub2 = Instance.new("TextLabel", bg)
    sub2.Size = UDim2.new(1,0,0,18)
    sub2.Position = UDim2.new(0,0,0.3,108)
    sub2.BackgroundTransparency = 1
    sub2.Text = "Loading..."
    sub2.TextColor3 = Color3.fromRGB(80, 120, 180)
    sub2.Font = Enum.Font.Gotham
    sub2.TextSize = 12
    sub2.TextTransparency = 1

    task.spawn(function()
        task.wait(0.5)
        TS2:Create(title, TweenInfo.new(0.6), {TextTransparency=0}):Play()
        task.wait(0.3)
        TS2:Create(sub1, TweenInfo.new(0.4), {TextTransparency=0}):Play()
        task.wait(0.2)
        TS2:Create(sub2, TweenInfo.new(0.4), {TextTransparency=0}):Play()
        task.wait(2)
        local fi = TweenInfo.new(0.5)
        TS2:Create(bg, fi, {BackgroundTransparency=1}):Play()
        TS2:Create(title, fi, {TextTransparency=1}):Play()
        TS2:Create(sub1, fi, {TextTransparency=1}):Play()
        TS2:Create(sub2, fi, {TextTransparency=1}):Play()
        task.wait(0.6)
        introGui:Destroy()
    end)
end

RunIntro()
task.wait(3)

-- ============================================================
--  [1] SERVICES
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ============================================================
--  [2] COLORS
-- ============================================================
local C = {
    bg = Color3.fromRGB(15, 18, 28),
    surface = Color3.fromRGB(25, 30, 42),
    surface2 = Color3.fromRGB(35, 40, 55),
    accent = Color3.fromRGB(0, 180, 255),
    accentLight = Color3.fromRGB(80, 210, 255),
    accentDark = Color3.fromRGB(0, 80, 140),
    text = Color3.fromRGB(220, 230, 255),
    textDim = Color3.fromRGB(130, 150, 190),
    red = Color3.fromRGB(220, 60, 60),
    green = Color3.fromRGB(60, 200, 100),
}

-- ============================================================
--  [3] SILENT AIM SETTINGS (Casanova Style)
-- ============================================================
local SilentAim = {
    Enabled = true,
    ToggleKey = "Q",
    TeamCheck = false,
    VisibleCheck = false,
    TargetPart = "HumanoidRootPart",
    SilentAimMethod = "FindPartOnRay",
    FOVRadius = 130,
    FOVVisible = false,
    ShowTarget = false,
    HitChance = 100,
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
}

-- Drawing objects
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = SilentAim.FOVRadius
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.Color = Color3.fromRGB(0, 180, 255)

local target_box = Drawing.new("Square")
target_box.Visible = false
target_box.Thickness = 2
target_box.Color = Color3.fromRGB(0, 255, 100)
target_box.Size = Vector2.new(30, 30)
target_box.Filled = false

-- Helper functions
local function GetMousePosition()
    return UserInputService:GetMouseLocation()
end

local function WorldToViewport(point)
    local vec, onScreen = Camera:WorldToViewportPoint(point)
    return Vector2.new(vec.X, vec.Y), onScreen
end

local function IsPlayerVisible(player)
    local char = player.Character
    local localChar = LP.Character
    if not char or not localChar then return false end
    
    local targetPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not targetPart then return false end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local ray = Ray.new(origin, direction)
    
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {localChar, char})
    return hit == nil or hit:IsDescendantOf(char)
end

local function GetClosestTarget()
    local closest = nil
    local closestDist = SilentAim.FOVRadius
    local mousePos = GetMousePosition()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LP then continue end
        if SilentAim.TeamCheck and player.Team == LP.Team then continue end
        
        local char = player.Character
        if not char then continue end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        if SilentAim.VisibleCheck and not IsPlayerVisible(player) then continue end
        
        local targetPart = nil
        if SilentAim.TargetPart == "Head" then
            targetPart = char:FindFirstChild("Head")
        elseif SilentAim.TargetPart == "Random" then
            local parts = {"Head", "HumanoidRootPart"}
            targetPart = char[parts[math.random(1, #parts)]]
        else
            targetPart = char:FindFirstChild("HumanoidRootPart")
        end
        
        if not targetPart then continue end
        
        local screenPos, onScreen = WorldToViewport(targetPart.Position)
        if not onScreen then continue end
        
        local dist = (mousePos - screenPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = targetPart
        end
    end
    
    return closest
end

local function CalculateChance(percentage)
    return math.random(1, 100) <= percentage
end

-- Hook functions for Silent Aim
local expectedArgs = {
    FindPartOnRayWithIgnoreList = {3, {"Instance", "Ray", "table"}},
    FindPartOnRayWithWhitelist = {3, {"Instance", "Ray", "table"}},
    FindPartOnRay = {2, {"Instance", "Ray"}},
    Raycast = {3, {"Instance", "Vector3", "Vector3"}},
}

local function ValidateArgs(args, method)
    local req = expectedArgs[method]
    if not req then return false end
    if #args < req[1] then return false end
    return true
end

-- Silent Aim Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    local self = args[1]
    
    if SilentAim.Enabled and self == workspace and not checkcaller() and CalculateChance(SilentAim.HitChance) then
        local target = GetClosestTarget()
        
        if target and (method == SilentAim.SilentAimMethod or 
           (method == "FindPartOnRay" and SilentAim.SilentAimMethod == "FindPartOnRay") or
           (method == "Raycast" and SilentAim.SilentAimMethod == "Raycast")) then
            
            if ValidateArgs(args, method) then
                if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRay" then
                    local ray = args[2]
                    local origin = ray.Origin
                    local direction = (target.Position - origin).Unit * 1000
                    args[2] = Ray.new(origin, direction)
                    return oldNamecall(unpack(args))
                elseif method == "Raycast" then
                    local origin = args[2]
                    args[3] = (target.Position - origin).Unit * 1000
                    return oldNamecall(unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(...)
end))

-- Mouse hook for Mouse.Hit/Target method
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
    if self == Mouse and not checkcaller() and SilentAim.Enabled and SilentAim.SilentAimMethod == "Mouse.Hit/Target" then
        local target = GetClosestTarget()
        if target then
            if index == "Target" then
                return target
            elseif index == "Hit" then
                if SilentAim.MouseHitPrediction and target.Parent:FindFirstChild("HumanoidRootPart") then
                    local hrp = target.Parent.HumanoidRootPart
                    return CFrame.new(target.Position + (hrp.Velocity * SilentAim.MouseHitPredictionAmount))
                end
                return CFrame.new(target.Position)
            end
        end
    end
    return oldIndex(self, index)
end))

-- Update FOV circle and target box
RunService.RenderStepped:Connect(function()
    if SilentAim.FOVVisible then
        fov_circle.Visible = true
        fov_circle.Position = GetMousePosition()
        fov_circle.Radius = SilentAim.FOVRadius
    else
        fov_circle.Visible = false
    end
    
    if SilentAim.ShowTarget and SilentAim.Enabled then
        local target = GetClosestTarget()
        if target then
            local pos, onScreen = WorldToViewport(target.Position)
            if onScreen then
                target_box.Visible = true
                target_box.Position = Vector2.new(pos.X - 15, pos.Y - 15)
            else
                target_box.Visible = false
            end
        else
            target_box.Visible = false
        end
    else
        target_box.Visible = false
    end
end)

-- ============================================================
--  [4] OTHER FEATURES
-- ============================================================
-- Fast Attack
local FastAttackEnabled = false
local FastAttackRange = 12000
local FastAttackConn = nil
local RegisterHit = nil
local RegisterAttack = nil

pcall(function()
    local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
    if Net then
        RegisterHit = Net["RE/RegisterHit"]
        RegisterAttack = Net["RE/RegisterAttack"]
    end
end)

local function AttackMultipleTargets(targets)
    pcall(function()
        if not targets or #targets == 0 then return end
        local all = {}
        for _, char in pairs(targets) do
            local head = char:FindFirstChild("Head")
            if head then
                table.insert(all, {char, head})
            end
        end
        if #all == 0 then return end
        if RegisterAttack then RegisterAttack:FireServer(0) end
        if RegisterHit then RegisterHit:FireServer(all[1][2], all) end
    end)
end

local function StartFastAttack()
    if FastAttackConn then task.cancel(FastAttackConn) end
    FastAttackConn = task.spawn(function()
        while FastAttackEnabled do
            task.wait(0.005)
            local myChar = LP.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHRP then continue end
            
            local targets = {}
            for _, pl in pairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character then
                    local hum = pl.Character:FindFirstChild("Humanoid")
                    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                        table.insert(targets, pl.Character)
                    end
                end
            end
            
            local en = workspace:FindFirstChild("Enemies")
            if en then
                for _, npc in pairs(en:GetChildren()) do
                    local hum = npc:FindFirstChild("Humanoid")
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 and (hrp.Position - myHRP.Position).Magnitude <= FastAttackRange then
                        table.insert(targets, npc)
                    end
                end
            end
            
            if #targets > 0 then AttackMultipleTargets(targets) end
        end
    end)
end

-- Movement
local InfJumpEnabled = false
local NoClipEnabled = false
local WalkWater = false
local SpeedEnabled = false
local SpeedValue = 16

RunService.Heartbeat:Connect(function()
    if SpeedEnabled and LP.Character then
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            LP.Character:TranslateBy(hum.MoveDirection * (SpeedValue / 55))
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if NoClipEnabled and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if WalkWater and hrp then
        if hrp.Position.Y >= 9.5 and hrp.Velocity.Y <= 0 then
            local wp = workspace:FindFirstChild("BloxWaterSolid")
            if not wp then
                wp = Instance.new("Part", workspace)
                wp.Name = "BloxWaterSolid"
                wp.Size = Vector3.new(20, 1, 20)
                wp.Transparency = 1
                wp.Anchored = true
                wp.CanCollide = true
                wp.CanQuery = false
            end
            wp.CFrame = CFrame.new(hrp.Position.X, 9.2, hrp.Position.Z)
        else
            local wp = workspace:FindFirstChild("BloxWaterSolid")
            if wp then wp:Destroy() end
        end
    else
        local wp = workspace:FindFirstChild("BloxWaterSolid")
        if wp then wp:Destroy() end
    end
end)

-- Fruit Attack
local FruitAttack = false
local FruitAttackConn = nil

local function GetNearestPlayer()
    local nearest, dist = nil, math.huge
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

local function StartFruitAttack(toolName, extraArg)
    if FruitAttackConn then task.cancel(FruitAttackConn) end
    FruitAttackConn = task.spawn(function()
        while FruitAttack do
            task.wait(0.001)
            local target = GetNearestPlayer()
            if target and target.Character then
                local tool = LP.Character:FindFirstChild(toolName)
                if tool then
                    local dir = (target.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Unit
                    pcall(function()
                        if extraArg then
                            tool:WaitForChild("LeftClickRemote"):FireServer(dir, 1, true)
                        else
                            tool:WaitForChild("LeftClickRemote"):FireServer(dir, 1)
                        end
                    end)
                end
            end
        end
    end)
end

-- God Mode
local GodModeEnabled = false
local GodModeConns = {}

-- ESP
local ESPEnabled = false
local ESPBoxes = false
local ESPNames = false
local ESPObjects = {}

local function ClearESP()
    for _, o in pairs(ESPObjects) do
        if o and o.Parent then o:Destroy() end
    end
    ESPObjects = {}
end

local function UpdateESP()
    ClearESP()
    if not ESPEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            if ESPNames and head then
                local bb = Instance.new("BillboardGui")
                bb.Name = "BloxESP_Name"
                bb.Adornee = head
                bb.Size = UDim2.new(0, 120, 0, 30)
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.AlwaysOnTop = true
                bb.Parent = head
                local nl = Instance.new("TextLabel", bb)
                nl.BackgroundTransparency = 1
                nl.Size = UDim2.new(1, 0, 1, 0)
                nl.Text = p.Name
                nl.Font = Enum.Font.GothamBold
                nl.TextSize = 13
                nl.TextColor3 = C.accent
                nl.TextStrokeTransparency = 0
                table.insert(ESPObjects, bb)
            end
            
            if ESPBoxes then
                local bb2 = Instance.new("BillboardGui")
                bb2.Name = "BloxESP_Box"
                bb2.Adornee = hrp
                bb2.Size = UDim2.new(0, 50, 0, 70)
                bb2.AlwaysOnTop = true
                bb2.Parent = hrp
                local box = Instance.new("Frame", bb2)
                box.Size = UDim2.new(1, 0, 1, 0)
                box.BackgroundTransparency = 1
                local s = Instance.new("UIStroke", box)
                s.Color = C.accent
                s.Thickness = 2
                s.Transparency = 0.3
                table.insert(ESPObjects, bb2)
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(5)
        if ESPEnabled then UpdateESP() end
    end
end)

-- Full Bright
local FullBright = false

-- Auto V4
local AutoV4On = false

-- Player TP
local SelectedPlayer = nil
local TeleportEnabled = false
local InstaTpEnabled = false
local SpectateEnabled = false
local TeleportConn = nil
local InstaTpConn = nil
local SpectateConn = nil
local ActiveTween = nil

local function SetNoCollide()
    pcall(function()
        if not LP.Character then return end
        for _, v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end

local function SetCollide()
    pcall(function()
        if not LP.Character then return end
        for _, v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end)
end

local function TweenToPlayer(targetHRP)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = LP.Character.HumanoidRootPart
    local dist = (targetHRP.Position - HRP.Position).Magnitude
    if ActiveTween then ActiveTween:Cancel() end
    ActiveTween = TweenService:Create(HRP, TweenInfo.new(dist / 350, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetHRP.Position)})
    ActiveTween:Play()
end

-- ============================================================
--  [5] KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    -- Toggle Silent Aim (Q)
    if input.KeyCode == Enum.KeyCode[SilentAim.ToggleKey] then
        SilentAim.Enabled = not SilentAim.Enabled
    end
    
    -- Fast Attack (U)
    if input.KeyCode == Enum.KeyCode.U then
        FastAttackEnabled = not FastAttackEnabled
        if FastAttackEnabled then
            StartFastAttack()
        else
            if FastAttackConn then task.cancel(FastAttackConn) end
        end
    end
    
    -- Fly Up (B)
    if input.KeyCode == Enum.KeyCode.B then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local flag = hrp:FindFirstChild("UpLoop")
            if flag then
                flag:Destroy()
            else
                flag = Instance.new("BoolValue", hrp)
                flag.Name = "UpLoop"
                task.spawn(function()
                    while flag.Parent do
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, 273861, 0)
                        task.wait(0.05)
                    end
                end)
            end
        end
    end
end)

-- ============================================================
--  [6] GUI
-- ============================================================
local pgui = LP:WaitForChild("PlayerGui")
if pgui:FindFirstChild("BloxPanel") then pgui.BloxPanel:Destroy() end
local ScreenGui = Instance.new("ScreenGui", pgui)
ScreenGui.Name = "BloxPanel"
ScreenGui.ResetOnSpawn = false

local SIZES = {
    {name="Mini", w=380, h=340},
    {name="Normal", w=500, h=430},
    {name="Large", w=620, h=520},
    {name="Extra", w=740, h=610},
}
local currentSizeIdx = 2
local S = SIZES[currentSizeIdx]
local W, H = S.w, S.h
local HDR_H = 50
local SB_H = 28
local SIDE_W = 110
local BODY_Y = HDR_H + 10

-- Helper functions
local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.accent
    s.Thickness = th or 1
    s.Transparency = tr or 0.5
end

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2), props):Play()
end

local function mkLbl(parent, text, sz, col, bold, xAl, x, y, w, h)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = sz
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextColor3 = col
    l.TextXAlignment = xAl or Enum.TextXAlignment.Left
    l.Size = UDim2.new(0, w, 0, h)
    l.Position = UDim2.new(0, x, 0, y)
    return l
end

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, W, 0, H)
Main.Position = UDim2.new(0.5, -W / 2, 0.3, 0)
Main.BackgroundColor3 = C.bg
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
corner(Main, 10)
stroke(Main, C.accent, 1, 0.4)

-- Reopen Button
local ReopenBtn = Instance.new("TextButton", ScreenGui)
ReopenBtn.Size = UDim2.new(0, 130, 0, 36)
ReopenBtn.Position = UDim2.new(0.5, -65, 0.3, 0)
ReopenBtn.BackgroundColor3 = C.surface
ReopenBtn.Text = "▲ BLOX PANEL"
ReopenBtn.TextColor3 = C.accentLight
ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.TextSize = 11
ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false
corner(ReopenBtn, 8)
stroke(ReopenBtn, C.accent, 1, 0.3)

-- HEADER
local Hdr = Instance.new("Frame", Main)
Hdr.Size = UDim2.new(1, 0, 0, HDR_H)
Hdr.BackgroundColor3 = C.surface
Hdr.BorderSizePixel = 0
corner(Hdr, 10)

local HDLine = Instance.new("Frame", Hdr)
HDLine.Size = UDim2.new(1, 0, 1, 0)
HDLine.Position = UDim2.new(0, 0, 1, -1)
HDLine.BackgroundColor3 = C.accent
HDLine.BorderSizePixel = 0

mkLbl(Hdr, "BLOX PANEL", 16, C.accentLight, true, Enum.TextXAlignment.Left, 12, 8, 140, 26)
mkLbl(Hdr, "by NanaChan", 10, C.textDim, false, Enum.TextXAlignment.Left, 12, 32, 120, 16)

local function winBtn(txt, bg2, xOff)
    local b = Instance.new("TextButton", Hdr)
    b.Size = UDim2.new(0, 24, 0, 24)
    b.Position = UDim2.new(1, xOff, 0, 13)
    b.BackgroundColor3 = bg2
    b.Text = txt
    b.TextColor3 = C.white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    corner(b, 12)
    return b
end

local CloseBtn = winBtn("✕", C.red, -30)
local MinBtn = winBtn("–", C.surface2, -58)

-- SIDEBAR
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, SIDE_W, 1, -BODY_Y - SB_H)
Sidebar.Position = UDim2.new(0, 0, 0, BODY_Y)
Sidebar.BackgroundColor3 = C.surface
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = C.accentDark
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SBLine = Instance.new("Frame", Main)
SBLine.Size = UDim2.new(0, 1, 1, -BODY_Y - SB_H)
SBLine.Position = UDim2.new(0, SIDE_W, 0, BODY_Y)
SBLine.BackgroundColor3 = C.accentDark
SBLine.BorderSizePixel = 0

local ContentBG = Instance.new("Frame", Main)
ContentBG.Size = UDim2.new(1, -SIDE_W - 1, 1, -BODY_Y - SB_H)
ContentBG.Position = UDim2.new(0, SIDE_W + 1, 0, BODY_Y)
ContentBG.BackgroundColor3 = C.bg
ContentBG.BorderSizePixel = 0
ContentBG.ClipsDescendants = true

-- PAGE SYSTEM
local pages = {}
local currentPage = nil
local sideBtnRefs = {}

local function newPage(id)
    local sf = Instance.new("ScrollingFrame", ContentBG)
    sf.Name = id
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.accent
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Visible = false
    sf.BorderSizePixel = 0
    
    local ul = Instance.new("UIListLayout", sf)
    ul.Padding = UDim.new(0, 6)
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    
    local up = Instance.new("UIPadding", sf)
    up.PaddingTop = UDim.new(0, 8)
    up.PaddingBottom = UDim.new(0, 8)
    up.PaddingLeft = UDim.new(0, 8)
    up.PaddingRight = UDim.new(0, 8)
    
    pages[id] = sf
    return sf
end

local function showPage(id)
    for pid, pg in pairs(pages) do
        pg.Visible = (pid == id)
    end
    currentPage = id
    for _, r in pairs(sideBtnRefs) do
        local act = (r.page == id)
        r.bar.BackgroundColor3 = act and C.accent or C.surface
        r.lbl.TextColor3 = act and C.accentLight or C.textDim
        r.frame.BackgroundColor3 = act and C.surface2 or C.surface
    end
end

-- COMPONENT BUILDERS
local function secLabel(text, parent, lo)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, 0, 0, 24)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = lo
    
    local l = Instance.new("TextLabel", wrap)
    l.Size = UDim2.new(0, 0, 1, 0)
    l.AutomaticSize = Enum.AutomaticSize.X
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 9
    l.TextColor3 = C.textDim
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local line = Instance.new("Frame", wrap)
    line.Size = UDim2.new(1, -85, 0, 1)
    line.Position = UDim2.new(0, 80, 0.5, 0)
    line.BackgroundColor3 = C.accentDark
    line.BorderSizePixel = 0
end

local function makeToggle(icon, name, desc, parent, lo, callback)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 54)
    row.BackgroundColor3 = C.surface
    row.Text = ""
    row.AutoButtonColor = false
    row.BorderSizePixel = 0
    row.LayoutOrder = lo
    corner(row, 8)
    stroke(row, C.accentDark, 1, 0.5)
    
    mkLbl(row, icon, 18, C.accent, false, Enum.TextXAlignment.Left, 10, 0, 30, 54)
    local nameLbl = mkLbl(row, name, 12, C.text, true, Enum.TextXAlignment.Left, 46, 8, W - SIDE_W - 100, 18)
    mkLbl(row, desc, 9, C.textDim, false, Enum.TextXAlignment.Left, 46, 30, W - SIDE_W - 100, 16)
    
    local swBg = Instance.new("Frame", row)
    swBg.Size = UDim2.new(0, 38, 0, 20)
    swBg.Position = UDim2.new(1, -46, 0.5, -10)
    swBg.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    swBg.BorderSizePixel = 0
    corner(swBg, 10)
    stroke(swBg, C.accentDark, 1, 0.4)
    
    local knob = Instance.new("Frame", swBg)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = C.textDim
    knob.BorderSizePixel = 0
    corner(knob, 7)
    
    local isOn = false
    local function setState(on)
        isOn = on
        if on then
            tw(knob, {Position = UDim2.new(0, 21, 0.5, -7), BackgroundColor3 = C.accent}, 0.15)
            tw(swBg, {BackgroundColor3 = Color3.fromRGB(40, 45, 70)}, 0.15)
            tw(row, {BackgroundColor3 = Color3.fromRGB(30, 35, 55)}, 0.15)
            nameLbl.TextColor3 = C.accentLight
            local rs = row:FindFirstChildOfClass("UIStroke")
            if rs then rs.Color = C.accent; rs.Transparency = 0.3 end
        else
            tw(knob, {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = C.textDim}, 0.15)
            tw(swBg, {BackgroundColor3 = Color3.fromRGB(30, 35, 50)}, 0.15)
            tw(row, {BackgroundColor3 = C.surface}, 0.15)
            nameLbl.TextColor3 = C.text
            local rs = row:FindFirstChildOfClass("UIStroke")
            if rs then rs.Color = C.accentDark; rs.Transparency = 0.5 end
        end
        if callback then callback(on) end
    end
    
    row.MouseButton1Click:Connect(function()
        setState(not isOn)
    end)
    return row, setState
end

local function makeBtn(icon, name, desc, parent, lo, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = C.surface
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = lo
    corner(btn, 8)
    stroke(btn, C.accentDark, 1, 0.5)
    
    mkLbl(btn, icon, 18, C.accent, false, Enum.TextXAlignment.Left, 10, 0, 30, 48)
    local nameLbl = mkLbl(btn, name, 12, C.text, true, Enum.TextXAlignment.Left, 46, 7, W - SIDE_W - 80, 18)
    mkLbl(btn, desc, 9, C.textDim, false, Enum.TextXAlignment.Left, 46, 27, W - SIDE_W - 80, 16)
    mkLbl(btn, "▶", 12, C.textDim, true, Enum.TextXAlignment.Right, 0, 0, W - SIDE_W - 14, 48)
    
    btn.MouseEnter:Connect(function()
        tw(btn, {BackgroundColor3 = Color3.fromRGB(30, 35, 55)}, 0.1)
        nameLbl.TextColor3 = C.accentLight
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = C.accent; s.Transparency = 0.3 end
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, {BackgroundColor3 = C.surface}, 0.1)
        nameLbl.TextColor3 = C.text
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = C.accentDark; s.Transparency = 0.5 end
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function makeSlider(name, minV, maxV, startV, parent, lo, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.LayoutOrder = lo
    corner(card, 8)
    stroke(card, C.accentDark, 1, 0.5)
    
    mkLbl(card, name, 11, C.text, true, Enum.TextXAlignment.Left, 12, 6, W - SIDE_W - 90, 16)
    local valLbl = mkLbl(card, tostring(startV), 11, C.accent, true, Enum.TextXAlignment.Right, 0, 6, W - SIDE_W - 16, 16)
    
    local minusBtn = Instance.new("TextButton", card)
    minusBtn.Size = UDim2.new(0, 26, 0, 26)
    minusBtn.Position = UDim2.new(0, 10, 0, 28)
    minusBtn.BackgroundColor3 = C.surface2
    minusBtn.Text = "−"
    minusBtn.TextColor3 = C.accentLight
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 16
    minusBtn.BorderSizePixel = 0
    corner(minusBtn, 6)
    
    local plusBtn = Instance.new("TextButton", card)
    plusBtn.Size = UDim2.new(0, 26, 0, 26)
    plusBtn.Position = UDim2.new(1, -36, 0, 28)
    plusBtn.BackgroundColor3 = C.surface2
    plusBtn.Text = "+"
    plusBtn.TextColor3 = C.accentLight
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 16
    plusBtn.BorderSizePixel = 0
    corner(plusBtn, 6)
    
    local trackBg = Instance.new("Frame", card)
    trackBg.Size = UDim2.new(1, -86, 0, 3)
    trackBg.Position = UDim2.new(0, 44, 0, 42)
    trackBg.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    trackBg.BorderSizePixel = 0
    corner(trackBg, 2)
    
    local fill = Instance.new("Frame", trackBg)
    local initPct = (startV - minV) / (maxV - minV)
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = C.accent
    fill.BorderSizePixel = 0
    corner(fill, 2)
    
    local val = startV
    local step = math.max(1, math.floor((maxV - minV) / 20))
    
    local function updateVal(newVal)
        val = math.clamp(newVal, minV, maxV)
        valLbl.Text = tostring(val)
        local pct = (val - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        if callback then callback(val) end
    end
    
    minusBtn.MouseButton1Click:Connect(function()
        updateVal(val - step)
    end)
    plusBtn.MouseButton1Click:Connect(function()
        updateVal(val + step)
    end)
    
    local dragging = false
    trackBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
            local tAbs = trackBg.AbsolutePosition
            local tSz = trackBg.AbsoluteSize
            local pct = math.clamp((i.Position.X - tAbs.X) / tSz.X, 0, 1)
            updateVal(math.floor(minV + (maxV - minV) * pct))
        end
    end)
    return card
end

local function makeDropdown(labelTxt, parent, lo, onSelect)
    local CW = W - SIDE_W - 20
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.LayoutOrder = lo
    card.ClipsDescendants = false
    corner(card, 8)
    stroke(card, C.accentDark, 1, 0.5)
    
    mkLbl(card, labelTxt, 10, C.textDim, false, Enum.TextXAlignment.Left, 12, 0, CW - 60, 42)
    local selLbl = mkLbl(card, "None", 11, C.accent, true, Enum.TextXAlignment.Right, 0, 0, CW - 10, 42)
    local arrow = mkLbl(card, "▾", 12, C.textDim, true, Enum.TextXAlignment.Right, 0, 0, CW - 10, 42)
    
    local listFrame = Instance.new("Frame", ContentBG)
    listFrame.BackgroundColor3 = C.surface2
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 20
    corner(listFrame, 6)
    stroke(listFrame, C.accent, 1, 0.4)
    
    local lLayout = Instance.new("UIListLayout", listFrame)
    lLayout.Padding = UDim.new(0, 1)
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local expanded = false
    local function buildList()
        for _, c in pairs(listFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local opts = {"None"}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(opts, p.Name) end
        end
        for i, opt in ipairs(opts) do
            local item = Instance.new("TextButton", listFrame)
            item.Size = UDim2.new(1, 0, 0, 28)
            item.BackgroundColor3 = C.surface
            item.Text = opt
            item.TextColor3 = C.text
            item.Font = Enum.Font.GothamBold
            item.TextSize = 10
            item.BorderSizePixel = 0
            item.ZIndex = 21
            item.LayoutOrder = i
            item.MouseButton1Click:Connect(function()
                selLbl.Text = opt
                expanded = false
                listFrame.Visible = false
                arrow.Text = "▾"
                if onSelect then onSelect(opt ~= "None" and opt or nil) end
            end)
            item.MouseEnter:Connect(function()
                item.BackgroundColor3 = C.surface2
            end)
            item.MouseLeave:Connect(function()
                item.BackgroundColor3 = C.surface
            end)
        end
        listFrame.Size = UDim2.new(0, CW - 20, 0, math.min(#opts, 6) * 29)
    end
    
    local hBtn = Instance.new("TextButton", card)
    hBtn.Size = UDim2.new(1, 0, 1, 0)
    hBtn.BackgroundTransparency = 1
    hBtn.Text = ""
    hBtn.BorderSizePixel = 0
    hBtn.ZIndex = 10
    hBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            buildList()
            local abs = card.AbsolutePosition
            local cbAb = ContentBG.AbsolutePosition
            listFrame.Position = UDim2.new(0, abs.X - cbAb.X + 8, 0, abs.Y - cbAb.Y + 42)
            listFrame.Visible = true
            arrow.Text = "▴"
        else
            listFrame.Visible = false
            arrow.Text = "▾"
        end
    end)
    return card, buildList
end

-- ============================================================
--  PAGES
-- ============================================================

-- HOME
local pgHome = newPage("home")

local logoCard = Instance.new("Frame", pgHome)
logoCard.Size = UDim2.new(1, 0, 0, 85)
logoCard.BackgroundColor3 = C.surface
logoCard.BorderSizePixel = 0
logoCard.LayoutOrder = 1
corner(logoCard, 8)
stroke(logoCard, C.accent, 1, 0.5)

local ring = Instance.new("Frame", logoCard)
ring.Size = UDim2.new(0, 55, 0, 55)
ring.Position = UDim2.new(0, 12, 0.5, -27.5)
ring.BackgroundColor3 = C.surface2
ring.BorderSizePixel = 0
corner(ring, 27.5)
stroke(ring, C.accent, 1.5, 0.3)

mkLbl(ring, "⚡", 24, C.accent, false, Enum.TextXAlignment.Center, 0, 0, 55, 55)
mkLbl(logoCard, "BLOX PANEL", 16, C.accentLight, true, Enum.TextXAlignment.Left, 80, 10, 200, 24)
mkLbl(logoCard, "by NanaChan", 10, C.textDim, false, Enum.TextXAlignment.Left, 80, 34, 160, 16)
mkLbl(logoCard, "[Q] Silent Aim  |  [U] Fast Attack  |  [B] Fly Up", 9, C.accent, false, Enum.TextXAlignment.Left, 80, 54, 320, 16)

secLabel("UI SIZE", pgHome, 2)

local sizeWrap = Instance.new("Frame", pgHome)
sizeWrap.Size = UDim2.new(1, 0, 0, 42)
sizeWrap.BackgroundColor3 = C.surface
sizeWrap.BorderSizePixel = 0
sizeWrap.LayoutOrder = 3
corner(sizeWrap, 8)
stroke(sizeWrap, C.accentDark, 1, 0.5)

local szLay = Instance.new("UIListLayout", sizeWrap)
szLay.FillDirection = Enum.FillDirection.Horizontal
szLay.Padding = UDim.new(0, 4)
szLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
szLay.VerticalAlignment = Enum.VerticalAlignment.Center

local sizeBtns = {}
local function applySize(idx)
    currentSizeIdx = idx
    local ns = SIZES[idx]
    W = ns.w
    H = ns.h
    tw(Main, {Size = UDim2.new(0, ns.w, 0, ns.h)}, 0.25)
    for i, sb in pairs(sizeBtns) do
        sb.BackgroundColor3 = i == idx and C.accentDark or C.surface2
        sb.TextColor3 = i == idx and C.accentLight or C.textDim
    end
end

for i, sz in ipairs(SIZES) do
    local sb = Instance.new("TextButton", sizeWrap)
    sb.Size = UDim2.new(0.22, -5, 0, 30)
    sb.BackgroundColor3 = i == currentSizeIdx and C.accentDark or C.surface2
    sb.TextColor3 = i == currentSizeIdx and C.accentLight or C.textDim
    sb.Text = sz.name
    sb.Font = Enum.Font.GothamBold
    sb.TextSize = 10
    sb.BorderSizePixel = 0
    corner(sb, 6)
    sb.MouseButton1Click:Connect(function()
        applySize(i)
    end)
    table.insert(sizeBtns, sb)
end

-- SILENT AIM PAGE (Casanova Style)
local pgSilentAim = newPage("silentaim")

secLabel("SILENT AIM SETTINGS", pgSilentAim, 1)

-- Enabled toggle
makeToggle("🎯", "Silent Aim [Q]", "Toggle on/off with Q key", pgSilentAim, 2, function(on)
    SilentAim.Enabled = on
end)

-- Team Check
makeToggle("👥", "Team Check", "Ignore same team players", pgSilentAim, 3, function(on)
    SilentAim.TeamCheck = on
end)

-- Visible Check
makeToggle("👁️", "Visible Check", "Only target visible players", pgSilentAim, 4, function(on)
    SilentAim.VisibleCheck = on
end)

-- Target Part dropdown
local targetPartOptions = {"HumanoidRootPart", "Head", "Random"}
local targetPartDropdown = nil
local function createTargetPartDropdown()
    local card = Instance.new("Frame", pgSilentAim)
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.LayoutOrder = 5
    corner(card, 8)
    stroke(card, C.accentDark, 1, 0.5)
    
    mkLbl(card, "Target Part", 11, C.text, true, Enum.TextXAlignment.Left, 12, 0, 100, 42)
    
    local currentLbl = mkLbl(card, SilentAim.TargetPart, 11, C.accent, true, Enum.TextXAlignment.Right, 0, 0, W - SIDE_W - 24, 42)
    
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    
    local index = 1
    btn.MouseButton1Click:Connect(function()
        index = index % #targetPartOptions + 1
        local newValue = targetPartOptions[index]
        SilentAim.TargetPart = newValue
        currentLbl.Text = newValue
    end)
end
createTargetPartDropdown()

-- Silent Aim Method dropdown
local methodOptions = {"FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist", "Raycast", "Mouse.Hit/Target"}
local function createMethodDropdown()
    local card = Instance.new("Frame", pgSilentAim)
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = C.surface
    card.BorderSizePixel = 0
    card.LayoutOrder = 6
    corner(card, 8)
    stroke(card, C.accentDark, 1, 0.5)
    
    mkLbl(card, "Silent Aim Method", 11, C.text, true, Enum.TextXAlignment.Left, 12, 0, 130, 42)
    
    local currentLbl = mkLbl(card, SilentAim.SilentAimMethod, 11, C.accent, true, Enum.TextXAlignment.Right, 0, 0, W - SIDE_W - 24, 42)
    
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    
    local index = 1
    for i, v in ipairs(methodOptions) do
        if v == SilentAim.SilentAimMethod then
            index = i
            break
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        index = index % #methodOptions + 1
        local newValue = methodOptions[index]
        SilentAim.SilentAimMethod = newValue
        currentLbl.Text = newValue
    end)
end
createMethodDropdown()

-- Hit Chance slider
makeSlider("Hit Chance", 0, 100, SilentAim.HitChance, pgSilentAim, 7, function(v)
    SilentAim.HitChance = v
end)

secLabel("FOV SETTINGS", pgSilentAim, 8)

-- Show FOV Circle
makeToggle("🔵", "Show FOV Circle", "Display FOV circle on screen", pgSilentAim, 9, function(on)
    SilentAim.FOVVisible = on
end)

-- FOV Radius slider
makeSlider("FOV Radius", 30, 500, SilentAim.FOVRadius, pgSilentAim, 10, function(v)
    SilentAim.FOVRadius = v
    fov_circle.Radius = v
end)

-- Show Target
makeToggle("📦", "Show Target Box", "Display box around target", pgSilentAim, 11, function(on)
    SilentAim.ShowTarget = on
end)

secLabel("PREDICTION", pgSilentAim, 12)

-- Mouse Prediction
makeToggle("🔄", "Mouse Hit Prediction", "Predict target movement", pgSilentAim, 13, function(on)
    SilentAim.MouseHitPrediction = on
end)

-- Prediction Amount slider
makeSlider("Prediction Amount", 0.165, 1, SilentAim.MouseHitPredictionAmount, pgSilentAim, 14, function(v)
    SilentAim.MouseHitPredictionAmount = v
end)

-- COMBAT PAGE
local pgCombat = newPage("combat")

secLabel("FAST ATTACK", pgCombat, 1)
makeToggle("⚡", "Fast Attack [U]", "Range " .. FastAttackRange .. " studs", pgCombat, 2, function(on)
    FastAttackEnabled = on
    if on then StartFastAttack() else if FastAttackConn then task.cancel(FastAttackConn) end end
end)
makeSlider("Fast Attack Range", 0, 12000, FastAttackRange, pgCombat, 3, function(v)
    FastAttackRange = v
end)

secLabel("FRUIT ATTACK", pgCombat, 4)
makeToggle("🦊", "Fruit Attack - Kitsune", "Auto attack nearest player", pgCombat, 5, function(on)
    FruitAttack = on
    if on then StartFruitAttack("Kitsune-Kitsune", true) else if FruitAttackConn then task.cancel(FruitAttackConn) end end
end)
makeToggle("🦖", "Fruit Attack - T-Rex", "Auto attack nearest player", pgCombat, 6, function(on)
    FruitAttack = on
    if on then StartFruitAttack("T-Rex-T-Rex", false) else if FruitAttackConn then task.cancel(FruitAttackConn) end end
end)

secLabel("MOVEMENT", pgCombat, 7)
makeToggle("🦘", "Infinite Jump", "", pgCombat, 8, function(on) InfJumpEnabled = on end)
makeToggle("👻", "No Clip", "", pgCombat, 9, function(on) NoClipEnabled = on end)
makeToggle("🌊", "Walk on Water", "", pgCombat, 10, function(on) WalkWater = on end)
makeToggle("🔧", "Custom Speed", "", pgCombat, 11, function(on) SpeedEnabled = on end)
makeSlider("Walk Speed", 16, 250, SpeedValue, pgCombat, 12, function(v)
    SpeedValue = v
    if LP.Character and SpeedEnabled then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

secLabel("GOD MODE", pgCombat, 13)
makeToggle("🛡️", "God Mode", "Keep health at maximum", pgCombat, 14, function(on)
    GodModeEnabled = on
    for _, c in pairs(GodModeConns) do pcall(function() c:Disconnect() end) end
    GodModeConns = {}
    if on then
        table.insert(GodModeConns, RunService.Stepped:Connect(function()
            pcall(function()
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                hum.Health = hum.MaxHealth
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                char:SetAttribute("UnbreakableAll", true)
            end)
        end))
        table.insert(GodModeConns, LP.CharacterAdded:Connect(function(newChar)
            if not GodModeEnabled then return end
            task.wait(0.1)
            local hum = newChar:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = hum.MaxHealth end
            newChar:SetAttribute("UnbreakableAll", true)
        end))
    end
end)

secLabel("AUTOMATION", pgCombat, 15)
makeToggle("🔮", "Auto V4 Awakening", "", pgCombat, 16, function(on)
    AutoV4On = on
    if on then
        task.spawn(function()
            while AutoV4On do
                task.wait(0.5)
                pcall(function()
                    local tool = LP.Backpack:FindFirstChild("Awakening") or LP.Character:FindFirstChild("Awakening")
                    if tool and tool:FindFirstChild("RemoteFunction") then
                        tool.RemoteFunction:InvokeServer(true)
                    end
                end)
            end
        end)
    end
end)

-- TP PAGE
local pgTP = newPage("tp")

secLabel("TARGET PLAYER", pgTP, 1)
local _, ddRefresh = makeDropdown("Select Player", pgTP, 2, function(name)
    SelectedPlayer = name
end)
makeBtn("🔄", "Refresh List", "", pgTP, 3, function() ddRefresh() end)

secLabel("MOVEMENT", pgTP, 4)
makeToggle("🌀", "Tween to Player", "Smooth teleport", pgTP, 5, function(on)
    TeleportEnabled = on
    if on then
        TeleportConn = RunService.Heartbeat:Connect(function()
            if SelectedPlayer then
                local t = Players:FindFirstChild(SelectedPlayer)
                if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                    TweenToPlayer(t.Character.HumanoidRootPart)
                    SetNoCollide()
                end
            end
        end)
    else
        if TeleportConn then TeleportConn:Disconnect() end
        if ActiveTween then ActiveTween:Cancel() end
        SetCollide()
    end
end)
makeToggle("⚡", "Instant TP", "Instant teleport", pgTP, 6, function(on)
    InstaTpEnabled = on
    if on then
        InstaTpConn = RunService.Stepped:Connect(function()
            if SelectedPlayer then
                pcall(function()
                    local t = Players:FindFirstChild(SelectedPlayer)
                    if t and t.Character then
                        LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
                        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        end)
    else
        if InstaTpConn then InstaTpConn:Disconnect() end
    end
end)
makeToggle("👁️", "Spectate Player", "", pgTP, 7, function(on)
    SpectateEnabled = on
    if on then
        SpectateConn = RunService.RenderStepped:Connect(function()
            if SelectedPlayer then
                local t = Players:FindFirstChild(SelectedPlayer)
                if t and t.Character then
                    Camera.CameraSubject = t.Character.Humanoid
                end
            end
        end)
    else
        if SpectateConn then SpectateConn:Disconnect() end
        if LP.Character then Camera.CameraSubject = LP.Character.Humanoid end
    end
end)

-- ESP PAGE
local pgESP = newPage("esp")

secLabel("VISION", pgESP, 1)
makeToggle("👁️", "Enable ESP", "", pgESP, 2, function(on)
    ESPEnabled = on
    UpdateESP()
end)
makeToggle("📛", "Names ESP", "", pgESP, 3, function(on)
    ESPNames = on
    if ESPEnabled then UpdateESP() end
end)
makeToggle("📦", "Boxes ESP", "", pgESP, 4, function(on)
    ESPBoxes = on
    if ESPEnabled then UpdateESP() end
end)

-- LOCATIONS PAGE
local pgLoc = newPage("locations")

local function makeTpBtn(icon, name, coords, parent, lo, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = C.surface
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = lo
    corner(btn, 8)
    stroke(btn, C.accentDark, 1, 0.5)
    
    mkLbl(btn, icon, 18, C.accent, false, Enum.TextXAlignment.Left, 10, 0, 30, 48)
    local nameLbl = mkLbl(btn, name, 12, C.text, true, Enum.TextXAlignment.Left, 46, 7, W - SIDE_W - 80, 18)
    mkLbl(btn, coords, 9, C.textDim, false, Enum.TextXAlignment.Left, 46, 27, W - SIDE_W - 80, 16)
    mkLbl(btn, "›", 14, C.textDim, true, Enum.TextXAlignment.Right, 0, 0, W - SIDE_W - 14, 48)
    
    btn.MouseEnter:Connect(function()
        tw(btn, {BackgroundColor3 = Color3.fromRGB(30, 35, 55)}, 0.1)
        nameLbl.TextColor3 = C.accentLight
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = C.accent; s.Transparency = 0.3 end
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, {BackgroundColor3 = C.surface}, 0.1)
        nameLbl.TextColor3 = C.text
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = C.accentDark; s.Transparency = 0.5 end
    end)
    btn.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
    return btn
end

secLabel("SEA 3", pgLoc, 1)
makeTpBtn("⚓", "Teleport to Ship", "-6500, 129, -123", pgLoc, 2, function()
    if LP.Character then LP.Character.HumanoidRootPart.CFrame = CFrame.new(-6500, 129, -123) end
end)
makeTpBtn("🌀", "Teleport to Empty Rivals", "-11997, 332, -8837", pgLoc, 3, function()
    if LP.Character then LP.Character.HumanoidRootPart.CFrame = CFrame.new(-11997, 332, -8837) end
end)

secLabel("UTILITIES", pgLoc, 4)
makeBtn("🛸", "PB Fly", "Flight system", pgLoc, 5, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)
makeBtn("🚫", "Anti-AFK", "", pgLoc, 6, function()
    local vu = game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end)

-- MISC PAGE
local pgMisc = newPage("misc")

secLabel("VISUAL", pgMisc, 1)
makeToggle("☀️", "Full Bright", "", pgMisc, 2, function(on)
    FullBright = on
    if not on then
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 9e9
    end
end)
makeToggle("👻", "Invisible Mode", "", pgMisc, 3, function(on)
    if LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = on and 1 or 0
            end
        end
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Transparency = 1 end
    end
end)

-- CREDITS PAGE
local pgCredits = newPage("credits")

local creditCard = Instance.new("Frame", pgCredits)
creditCard.Size = UDim2.new(1, 0, 0, 180)
creditCard.BackgroundColor3 = C.surface
creditCard.BorderSizePixel = 0
creditCard.LayoutOrder = 1
corner(creditCard, 10)
stroke(creditCard, C.accent, 1, 0.4)

mkLbl(creditCard, "⭐ CREDITS ⭐", 16, C.accentLight, true, Enum.TextXAlignment.Center, 0, 15, W - SIDE_W - 20, 24)
mkLbl(creditCard, "Script by NanaChan", 12, C.text, false, Enum.TextXAlignment.Center, 0, 50, W - SIDE_W - 20, 20)
mkLbl(creditCard, "Telegram: t.me/nanaanasyalala", 12, C.accent, false, Enum.TextXAlignment.Center, 0, 80, W - SIDE_W - 20, 20)
mkLbl(creditCard, "Silent Aim by casanova", 10, C.textDim, false, Enum.TextXAlignment.Center, 0, 110, W - SIDE_W - 20, 18)

local noteFrame = Instance.new("Frame", pgCredits)
noteFrame.Size = UDim2.new(1, 0, 0, 80)
noteFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
noteFrame.BorderSizePixel = 0
noteFrame.LayoutOrder = 2
corner(noteFrame, 8)
stroke(noteFrame, C.accent, 1, 0.3)

mkLbl(noteFrame, "⚠️ NOTICE ⚠️", 11, C.accentLight, true, Enum.TextXAlignment.Center, 0, 10, W - SIDE_W - 20, 18)
mkLbl(noteFrame, "Script ini berbayar. Jika Anda mendapatkannya secara gratis,", 9, C.textDim, false, Enum.TextXAlignment.Center, 0, 35, W - SIDE_W - 20, 16)
mkLbl(noteFrame, "maka itu adalah versi bocor / ilegal. Support creator!", 9, C.textDim, false, Enum.TextXAlignment.Center, 0, 55, W - SIDE_W - 20, 16)

-- ============================================================
--  SIDEBAR MENU
-- ============================================================
local sideY = 8

local function addSideSection(txt)
    local l = Instance.new("TextLabel", Sidebar)
    l.Size = UDim2.new(1, -12, 0, 18)
    l.Position = UDim2.new(0, 12, 0, sideY)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.Font = Enum.Font.GothamBold
    l.TextSize = 8
    l.TextColor3 = C.textDim
    l.TextXAlignment = Enum.TextXAlignment.Left
    sideY = sideY + 20
end

local function addSideBtn(icon, txt, pageId)
    local frame = Instance.new("TextButton", Sidebar)
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.Position = UDim2.new(0, 0, 0, sideY)
    frame.BackgroundColor3 = C.surface
    frame.Text = ""
    frame.AutoButtonColor = false
    frame.BorderSizePixel = 0
    
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0, 3, 0.6, 0)
    bar.Position = UDim2.new(0, 0, 0.2, 0)
    bar.BackgroundColor3 = C.surface
    bar.BorderSizePixel = 0
    corner(bar, 2)
    
    mkLbl(frame, icon, 14, C.accent, false, Enum.TextXAlignment.Left, 10, 0, 24, 34)
    local nameLbl = mkLbl(frame, txt, 10, C.textDim, true, Enum.TextXAlignment.Left, 38, 0, SIDE_W - 45, 34)
    
    frame.MouseButton1Click:Connect(function()
        showPage(pageId)
    end)
    frame.MouseEnter:Connect(function()
        if currentPage ~= pageId then
            tw(frame, {BackgroundColor3 = C.surface2}, 0.1)
        end
    end)
    frame.MouseLeave:Connect(function()
        if currentPage ~= pageId then
            tw(frame, {BackgroundColor3 = C.surface}, 0.1)
        end
    end)
    
    table.insert(sideBtnRefs, {frame = frame, bar = bar, lbl = nameLbl, page = pageId})
    sideY = sideY + 36
end

addSideSection("MAIN")
addSideBtn("🏠", "Home", "home")
addSideSection("AIM")
addSideBtn("🎯", "Silent Aim", "silentaim")
addSideSection("GAMEPLAY")
addSideBtn("⚔️", "Combat", "combat")
addSideBtn("🎯", "Teleport", "tp")
addSideBtn("👁️", "ESP", "esp")
addSideSection("WORLD")
addSideBtn("📍", "Locations", "locations")
addSideBtn("🎨", "Misc", "misc")
addSideSection("INFO")
addSideBtn("💎", "Credits", "credits")

-- ============================================================
--  STATUS BAR
-- ============================================================
local SB = Instance.new("Frame", Main)
SB.Size = UDim2.new(1, 0, 0, SB_H)
SB.Position = UDim2.new(0, 0, 1, -SB_H)
SB.BackgroundColor3 = C.surface
SB.BorderSizePixel = 0

local sbTop = Instance.new("Frame", SB)
sbTop.Size = UDim2.new(1, 0, 1, 0)
sbTop.BackgroundColor3 = C.accentDark
sbTop.BorderSizePixel = 0

local dot = Instance.new("Frame", SB)
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(0, 12, 0.5, -3)
dot.BackgroundColor3 = C.accent
dot.BorderSizePixel = 0
corner(dot, 3)

mkLbl(SB, "Ready", 9, C.textDim, false, Enum.TextXAlignment.Left, 24, 0, 50, SB_H)
mkLbl(SB, "|", 9, C.accentDark, false, Enum.TextXAlignment.Left, 74, 0, 10, SB_H)

local sbSilent = mkLbl(SB, "SILENT: ON", 9, C.accent, true, Enum.TextXAlignment.Left, 86, 0, 80, SB_H)
local sbFast = mkLbl(SB, "FAST: OFF", 9, C.textDim, true, Enum.TextXAlignment.Left, 166, 0, 70, SB_H)

mkLbl(SB, "NanaChan", 9, C.textDim, false, Enum.TextXAlignment.Right, 0, 0, W - 10, SB_H)

task.spawn(function()
    while true do
        task.wait(0.3)
        sbSilent.Text = SilentAim.Enabled and "SILENT: ON" or "SILENT: OFF"
        sbSilent.TextColor3 = SilentAim.Enabled and C.accent or C.textDim
        sbFast.Text = FastAttackEnabled and "FAST: ON" or "FAST: OFF"
        sbFast.TextColor3 = FastAttackEnabled and C.accent or C.textDim
    end
end)

-- ============================================================
--  MINIMIZE / REOPEN / CLOSE
-- ============================================================
local minimized = false
local reopenDragging = false
local reopenDragStart, reopenStartPos
local reopenMoved = false

local function doMinimize()
    minimized = true
    tw(Main, {Size = UDim2.new(0, W, 0, 0)}, 0.25)
    task.spawn(function()
        task.wait(0.28)
        Main.Visible = false
        ReopenBtn.Position = UDim2.new(0, Main.AbsolutePosition.X, 0, Main.AbsolutePosition.Y)
        ReopenBtn.Visible = true
    end)
end

local function doReopen()
    minimized = false
    ReopenBtn.Visible = false
    Main.Visible = true
    tw(Main, {Size = UDim2.new(0, W, 0, H)}, 0.25)
end

ReopenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        reopenDragging = true
        reopenMoved = false
        reopenDragStart = input.Position
        reopenStartPos = ReopenBtn.Position
    end
end)

ReopenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not reopenMoved then doReopen() end
        reopenDragging = false
        reopenMoved = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if reopenDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - reopenDragStart
        if delta.Magnitude > 5 then
            reopenMoved = true
            ReopenBtn.Position = UDim2.new(
                reopenStartPos.X.Scale, reopenStartPos.X.Offset + delta.X,
                reopenStartPos.Y.Scale, reopenStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    if not minimized then doMinimize() else doReopen() end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ESPEnabled = false
    ClearESP()
    WalkWater = false
    local wp = workspace:FindFirstChild("BloxWaterSolid")
    if wp then wp:Destroy() end
    tw(Main, {Size = UDim2.new(0, W, 0, 0)}, 0.25)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- ============================================================
--  INIT
-- ============================================================
showPage("home")
