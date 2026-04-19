-- ============================================================
--  PANELBLOX PREMIUM v3.0 -- Blox Fruits
--  GUI Premium with customizable colors (Blue Glow Edition)
--  ADDED: Skeleton ESP | Auto Bounty Hunt | Save Config
-- ============================================================

-- [0] SERVICES
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local TeleportService   = game:GetService("TeleportService")
local LocalPlayer       = Players.LocalPlayer
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")

-- [1] PERSISTENT COLOR SYSTEM (BLUE GLOW THEME)
local ColorPresets = {
    {name = "Pure White",       color = Color3.fromRGB(255, 255, 255)},
    {name = "Matte Black",      color = Color3.fromRGB(30, 30, 30)},
    {name = "Carbon Gray",      color = Color3.fromRGB(80, 80, 80)},
    {name = "Electric Blue",    color = Color3.fromRGB(0, 150, 255)},
    {name = "Neon Blue",        color = Color3.fromRGB(0, 200, 255)},
    {name = "Deep Blue",        color = Color3.fromRGB(0, 100, 200)},
    {name = "Cyan Glow",        color = Color3.fromRGB(0, 210, 255)},
    {name = "Royal Blue",       color = Color3.fromRGB(65, 105, 225)},
    {name = "Ice Blue",         color = Color3.fromRGB(100, 200, 255)},
    {name = "Navy Blue",        color = Color3.fromRGB(30, 60, 120)},
}

local DEFAULT_PRIMARY   = "Electric Blue"
local DEFAULT_SECONDARY = "Cyan Glow"

local function getPresetColor(name)
    for _, p in ipairs(ColorPresets) do
        if p.name == name then return p.color end
    end
    return Color3.fromRGB(0, 150, 255)
end

local SavedPrimary   = DEFAULT_PRIMARY
local SavedSecondary = DEFAULT_SECONDARY

-- [NEW] CONFIG SYSTEM
local ConfigData = {
    -- Combat
    FastAttackEnabled = false,
    FastAttackRange = 5000,
    TargetMode = "NPCsPlayers",
    AimlockEnabled = false,
    AimlockVerticalOffset = 0,
    -- Player Lock
    TeleportEnabled = false,
    InstaTeleportEnabled = false,
    SpectateEnabled = false,
    TweenSpeedVal = 350,
    YOffset = 0,
    OrbitEnabled = false,
    OrbitDistance = 5,
    OrbitHeight = 2,
    AutoEscapeEnabled = false,
    AutoEscapeThreshold = 30,
    -- Extra
    FruitAttackKitsune = false,
    FruitAttackTRex = false,
    AutoAwakening = false,
    -- Visual
    ESPEnabled = false,
    ESPDrawingEnabled = false,
    ESP_SkeletonEnabled = false,
    FullBrightEnabled = false,
    -- Movement
    iJ = false,
    ncl = false,
    walkWaterEnabled = false,
    sVal = 16,
    sAct = false,
    DashBoostEnabled = false,
    DashBoostMultiplier = 2.0,
    SuperJumpEnabled = false,
    SuperJumpPower = 100,
    SuperJumpCFrameMode = false,
    -- Auto Bounty Hunt
    AutoBountyEnabled = false,
    AutoBountyMinLevel = 2000,
    AutoBountyTargets = {},
}

local function SaveAllConfig()
    pcall(function()
        if not isfolder("PANELBLOX") then makefolder("PANELBLOX") end
        local configToSave = {
            colors = {
                primary = SavedPrimary,
                secondary = SavedSecondary,
            },
            settings = {
                FastAttackEnabled = FastAttackEnabled,
                FastAttackRange = FastAttackRange,
                TargetMode = TargetMode,
                AimlockEnabled = AimlockEnabled,
                AimlockVerticalOffset = AimlockVerticalOffset,
                TeleportEnabled = TeleportEnabled,
                InstaTeleportEnabled = InstaTeleportEnabled,
                SpectateEnabled = SpectateEnabled,
                TweenSpeedVal = TweenSpeedVal,
                YOffset = YOffset,
                OrbitEnabled = OrbitEnabled,
                OrbitDistance = OrbitDistance,
                OrbitHeight = OrbitHeight,
                AutoEscapeEnabled = AutoEscapeEnabled,
                AutoEscapeThreshold = AutoEscapeThreshold,
                FruitAttackKitsune = FruitAttackKitsune,
                FruitAttackTRex = FruitAttackTRex,
                AutoAwakening = AutoAwakening,
                ESPEnabled = ESPEnabled,
                ESPDrawingEnabled = ESPDrawingEnabled,
                ESP_SkeletonEnabled = ESP_SkeletonEnabled,
                FullBrightEnabled = FullBrightEnabled,
                iJ = iJ,
                ncl = ncl,
                walkWaterEnabled = walkWaterEnabled,
                sVal = sVal,
                sAct = sAct,
                DashBoostEnabled = DashBoostEnabled,
                DashBoostMultiplier = DashBoostMultiplier,
                SuperJumpEnabled = SuperJumpEnabled,
                SuperJumpPower = SuperJumpPower,
                SuperJumpCFrameMode = SuperJumpCFrameMode,
                AutoBountyEnabled = AutoBountyEnabled,
                AutoBountyMinLevel = AutoBountyMinLevel,
            }
        }
        writefile("PANELBLOX/config.json", HttpService:JSONEncode(configToSave))
        addNotification("Config", "Settings saved successfully", C.green)
    end)
end

local function LoadAllConfig()
    pcall(function()
        if not isfile("PANELBLOX/config.json") then return end
        local data = HttpService:JSONDecode(readfile("PANELBLOX/config.json"))
        
        -- Load colors
        if data.colors then
            if data.colors.primary then SavedPrimary = data.colors.primary end
            if data.colors.secondary then SavedSecondary = data.colors.secondary end
            ApplyColorChange()
        end
        
        -- Load settings
        if data.settings then
            FastAttackEnabled = data.settings.FastAttackEnabled or false
            FastAttackRange = data.settings.FastAttackRange or 5000
            TargetMode = data.settings.TargetMode or "NPCsPlayers"
            AimlockEnabled = data.settings.AimlockEnabled or false
            AimlockVerticalOffset = data.settings.AimlockVerticalOffset or 0
            TeleportEnabled = data.settings.TeleportEnabled or false
            InstaTeleportEnabled = data.settings.InstaTeleportEnabled or false
            SpectateEnabled = data.settings.SpectateEnabled or false
            TweenSpeedVal = data.settings.TweenSpeedVal or 350
            YOffset = data.settings.YOffset or 0
            OrbitEnabled = data.settings.OrbitEnabled or false
            OrbitDistance = data.settings.OrbitDistance or 5
            OrbitHeight = data.settings.OrbitHeight or 2
            AutoEscapeEnabled = data.settings.AutoEscapeEnabled or false
            AutoEscapeThreshold = data.settings.AutoEscapeThreshold or 30
            FruitAttackKitsune = data.settings.FruitAttackKitsune or false
            FruitAttackTRex = data.settings.FruitAttackTRex or false
            AutoAwakening = data.settings.AutoAwakening or false
            ESPEnabled = data.settings.ESPEnabled or false
            ESPDrawingEnabled = data.settings.ESPDrawingEnabled or false
            ESP_SkeletonEnabled = data.settings.ESP_SkeletonEnabled or false
            FullBrightEnabled = data.settings.FullBrightEnabled or false
            iJ = data.settings.iJ or false
            ncl = data.settings.ncl or false
            walkWaterEnabled = data.settings.walkWaterEnabled or false
            sVal = data.settings.sVal or 16
            sAct = data.settings.sAct or false
            DashBoostEnabled = data.settings.DashBoostEnabled or false
            DashBoostMultiplier = data.settings.DashBoostMultiplier or 2.0
            SuperJumpEnabled = data.settings.SuperJumpEnabled or false
            SuperJumpPower = data.settings.SuperJumpPower or 100
            SuperJumpCFrameMode = data.settings.SuperJumpCFrameMode or false
            AutoBountyEnabled = data.settings.AutoBountyEnabled or false
            AutoBountyMinLevel = data.settings.AutoBountyMinLevel or 2000
        end
        
        addNotification("Config", "Settings loaded successfully", C.accent)
    end)
end

pcall(function()
    if not isfolder("PANELBLOX") then makefolder("PANELBLOX") end
    if isfile("PANELBLOX/colors.json") then
        local data = HttpService:JSONDecode(readfile("PANELBLOX/colors.json"))
        if data.primary then SavedPrimary = data.primary end
        if data.secondary then SavedSecondary = data.secondary end
    end
end)

local function SaveColors()
    pcall(function()
        if not isfolder("PANELBLOX") then makefolder("PANELBLOX") end
        writefile("PANELBLOX/colors.json", HttpService:JSONEncode({
            primary = SavedPrimary,
            secondary = SavedSecondary,
        }))
    end)
end

-- [2] COLOR PALETTE WITH DYNAMIC TINTING
local function lerpColor(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end

local C = {
    accent   = getPresetColor(SavedPrimary),
    accent2  = getPresetColor(SavedSecondary),
    white    = Color3.fromRGB(255, 255, 255),
    green    = Color3.fromRGB(92, 240, 176),
    red      = Color3.fromRGB(255, 70, 90),
    orange   = Color3.fromRGB(255, 170, 68),
    bg = nil, panel = nil, item = nil, itemHov = nil, border = nil, text = nil, sub = nil,
}

local function GenerateThemeColors()
    local ac = C.accent
    C.bg      = lerpColor(Color3.fromRGB(8, 12, 25), ac, 0.12)
    C.panel   = lerpColor(Color3.fromRGB(5, 8, 18), ac, 0.10)
    C.item    = lerpColor(Color3.fromRGB(15, 20, 40), ac, 0.15)
    C.itemHov = lerpColor(Color3.fromRGB(25, 35, 65), ac, 0.20)
    C.border  = lerpColor(Color3.fromRGB(0, 80, 150), ac, 0.30)
    local ac2 = C.accent2
    C.text    = lerpColor(Color3.fromRGB(200, 220, 255), ac2, 0.20)
    C.sub     = lerpColor(Color3.fromRGB(100, 130, 200), ac2, 0.25)
end
GenerateThemeColors()

local AccentElements = {}
local Accent2Elements = {}
local ThemeElements = {}

local function trackAccent(obj, prop)
    table.insert(AccentElements, {obj = obj, prop = prop})
end
local function trackAccent2(obj, prop)
    table.insert(Accent2Elements, {obj = obj, prop = prop})
end
local function trackTheme(obj, prop, key)
    table.insert(ThemeElements, {obj = obj, prop = prop, key = key})
end

local function ApplyColorChange()
    C.accent  = getPresetColor(SavedPrimary)
    C.accent2 = getPresetColor(SavedSecondary)
    GenerateThemeColors()
    for _, e in ipairs(AccentElements) do
        pcall(function() e.obj[e.prop] = C.accent end)
    end
    for _, e in ipairs(Accent2Elements) do
        pcall(function() e.obj[e.prop] = C.accent2 end)
    end
    for _, e in ipairs(ThemeElements) do
        pcall(function() e.obj[e.prop] = C[e.key] end)
    end
    SaveColors()
end

-- [3] INTRO SCREEN MATRIX
local function RunIntro()
    local introGui = Instance.new("ScreenGui")
    local Blackout = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Subtitle = Instance.new("TextLabel")

    introGui.Name = "PANELBLOXIntro"
    introGui.Parent = game:GetService("CoreGui")
    introGui.IgnoreGuiInset = true

    Blackout.Size = UDim2.new(1, 0, 1, 0)
    Blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Blackout.BorderSizePixel = 0
    Blackout.Parent = introGui

    Title.Size = UDim2.new(1, 0, 0.5, 0)
    Title.Position = UDim2.new(0, 0, 0.25, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "PANELBLOX PREMIUM"
    Title.TextColor3 = C.accent
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 42
    Title.TextStrokeTransparency = 0
    Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Title.ZIndex = 100
    Title.Parent = Blackout

    Subtitle.Size = UDim2.new(1, 0, 0.1, 0)
    Subtitle.Position = UDim2.new(0, 0, 0.6, 0)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Loading Premium..."
    Subtitle.TextColor3 = C.accent2
    Subtitle.Font = Enum.Font.Code
    Subtitle.TextSize = 16
    Subtitle.Parent = Blackout

    task.spawn(function()
        local maxNumbers = 100
        for i = 1, maxNumbers do
            task.spawn(function()
                while Blackout.Parent do
                    local m = Instance.new("TextLabel")
                    m.Text = tostring(math.random(0, 9))
                    m.Position = UDim2.new(math.random(), 0, math.random(), 0)
                    m.BackgroundTransparency = 1
                    local r, g, b = C.accent.R, C.accent.G, C.accent.B
                    m.TextColor3 = Color3.new(r * (math.random(60, 100)/100), g * (math.random(60, 100)/100), b * (math.random(60, 100)/100))
                    m.Font = Enum.Font.Code
                    m.TextSize = math.random(14, 24)
                    m.TextTransparency = 1
                    m.Parent = Blackout
                    local duration = math.random(5, 15) / 10
                    TweenService:Create(m, TweenInfo.new(duration/2), {TextTransparency = 0}):Play()
                    task.wait(duration)
                    TweenService:Create(m, TweenInfo.new(duration/2), {TextTransparency = 1}):Play()
                    game:GetService("Debris"):AddItem(m, duration)
                    task.wait(math.random(1, 5) / 10)
                end
            end)
        end
        task.wait(4)
        local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
        TweenService:Create(Blackout, fadeInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, fadeInfo, {TextTransparency = 1}):Play()
        TweenService:Create(Subtitle, fadeInfo, {TextTransparency = 1}):Play()
        task.wait(1)
        introGui:Destroy()
    end)
end

RunIntro()
task.wait(5)

-- [4] BYPASSES
repeat task.wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Util")
pcall(function()
    local ss = require(game:GetService("ReplicatedStorage").Util.CameraShaker.Main)
    local noop = function() return nil end
    ss.StartShake = noop; ss.ShakeOnce = noop; ss.ShakeSustain = noop
    ss.CamerShakeInstance = noop; ss.Shake = noop; ss.Start = noop
end)

-- [5] STATE VARIABLES
-- Combat
local FastAttackEnabled   = false
local FastAttackRange     = 5000
local FastAttackConnection = nil
local AimlockEnabled      = false
local AimlockVerticalOffset = 0
local TargetMode          = "NPCsPlayers"
-- Player Lock
local SelectedPlayer      = nil
local TeleportEnabled     = false
local InstaTeleportEnabled = false
local SpectateEnabled     = false
local TeleportConnection  = nil
local InstaTpConnection   = nil
local SpectateConnection  = nil
local ActiveTween         = nil
local YOffset             = 0
local TweenSpeedVal       = 350
local OrbitEnabled        = false
local OrbitDistance        = 5
local OrbitHeight         = 2
local rot                 = 0
-- Auto Escape
local AutoEscapeEnabled   = false
local AutoEscapeThreshold = 30
local AutoEscapeActive    = false
local AutoEscapeConn      = nil
-- Extra Functions
local FruitAttackKitsune  = false
local FruitAttackTRex     = false
local AutoAwakening       = false
local v4Connection        = nil
-- Visual
local ESPEnabled          = false
local ESPObjects          = {}
local ESPDrawingEnabled   = false
-- [NEW] SKELETON ESP
local ESP_SkeletonEnabled = false
local SkeletonObjects     = {}
local SkeletonLines       = {}
-- FullBright
local FullBrightEnabled   = false
-- Movement
local iJ                  = false
local ncl                 = false
local walkWaterEnabled    = false
local sVal                = 16
local sAct                = false
local flyGui              = nil
-- Dash Boost
local DashBoostEnabled    = false
local DashBoostMultiplier = 2.0
local DashBoostDescConn   = nil
local DashBoostKeyConn    = nil
local DashBoostIsDashing  = false
-- Super Jump
local SuperJumpEnabled    = false
local SuperJumpPower      = 100
local SuperJumpCFrameMode = false
local oneShotGui          = nil
local aimlockGui          = nil
-- Aimlock internals
local u4                  = false
local u19                 = nil

-- [NEW] AUTO BOUNTY HUNT
local AutoBountyEnabled   = false
local AutoBountyMinLevel  = 2000
local AutoBountyTargets   = {}
local AutoBountyConnection = nil
local AutoBountyActive    = false
local AutoBountyCurrentTarget = nil

-- Net
local Net            = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterHit    = Net["RE/RegisterHit"]
local RegisterAttack = Net["RE/RegisterAttack"]

-- [NEW] SKELETON ESP FUNCTIONS
local function GetJoints(char)
    local joints = {}
    local parts = {
        Head = "Head",
        Neck = "UpperTorso",
        LeftShoulder = "LeftUpperArm", LeftElbow = "LeftLowerArm", LeftWrist = "LeftHand",
        RightShoulder = "RightUpperArm", RightElbow = "RightLowerArm", RightWrist = "RightHand",
        Hips = "LowerTorso",
        LeftHip = "LeftUpperLeg", LeftKnee = "LeftLowerLeg", LeftAnkle = "LeftFoot",
        RightHip = "RightUpperLeg", RightKnee = "RightLowerLeg", RightAnkle = "RightFoot",
    }
    
    for name, partName in pairs(parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            joints[name] = part
        end
    end
    return joints
end

local function CreateSkeletonForPlayer(plr)
    if not plr or not plr.Character then return end
    local char = plr.Character
    local joints = GetJoints(char)
    
    local skeletonGroup = Instance.new("Folder")
    skeletonGroup.Name = "SkeletonESP_" .. plr.Name
    skeletonGroup.Parent = char
    
    local function createLine(partA, partB, color)
        if not partA or not partB then return nil end
        local line = Instance.new("Part")
        line.Name = "SkeletonLine"
        line.Size = Vector3.new(0.05, 0.05, 0.05)
        line.Anchored = true
        line.CanCollide = false
        line.Transparency = 0.3
        line.Material = Enum.Material.Neon
        line.BrickColor = BrickColor.new(color)
        line.Parent = skeletonGroup
        
        local attachmentA = Instance.new("Attachment", partA)
        local attachmentB = Instance.new("Attachment", partB)
        local lineConstraint = Instance.new("LineForce", line)
        lineConstraint.Attachment0 = attachmentA
        lineConstraint.Attachment1 = attachmentB
        lineConstraint.Visible = true
        
        return {line = line, attA = attachmentA, attB = attachmentB, constraint = lineConstraint}
    end
    
    local lines = {}
    -- Head to Neck
    if joints.Head and joints.Neck then
        table.insert(lines, createLine(joints.Head, joints.Neck, "Bright blue"))
    end
    -- Neck to Hips
    if joints.Neck and joints.Hips then
        table.insert(lines, createLine(joints.Neck, joints.Hips, "Bright blue"))
    end
    -- Left arm
    if joints.LeftShoulder and joints.LeftElbow then
        table.insert(lines, createLine(joints.LeftShoulder, joints.LeftElbow, "Bright blue"))
    end
    if joints.LeftElbow and joints.LeftWrist then
        table.insert(lines, createLine(joints.LeftElbow, joints.LeftWrist, "Bright blue"))
    end
    -- Right arm
    if joints.RightShoulder and joints.RightElbow then
        table.insert(lines, createLine(joints.RightShoulder, joints.RightElbow, "Bright blue"))
    end
    if joints.RightElbow and joints.RightWrist then
        table.insert(lines, createLine(joints.RightElbow, joints.RightWrist, "Bright blue"))
    end
    -- Left leg
    if joints.Hips and joints.LeftHip then
        table.insert(lines, createLine(joints.Hips, joints.LeftHip, "Bright blue"))
    end
    if joints.LeftHip and joints.LeftKnee then
        table.insert(lines, createLine(joints.LeftHip, joints.LeftKnee, "Bright blue"))
    end
    if joints.LeftKnee and joints.LeftAnkle then
        table.insert(lines, createLine(joints.LeftKnee, joints.LeftAnkle, "Bright blue"))
    end
    -- Right leg
    if joints.Hips and joints.RightHip then
        table.insert(lines, createLine(joints.Hips, joints.RightHip, "Bright blue"))
    end
    if joints.RightHip and joints.RightKnee then
        table.insert(lines, createLine(joints.RightHip, joints.RightKnee, "Bright blue"))
    end
    if joints.RightKnee and joints.RightAnkle then
        table.insert(lines, createLine(joints.RightKnee, joints.RightAnkle, "Bright blue"))
    end
    
    table.insert(SkeletonObjects, skeletonGroup)
    for _, lineData in ipairs(lines) do
        table.insert(SkeletonLines, lineData)
    end
end

local function ClearSkeletonESP()
    for _, obj in pairs(SkeletonObjects) do
        pcall(function() obj:Destroy() end)
    end
    for _, lineData in pairs(SkeletonLines) do
        pcall(function() 
            if lineData.line then lineData.line:Destroy() end
            if lineData.attA then lineData.attA:Destroy() end
            if lineData.attB then lineData.attB:Destroy() end
            if lineData.constraint then lineData.constraint:Destroy() end
        end)
    end
    SkeletonObjects = {}
    SkeletonLines = {}
end

local function UpdateSkeletonESP()
    ClearSkeletonESP()
    if not ESP_SkeletonEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            CreateSkeletonForPlayer(p)
        end
    end
end

-- [NEW] AUTO BOUNTY HUNT FUNCTIONS
local function GetPlayerLevel(player)
    pcall(function()
        local stats = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level")
        if stats then
            return stats.Value
        end
    end)
    return 0
end

local function GetBountyTargets()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local level = GetPlayerLevel(p)
            if level >= AutoBountyMinLevel then
                table.insert(targets, p)
            end
        end
    end
    return targets
end

local function TeleportToTarget(target)
    if not target or not target.Character then return false end
    pcall(function()
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp and LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 2, 0))
            return true
        end
    end)
    return false
end

local function AttackTarget(target)
    pcall(function()
        if not target or not target.Character then return end
        local head = target.Character:FindFirstChild("Head")
        if head then
            RegisterAttack:FireServer(0)
            RegisterHit:FireServer(head, {target.Character, head})
        end
    end)
end

local function StartAutoBounty()
    if AutoBountyConnection then AutoBountyConnection:Disconnect() end
    
    AutoBountyConnection = RunService.Heartbeat:Connect(function()
        if not AutoBountyEnabled then return end
        
        pcall(function()
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if not myHRP or not myHum then return end
            
            -- Auto Escape logic when health low
            local hpPercent = (myHum.Health / myHum.MaxHealth) * 100
            if hpPercent <= AutoEscapeThreshold and AutoEscapeEnabled then
                local escapePos = myHRP.Position + Vector3.new(0, 300, 0)
                myHRP.CFrame = CFrame.new(escapePos)
                return
            end
            
            -- Refresh target list every 30 seconds
            if tick() % 30 < 0.1 then
                AutoBountyTargets = GetBountyTargets()
            end
            
            -- Find nearest valid target
            local nearestTarget = nil
            local nearestDist = math.huge
            
            for _, target in pairs(AutoBountyTargets) do
                if target and target.Character then
                    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = target.Character:FindFirstChild("Humanoid")
                    if targetHRP and targetHum and targetHum.Health > 0 then
                        local dist = (myHRP.Position - targetHRP.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestTarget = target
                        end
                    end
                end
            end
            
            if nearestTarget then
                AutoBountyCurrentTarget = nearestTarget
                local targetHRP = nearestTarget.Character.HumanoidRootPart
                local dist = (myHRP.Position - targetHRP.Position).Magnitude
                
                -- Instant teleport to target if too far or if InstaTeleport enabled
                if dist > 30 or InstaTeleportEnabled then
                    TeleportToTarget(nearestTarget)
                end
                
                -- Attack if in range
                if dist <= FastAttackRange then
                    AttackTarget(nearestTarget)
                end
            end
        end)
    end)
end

local function StopAutoBounty()
    if AutoBountyConnection then
        AutoBountyConnection:Disconnect()
        AutoBountyConnection = nil
    end
    AutoBountyCurrentTarget = nil
end

-- [6] ESP LOGIC
local function CreateESP(target)
    if not target:FindFirstChild("Head") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PANELBLOXESP"
    billboard.Adornee = target:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target:FindFirstChild("Head")
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = target.Name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = target:IsA("Model") and C.accent or C.white
    lbl.TextStrokeTransparency = 0.4
    lbl.Parent = billboard
    table.insert(ESPObjects, billboard)
end

local function ClearESP()
    for _, obj in pairs(ESPObjects) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    ESPObjects = {}
end

local function UpdateESP()
    ClearESP()
    if not ESPEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then CreateESP(p.Character) end
    end
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in pairs(enemies:GetChildren()) do CreateESP(npc) end
    end
end

-- [7] AIMLOCK LOGIC
local function FindNearestEnemy()
    local _huge = math.huge
    local screenCenter = Vector2.new(
        game:GetService("GuiService"):GetScreenResolution().X / 2,
        game:GetService("GuiService"):GetScreenResolution().Y / 2
    )
    local nearest = nil
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local char = v.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (screenCenter - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < _huge then
                        nearest = char.HumanoidRootPart
                        _huge = dist
                    end
                end
            end
        end
    end
    return nearest
end

RunService.Heartbeat:Connect(function()
    if not AimlockEnabled then return end
    if u4 == true and u19 then
        local cam = workspace.CurrentCamera
        local targetPos = u19.Position + Vector3.new(0, AimlockVerticalOffset, 0)
        cam.CFrame = CFrame.new(cam.CFrame.p, targetPos)
    end
end)

-- [8] ATTACK LOGIC
local function AttackMultipleTargets(targets)
    pcall(function()
        if not targets or #targets == 0 then return end
        local allTargets = {}
        for _, targetChar in pairs(targets) do
            local head = targetChar:FindFirstChild("Head")
            if head then table.insert(allTargets, {targetChar, head}) end
        end
        if #allTargets == 0 then return end
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(allTargets[1][2], allTargets)
    end)
end

local function StopFastAttack()
    if FastAttackConnection then
        task.cancel(FastAttackConnection)
        FastAttackConnection = nil
    end
end

local function StartFastAttack()
    StopFastAttack()
    FastAttackConnection = task.spawn(function()
        while FastAttackEnabled do
            task.wait(0.005)
            pcall(function()
                local myChar = LocalPlayer.Character
                local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                local range = FastAttackRange
                local targets = {}

                if TargetMode == "NPCsPlayers" or TargetMode == "OnlyPlayers" then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local hum = player.Character:FindFirstChild("Humanoid")
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 and (hrp.Position - myHRP.Position).Magnitude <= range then
                                table.insert(targets, player.Character)
                            end
                        end
                    end
                end

                if TargetMode == "NPCsPlayers" or TargetMode == "OnlyNPCs" then
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, npc in pairs(enemies:GetChildren()) do
                            local hum = npc:FindFirstChild("Humanoid")
                            local hrp = npc:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health > 0 and (hrp.Position - myHRP.Position).Magnitude <= range then
                                table.insert(targets, npc)
                            end
                        end
                    end
                end

                if #targets > 0 then AttackMultipleTargets(targets) end
            end)
        end
    end)
end

-- [9] MOVEMENT FUNCTIONS
local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    if #list == 0 then return {"None"} end
    return list
end

local function SetNoCollide()
    pcall(function()
        if not LocalPlayer.Character then return end
        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
end

local function SetCollide()
    pcall(function()
        if not LocalPlayer.Character then return end
        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end)
end

local function GetNearestPlayer()
    local nearest, dist = nil, math.huge
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; nearest = v end
        end
    end
    return nearest
end

local tweenNoClipConn = nil

local function StartTweenFollow()
    tweenNoClipConn = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

local function StopTweenFollow()
    if tweenNoClipConn then tweenNoClipConn:Disconnect(); tweenNoClipConn = nil end
    SetCollide()
end

-- ============================================================
--  GUI HELPERS
-- ============================================================
local function corner(r, p)
    local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r); return c
end

local function stroke(color, thickness, p)
    local s = Instance.new("UIStroke", p); s.Color = color; s.Thickness = thickness or 1; return s
end

local function label(props, parent)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Font      = props.Font or Enum.Font.Gotham
    l.TextSize  = props.TextSize or 13
    l.TextColor3 = props.TextColor3 or C.text
    l.Text      = props.Text or ""
    l.Size      = props.Size or UDim2.new(1,0,1,0)
    l.Position  = props.Position or UDim2.new(0,0,0,0)
    l.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    l.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    return l
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint), props):Play()
end

-- ============================================================
--  SCREEN GUI
-- ============================================================
local pgui = LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PANELBLOX") then pgui.PANELBLOX:Destroy() end

local screenGui = Instance.new("ScreenGui", pgui)
screenGui.Name = "PANELBLOX"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1

-- ============================================================
--  NOTIFICATION SYSTEM
-- ============================================================
local notifContainer = Instance.new("Frame", screenGui)
notifContainer.Size = UDim2.new(0, 250, 1, -20)
notifContainer.Position = UDim2.new(1, -260, 0, 10)
notifContainer.BackgroundTransparency = 1
local notifLayout = Instance.new("UIListLayout", notifContainer)
notifLayout.Padding = UDim.new(0, 6)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function addNotification(title, msg, color)
    local notif = Instance.new("Frame", notifContainer)
    notif.Size = UDim2.new(1, 0, 0, 56)
    notif.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
    notif.ClipsDescendants = true
    corner(10, notif)
    stroke(color or C.accent, 1, notif)

    local accentBar = Instance.new("Frame", notif)
    accentBar.Size = UDim2.new(0, 4, 1, -8)
    accentBar.Position = UDim2.new(0, 4, 0, 4)
    accentBar.BackgroundColor3 = color or C.accent
    corner(2, accentBar)

    label({Text = title, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.white,
        Size = UDim2.new(1, -22, 0, 18), Position = UDim2.new(0, 16, 0, 8)}, notif)
    label({Text = msg, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.sub,
        Size = UDim2.new(1, -22, 0, 16), Position = UDim2.new(0, 16, 0, 28)}, notif)

    notif.Position = UDim2.new(1, 0, 0, 0)
    tween(notif, 0.3, {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(4, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 0, 0, 0)})
        task.wait(0.35)
        pcall(function() notif:Destroy() end)
    end)
end

-- ============================================================
--  CREDIT BANNER (BOTTOM OF SCREEN)
-- ============================================================
local creditFrame = Instance.new("Frame", screenGui)
creditFrame.Size = UDim2.new(1, 0, 0, 28)
creditFrame.Position = UDim2.new(0, 0, 1, -28)
creditFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
creditFrame.BackgroundTransparency = 0.6
creditFrame.BorderSizePixel = 0
corner(0, creditFrame)

local creditLabel = Instance.new("TextLabel", creditFrame)
creditLabel.Size = UDim2.new(1, 0, 1, 0)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "PANELBLOX PREMIUM | Telegram: @nanaanasyalala"
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextSize = 12
creditLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
creditLabel.TextXAlignment = Enum.TextXAlignment.Center
creditLabel.TextYAlignment = Enum.TextYAlignment.Center
-- Glow effect on text
task.spawn(function()
    local glow = true
    while creditLabel and creditLabel.Parent do
        glow = not glow
        local targetColor = glow and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 100, 200)
        tween(creditLabel, 1, {TextColor3 = targetColor})
        task.wait(1)
    end
end)

-- ============================================================
--  MAIN FRAME
-- ============================================================
local SIDEBAR_W = 140
local TITLEBAR_H = 46

local currentGuiSize = "Medium"
local guiSizes = {
    Small = {w = 440, h = 310},
    Medium = {w = 530, h = 380},
    Large  = {w = 620, h = 450},
}

local defW, defH = 530, 380
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, defW, 0, defH)
mainFrame.Position = UDim2.new(0.5, -defW/2, 0.5, -defH/2)
mainFrame.BackgroundColor3 = C.bg
mainFrame.ClipsDescendants = true
trackTheme(mainFrame, "BackgroundColor3", "bg")
mainFrame.Active = true
mainFrame.Draggable = true
corner(10, mainFrame)
local mainStroke = stroke(C.border, 1, mainFrame)
trackTheme(mainStroke, "Color", "border")

mainFrame.BackgroundTransparency = 1
tween(mainFrame, 0.35, {BackgroundTransparency = 0})

-- TITLEBAR
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, TITLEBAR_H)
titleBar.BackgroundColor3 = C.panel
titleBar.BorderSizePixel = 0
corner(10, titleBar)
trackTheme(titleBar, "BackgroundColor3", "panel")
local titleBarFill = Instance.new("Frame", titleBar)
titleBarFill.Size = UDim2.new(1, 0, 0, 12)
titleBarFill.Position = UDim2.new(0, 0, 1, -12)
titleBarFill.BackgroundColor3 = C.panel
trackTheme(titleBarFill, "BackgroundColor3", "panel")
titleBarFill.BorderSizePixel = 0

local titleName = label({
    Text = "PANELBLOX", Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = C.white,
    Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 12, 0, 0),
}, titleBar)

-- PREMIUM BADGE
local premiumBadge = Instance.new("Frame", titleBar)
premiumBadge.Size = UDim2.new(0, 70, 0, 20)
premiumBadge.Position = UDim2.new(0, 116, 0.5, -10)
premiumBadge.BackgroundColor3 = C.accent
corner(8, premiumBadge)
trackAccent(premiumBadge, "BackgroundColor3")

label({Text = "PREMIUM", Font = Enum.Font.GothamBlack, TextSize = 10,
    TextColor3 = Color3.fromRGB(10, 8, 5),
    Size = UDim2.new(1, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Center,
}, premiumBadge)

local titleLine = Instance.new("Frame", mainFrame)
titleLine.Size = UDim2.new(1, 0, 0, 2)
titleLine.Position = UDim2.new(0, 0, 0, TITLEBAR_H)
titleLine.BackgroundColor3 = C.accent
titleLine.BorderSizePixel = 0
trackAccent(titleLine, "BackgroundColor3")

-- Close button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, TITLEBAR_H, 0, TITLEBAR_H)
closeBtn.Position = UDim2.new(1, -TITLEBAR_H, 0, 0)
closeBtn.Text = "X"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12
closeBtn.TextColor3 = C.sub; closeBtn.BackgroundTransparency = 1
closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = C.red end)
closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = C.sub end)

-- Minimize button
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, TITLEBAR_H, 0, TITLEBAR_H)
minBtn.Position = UDim2.new(1, -TITLEBAR_H * 2, 0, 0)
minBtn.Text = "-"; minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 16
minBtn.TextColor3 = C.sub; minBtn.BackgroundTransparency = 1
minBtn.MouseEnter:Connect(function() minBtn.TextColor3 = C.text end)
minBtn.MouseLeave:Connect(function() minBtn.TextColor3 = C.sub end)

-- SIDEBAR
local sidebar = Instance.new("ScrollingFrame", mainFrame)
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -TITLEBAR_H - 1)
sidebar.Position = UDim2.new(0, 0, 0, TITLEBAR_H + 1)
sidebar.BackgroundTransparency = 1
sidebar.ScrollBarThickness = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.BorderSizePixel = 0

local sidebarLine = Instance.new("Frame", mainFrame)
sidebarLine.Size = UDim2.new(0, 1, 1, -TITLEBAR_H - 1)
sidebarLine.Position = UDim2.new(0, SIDEBAR_W, 0, TITLEBAR_H + 1)
sidebarLine.BackgroundColor3 = C.border
sidebarLine.BorderSizePixel = 0
trackTheme(sidebarLine, "BackgroundColor3", "border")

local sideLayout = Instance.new("UIListLayout", sidebar)
sideLayout.Padding = UDim.new(0, 2)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, 8); sidePad.PaddingLeft = UDim.new(0, 8)
sidePad.PaddingRight = UDim.new(0, 8); sidePad.PaddingBottom = UDim.new(0, 8)

-- CONTENT FRAME
local contentFrame = Instance.new("ScrollingFrame", mainFrame)
contentFrame.Size = UDim2.new(1, -(SIDEBAR_W + 14), 1, -(TITLEBAR_H + 10))
contentFrame.Position = UDim2.new(0, SIDEBAR_W + 6, 0, TITLEBAR_H + 6)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 3
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.BorderSizePixel = 0

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
local contentPad = Instance.new("UIPadding", contentFrame)
contentPad.PaddingTop = UDim.new(0, 8); contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.PaddingRight = UDim.new(0, 8)

-- ============================================================
--  TAB SYSTEM
-- ============================================================
local pages = {}
local navButtons = {}
local currentPage = nil

local function showPage(name)
    for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
    for navName, btn in pairs(navButtons) do
        if navName == name then
            btn.BackgroundTransparency = 0
            btn.BackgroundColor3 = Color3.fromRGB(22, 20, 35)
            btn.TextColor3 = C.accent2
            if btn:FindFirstChild("ActiveLine") then
                btn.ActiveLine.BackgroundColor3 = C.accent
                btn.ActiveLine.BackgroundTransparency = 0
            end
        else
            btn.BackgroundTransparency = 1
            btn.TextColor3 = C.sub
            if btn:FindFirstChild("ActiveLine") then
                btn.ActiveLine.BackgroundTransparency = 1
            end
        end
    end
    currentPage = name
end

local function createNavBtn(name, displayText)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1; btn.Text = displayText
    btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.TextColor3 = C.sub; btn.TextXAlignment = Enum.TextXAlignment.Left
    corner(6, btn)
    local pad = Instance.new("UIPadding", btn); pad.PaddingLeft = UDim.new(0, 10)
    local activeLine = Instance.new("Frame", btn)
    activeLine.Name = "ActiveLine"
    activeLine.Size = UDim2.new(0, 3, 0.6, 0); activeLine.Position = UDim2.new(0, -6, 0.2, 0)
    activeLine.BackgroundTransparency = 1; activeLine.BorderSizePixel = 0
    corner(2, activeLine)
    btn.MouseButton1Click:Connect(function() showPage(name) end)
    btn.MouseEnter:Connect(function()
        if currentPage ~= name then tween(btn, 0.1, {BackgroundTransparency = 0.85, TextColor3 = C.text}) end
    end)
    btn.MouseLeave:Connect(function()
        if currentPage ~= name then tween(btn, 0.1, {BackgroundTransparency = 1, TextColor3 = C.sub}) end
    end)
    navButtons[name] = btn
    return btn
end

local function createPage(name)
    local frame = Instance.new("Frame", contentFrame)
    frame.Name = name; frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1; frame.Visible = false; frame.LayoutOrder = 1
    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 7); layout.SortOrder = Enum.SortOrder.LayoutOrder
    pages[name] = frame
    return frame
end

-- ============================================================
--  UI COMPONENTS
-- ============================================================

local function addSectionTitle(text, parent, order)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 24); f.BackgroundTransparency = 1; f.LayoutOrder = order or 0
    local accentLine = Instance.new("Frame", f)
    accentLine.Size = UDim2.new(0, 3, 0.6, 0); accentLine.Position = UDim2.new(0, 0, 0.2, 0)
    accentLine.BackgroundColor3 = C.accent; accentLine.BorderSizePixel = 0
    corner(2, accentLine); trackAccent(accentLine, "BackgroundColor3")
    local sectionLbl = label({Text = text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.text,
        Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,8,0,0), TextXAlignment = Enum.TextXAlignment.Left}, f)
    trackTheme(sectionLbl, "TextColor3", "text")
    return f
end

local function addToggleRow(titleText, subText, parent, order, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, subText and 48 or 38)
    row.BackgroundColor3 = C.item; row.LayoutOrder = order or 1
    row.ClipsDescendants = true
    corner(8, row); local rowStroke = stroke(C.border, 1, row)
    trackTheme(row, "BackgroundColor3", "item"); trackTheme(rowStroke, "Color", "border")

    local titleLbl = label({Text = titleText, Font = Enum.Font.GothamSemibold, TextSize = 13, TextColor3 = C.text,
        Size = UDim2.new(1, -58, 0, 20), Position = UDim2.new(0, 10, 0, subText and 6 or 0),
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, row)
    trackTheme(titleLbl, "TextColor3", "text")

    if subText then
        local subLbl = label({Text = subText, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.sub,
            Size = UDim2.new(1, -58, 0, 14), Position = UDim2.new(0, 10, 0, 27),
            TextXAlignment = Enum.TextXAlignment.Left}, row)
        trackTheme(subLbl, "TextColor3", "sub")
    end

    local toggleBg = Instance.new("Frame", row)
    toggleBg.Size = UDim2.new(0, 40, 0, 22); toggleBg.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBg.BackgroundColor3 = Color3.fromRGB(42, 42, 50); corner(99, toggleBg)

    local toggleKnob = Instance.new("Frame", toggleBg)
    toggleKnob.Size = UDim2.new(0, 16, 0, 16); toggleKnob.Position = UDim2.new(0, 3, 0.5, -8)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(90, 90, 105); corner(99, toggleKnob)

    local isOn = false
    local function setToggle(state)
        isOn = state
        if isOn then
            tween(toggleBg, 0.15, {BackgroundColor3 = Color3.fromRGB(50, 45, 80)})
            tween(toggleKnob, 0.15, {Position = UDim2.new(0, 21, 0.5, -8), BackgroundColor3 = C.accent2})
        else
            tween(toggleBg, 0.15, {BackgroundColor3 = Color3.fromRGB(42, 42, 50)})
            tween(toggleKnob, 0.15, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(90, 90, 105)})
        end
        if callback then callback(isOn) end
    end

    local clickArea = Instance.new("TextButton", row)
    clickArea.Size = UDim2.new(1, 0, 1, 0); clickArea.BackgroundTransparency = 1; clickArea.Text = ""
    clickArea.MouseButton1Click:Connect(function() setToggle(not isOn) end)

    row.MouseEnter:Connect(function() row.BackgroundColor3 = C.itemHov end)
    row.MouseLeave:Connect(function() row.BackgroundColor3 = C.item end)
    return setToggle
end

local function addSliderRow(titleText, minVal, maxVal, defaultVal, parent, order, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 50); container.BackgroundColor3 = C.item; container.LayoutOrder = order or 1
    container.ClipsDescendants = true
    corner(8, container); local sliderStroke = stroke(C.border, 1, container)
    trackTheme(container, "BackgroundColor3", "item"); trackTheme(sliderStroke, "Color", "border")

    local sliderTitle = label({Text = titleText, Font = Enum.Font.GothamSemibold, TextSize = 13, TextColor3 = C.text,
        Size = UDim2.new(0.6, -10, 0, 20), Position = UDim2.new(0, 10, 0, 5),
        TextXAlignment = Enum.TextXAlignment.Left}, container)
    trackTheme(sliderTitle, "TextColor3", "text")

    local valLabel = label({Text = tostring(defaultVal), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.accent2,
        Size = UDim2.new(0.4, -10, 0, 20), Position = UDim2.new(0.6, 0, 0, 5),
        TextXAlignment = Enum.TextXAlignment.Right}, container)
    trackAccent2(valLabel, "TextColor3")

    local track = Instance.new("Frame", container)
    track.Size = UDim2.new(1, -20, 0, 5); track.Position = UDim2.new(0, 10, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(42, 42, 55); corner(99, track)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = C.accent; fill.BorderSizePixel = 0; corner(99, fill)
    trackAccent(fill, "BackgroundColor3")

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    knob.BackgroundColor3 = C.white; corner(99, knob)

    local currentVal = defaultVal
    local dragging = false

    local dragBtn = Instance.new("TextButton", container)
    dragBtn.Size = UDim2.new(1, -20, 0, 20); dragBtn.Position = UDim2.new(0, 10, 0, 26)
    dragBtn.BackgroundTransparency = 1; dragBtn.Text = ""

    local function updateSlider(x)
        local trackAbsX = track.AbsolutePosition.X
        local trackAbsW = track.AbsoluteSize.X
        if trackAbsW <= 0 then return end
        local pct = math.clamp((x - trackAbsX) / trackAbsW, 0, 1)
        currentVal = math.floor(minVal + pct * (maxVal - minVal))
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -6, 0.5, -6)
        valLabel.Text = tostring(currentVal)
        if callback then callback(currentVal) end
    end

    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
        updateSlider(UserInputService:GetMouseLocation().X)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    return container
end

local function addTpButton(titleText, coords, dotColor, parent, order, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundColor3 = C.item; btn.Text = ""; btn.LayoutOrder = order or 1
    btn.ClipsDescendants = true
    corner(8, btn); local tpStroke = stroke(C.border, 1, btn)
    trackTheme(btn, "BackgroundColor3", "item"); trackTheme(tpStroke, "Color", "border")

    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 8, 0, 8); dot.Position = UDim2.new(0, 10, 0.5, -4)
    dot.BackgroundColor3 = dotColor; corner(99, dot)

    local tpTitle = label({Text = titleText, Font = Enum.Font.GothamSemibold, TextSize = 12, TextColor3 = C.text,
        Size = UDim2.new(0.55, -20, 1, 0), Position = UDim2.new(0, 22, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left}, btn)
    trackTheme(tpTitle, "TextColor3", "text")
    local tpCoords = label({Text = coords, Font = Enum.Font.Code, TextSize = 9, TextColor3 = C.sub,
        Size = UDim2.new(0.45, -10, 1, 0), Position = UDim2.new(0.55, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right}, btn)
    trackTheme(tpCoords, "TextColor3", "sub")

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = C.itemHov end)
    btn.MouseLeave:Connect(function() tween(btn, 0.08, {BackgroundColor3 = C.item}) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, {BackgroundColor3 = Color3.fromRGB(30, 32, 60)})
        task.wait(0.15); tween(btn, 0.08, {BackgroundColor3 = C.item})
        if callback then callback() end
    end)
    return btn
end

local function addButtonRow(titleText, parent, order, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundColor3 = C.item; btn.Text = ""
    btn.LayoutOrder = order or 1; btn.ClipsDescendants = true
    corner(8, btn); local btnStroke = stroke(C.border, 1, btn)
    trackTheme(btn, "BackgroundColor3", "item"); trackTheme(btnStroke, "Color", "border")

    local btnTitle = label({Text = titleText, Font = Enum.Font.GothamSemibold, TextSize = 13, TextColor3 = C.text,
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left}, btn)
    trackTheme(btnTitle, "TextColor3", "text")

    local arrow = label({Text = ">", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.sub,
        Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(1, -22, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right}, btn)

    btn.MouseEnter:Connect(function() tween(btn, 0.08, {BackgroundColor3 = C.itemHov}) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.08, {BackgroundColor3 = C.item}) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, {BackgroundColor3 = Color3.fromRGB(30, 32, 60)})
        task.wait(0.12); tween(btn, 0.08, {BackgroundColor3 = C.item})
        if callback then callback() end
    end)
    return btn
end

local function addDropdownRow(titleText, options, parent, order, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 38); container.BackgroundColor3 = C.item
    container.LayoutOrder = order or 1; container.ClipsDescendants = true
    corner(8, container); local ddStroke = stroke(C.border, 1, container)
    trackTheme(container, "BackgroundColor3", "item"); trackTheme(ddStroke, "Color", "border")

    local selectedLabel = label({Text = titleText, Font = Enum.Font.GothamSemibold, TextSize = 13,
        TextColor3 = C.text, Size = UDim2.new(1, -30, 0, 38), Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left}, container)
    trackTheme(selectedLabel, "TextColor3", "text")

    local arrowLabel = label({Text = "v", Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = C.sub, Size = UDim2.new(0, 16, 0, 38), Position = UDim2.new(1, -22, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right}, container)

    local expanded = false
    local optionFrames = {}
    local baseHeight = 38
    local optionHeight = 30

    local function createOptions(opts)
        for _, f in ipairs(optionFrames) do f:Destroy() end
        optionFrames = {}
        for i, opt in ipairs(opts) do
            local optBtn = Instance.new("TextButton", container)
            optBtn.Size = UDim2.new(1, -12, 0, optionHeight)
            optBtn.Position = UDim2.new(0, 6, 0, baseHeight + (i-1) * (optionHeight + 2))
            optBtn.BackgroundColor3 = Color3.fromRGB(28, 24, 38); optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham; optBtn.TextSize = 11; optBtn.TextColor3 = C.text
            corner(5, optBtn)

            optBtn.MouseEnter:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = Color3.fromRGB(38, 34, 52)}) end)
            optBtn.MouseLeave:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = Color3.fromRGB(28, 24, 38)}) end)
            optBtn.MouseButton1Click:Connect(function()
                selectedLabel.Text = titleText .. ": " .. opt
                if callback then callback(opt) end
                expanded = false
                container.Size = UDim2.new(1, 0, 0, baseHeight)
                arrowLabel.Text = "v"
            end)
            table.insert(optionFrames, optBtn)
        end
    end
    createOptions(options)

    local headerBtn = Instance.new("TextButton", container)
    headerBtn.Size = UDim2.new(1, 0, 0, 38); headerBtn.BackgroundTransparency = 1; headerBtn.Text = ""
    headerBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local totalH = baseHeight + #optionFrames * (optionHeight + 2) + 4
            container.Size = UDim2.new(1, 0, 0, totalH)
            arrowLabel.Text = "^"
        else
            container.Size = UDim2.new(1, 0, 0, baseHeight)
            arrowLabel.Text = "v"
        end
    end)

    container.MouseEnter:Connect(function() if not expanded then tween(container, 0.08, {BackgroundColor3 = C.itemHov}) end end)
    container.MouseLeave:Connect(function() tween(container, 0.08, {BackgroundColor3 = C.item}) end)

    local function refresh(newOptions)
        createOptions(newOptions)
    end

    return {container = container, refresh = refresh}
end

-- ============================================================
--  PAGES & NAV BUTTONS (9 tabs - added Bounty)
-- ============================================================
local homePage     = createPage("Home")
local combatPage   = createPage("Combat")
local playerPage   = createPage("PlayerLock")
local extraPage    = createPage("ExtraFunctions")
local visualPage   = createPage("Visual")
local movePage     = createPage("Movement")
local tpPage       = createPage("Teleport")
local bountyPage   = createPage("BountyHunt")
local settingsPage = createPage("Settings")

createNavBtn("Home",           "  Home")
createNavBtn("Combat",         "  Combat")
createNavBtn("PlayerLock",     "  Player Lock")
createNavBtn("ExtraFunctions", "  Extra")
createNavBtn("Visual",         "  Visual")
createNavBtn("Movement",       "  Movement")
createNavBtn("Teleport",       "  Teleport")
createNavBtn("BountyHunt",     "  Bounty Hunt")
createNavBtn("Settings",       "  Settings")

-- ============================================================
--  HOME PAGE
-- ============================================================
local banner = Instance.new("Frame", homePage)
banner.Size = UDim2.new(1, 0, 0, 80)
banner.BackgroundColor3 = C.panel
banner.ClipsDescendants = true
trackTheme(banner, "BackgroundColor3", "panel")
banner.LayoutOrder = 1; corner(10, banner)
local bannerStroke = stroke(C.border, 1, banner)
trackTheme(bannerStroke, "Color", "border")

local bannerGlow = Instance.new("Frame", banner)
bannerGlow.Size = UDim2.new(1, 0, 0, 3)
bannerGlow.Position = UDim2.new(0, 0, 0, 0)
bannerGlow.BackgroundColor3 = C.accent; bannerGlow.BorderSizePixel = 0
trackAccent(bannerGlow, "BackgroundColor3")

local bannerGlowBottom = Instance.new("Frame", banner)
bannerGlowBottom.Size = UDim2.new(1, 0, 0, 1)
bannerGlowBottom.Position = UDim2.new(0, 0, 1, -1)
bannerGlowBottom.BackgroundColor3 = C.accent; bannerGlowBottom.BorderSizePixel = 0
bannerGlowBottom.BackgroundTransparency = 0.6
trackAccent(bannerGlowBottom, "BackgroundColor3")

local iconWrap = Instance.new("Frame", banner)
iconWrap.Size = UDim2.new(0, 52, 0, 52); iconWrap.Position = UDim2.new(0, 10, 0.5, -26)
iconWrap.BackgroundColor3 = Color3.fromRGB(22, 17, 38); iconWrap.ClipsDescendants = true
corner(99, iconWrap); stroke(C.accent, 2, iconWrap)

local iconImage = Instance.new("ImageLabel", iconWrap)
iconImage.Size = UDim2.new(1, 0, 1, 0); iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxassetid://73809607992968"; iconImage.ScaleType = Enum.ScaleType.Fit; iconImage.ZIndex = 10

local bannerTitle = label({Text = "PANELBLOX PREMIUM", Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = C.accent,
    Size = UDim2.new(1, -76, 0, 22), Position = UDim2.new(0, 70, 0, 12),
    TextXAlignment = Enum.TextXAlignment.Left}, banner)
bannerTitle.TextTruncate = Enum.TextTruncate.AtEnd
trackAccent(bannerTitle, "TextColor3")

local statusRow = Instance.new("Frame", banner)
statusRow.Size = UDim2.new(1, -76, 0, 18); statusRow.Position = UDim2.new(0, 70, 0, 38)
statusRow.BackgroundTransparency = 1

local statusDot = Instance.new("Frame", statusRow)
statusDot.Size = UDim2.new(0, 5, 0, 5); statusDot.Position = UDim2.new(0, 0, 0.5, -2)
statusDot.BackgroundColor3 = C.green; corner(99, statusDot)

label({Text = "Active", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.green,
    Size = UDim2.new(0, 42, 1, 0), Position = UDim2.new(0, 8, 0, 0)}, statusRow)
label({Text = LocalPlayer.Name, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.sub,
    Size = UDim2.new(1, -56, 1, 0), Position = UDim2.new(0, 56, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left}, statusRow)

-- Info grid
local infoGrid = Instance.new("Frame", homePage)
infoGrid.Size = UDim2.new(1, 0, 0, 56); infoGrid.BackgroundTransparency = 1; infoGrid.LayoutOrder = 2
local gridLayout = Instance.new("UIGridLayout", infoGrid)
gridLayout.CellSize = UDim2.new(0.5, -3, 1, 0); gridLayout.CellPadding = UDim2.new(0, 6, 0, 0)

for _, d in ipairs({{"Version", "v3.0 Premium"}, {"Executor", "Delta"}}) do
    local card = Instance.new("Frame", infoGrid); card.BackgroundColor3 = C.item
    corner(8, card); local cardStroke = stroke(C.border, 1, card)
    trackTheme(card, "BackgroundColor3", "item"); trackTheme(cardStroke, "Color", "border")
    local cardSub = label({Text = d[1], Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.sub,
        Size = UDim2.new(1,-16,0,16), Position = UDim2.new(0,8,0,8)}, card)
    trackTheme(cardSub, "TextColor3", "sub")
    local cardVal = label({Text = d[2], Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.accent2,
        Size = UDim2.new(1,-16,0,20), Position = UDim2.new(0,8,0,26)}, card)
    trackAccent2(cardVal, "TextColor3")
end

-- Discord row
local discordRow = Instance.new("TextButton", homePage)
discordRow.Size = UDim2.new(1, 0, 0, 36); discordRow.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
discordRow.Text = ""; discordRow.LayoutOrder = 3; corner(8, discordRow)
stroke(Color3.fromRGB(60, 65, 140), 1, discordRow)
label({Text = "Nana cantik", Font = Enum.Font.GothamSemibold, TextSize = 13,
    TextColor3 = C.accent2, Size = UDim2.new(1,0,1,0), TextXAlignment = Enum.TextXAlignment.Center}, discordRow)
discordRow.MouseEnter:Connect(function() tween(discordRow, 0.1, {BackgroundColor3 = Color3.fromRGB(25,25,65)}) end)
discordRow.MouseLeave:Connect(function() tween(discordRow, 0.1, {BackgroundColor3 = Color3.fromRGB(20,20,50)}) end)

-- GUI Size selector
addSectionTitle("GUI Size", homePage, 4)
local sizeContainer = Instance.new("Frame", homePage)
sizeContainer.Size = UDim2.new(1, 0, 0, 40); sizeContainer.BackgroundColor3 = C.item; sizeContainer.LayoutOrder = 5
corner(8, sizeContainer); local szStroke = stroke(C.border, 1, sizeContainer)
trackTheme(sizeContainer, "BackgroundColor3", "item"); trackTheme(szStroke, "Color", "border")
local szLayout = Instance.new("UIListLayout", sizeContainer)
szLayout.FillDirection = Enum.FillDirection.Horizontal
szLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
szLayout.VerticalAlignment = Enum.VerticalAlignment.Center; szLayout.Padding = UDim.new(0, 4)
local szPad = Instance.new("UIPadding", sizeContainer)
szPad.PaddingLeft = UDim.new(0, 6); szPad.PaddingRight = UDim.new(0, 6)

local sizeButtons = {}
local function applySizeBtn(selected)
    for _, data in ipairs(sizeButtons) do
        if data.name == selected then
            data.btn.BackgroundColor3 = C.accent; data.btn.TextColor3 = C.white
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); data.btn.TextColor3 = C.sub
        end
    end
end

for _, s in ipairs({
    {label = "Small", w = 440, h = 310},
    {label = "Medium", w = 530, h = 380},
    {label = "Large",  w = 620, h = 450},
}) do
    local btn = Instance.new("TextButton", sizeContainer)
    btn.Size = UDim2.new(0, 84, 0, 26)
    btn.BackgroundColor3 = s.label == "Medium" and C.accent or Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = s.label == "Medium" and C.white or C.sub
    btn.Text = s.label; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 11
    corner(5, btn)
    table.insert(sizeButtons, {btn = btn, name = s.label})
    btn.MouseButton1Click:Connect(function()
        currentGuiSize = s.label; applySizeBtn(s.label)
        tween(mainFrame, 0.25, {
            Size = UDim2.new(0, s.w, 0, s.h),
            Position = UDim2.new(0.5, -s.w/2, 0.5, -s.h/2),
        })
    end)
end

-- ============================================================
--  COMBAT PAGE
-- ============================================================
addSectionTitle("Attack", combatPage, 1)

addToggleRow("Fast Attack", "Multi-target", combatPage, 2, function(on)
    FastAttackEnabled = on
    if on then StartFastAttack() else StopFastAttack() end
end)

addDropdownRow("Target Mode", {"NPCs + Players", "Only NPCs", "Only Players"}, combatPage, 3, function(opt)
    if opt == "NPCs + Players" then TargetMode = "NPCsPlayers"
    elseif opt == "Only NPCs" then TargetMode = "OnlyNPCs"
    else TargetMode = "OnlyPlayers" end
end)

addSectionTitle("Aimlock", combatPage, 5)

addToggleRow("Aimlock", "Open panel - Q to lock", combatPage, 6, function(on)
    if on then
        if aimlockGui then aimlockGui:Destroy(); aimlockGui = nil end
        task.spawn(function()
            local player = LocalPlayer
            local main = Instance.new("ScreenGui")
            main.Name = "Aimlock_PANELBLOX"; main.Parent = player:WaitForChild("PlayerGui")
            main.ResetOnSpawn = false; main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            aimlockGui = main

            local Frame = Instance.new("Frame", main)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
            Frame.Position = UDim2.new(0.5, -100, 0, 10)
            Frame.Size = UDim2.new(0, 200, 0, 120)
            Frame.Active = true; Frame.Draggable = true
            local fc = Instance.new("UICorner", Frame); fc.CornerRadius = UDim.new(0, 8)
            local fs = Instance.new("UIStroke", Frame); fs.Color = C.accent; fs.Thickness = 1

            local titleLbl = Instance.new("TextLabel", Frame)
            titleLbl.Size = UDim2.new(1, -32, 0, 28)
            titleLbl.Position = UDim2.new(0, 8, 0, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = "AIMLOCK"; titleLbl.Font = Enum.Font.GothamBlack
            titleLbl.TextSize = 13; titleLbl.TextColor3 = C.accent
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local closeBtn3 = Instance.new("TextButton", Frame)
            closeBtn3.Size = UDim2.new(0, 28, 0, 28)
            closeBtn3.Position = UDim2.new(1, -28, 0, 0)
            closeBtn3.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            closeBtn3.Text = "X"; closeBtn3.Font = Enum.Font.GothamBold
            closeBtn3.TextSize = 14; closeBtn3.TextColor3 = Color3.new(1,1,1)
            local cc = Instance.new("UICorner", closeBtn3); cc.CornerRadius = UDim.new(0, 6)

            local toggleBtn = Instance.new("TextButton", Frame)
            toggleBtn.Size = UDim2.new(1, -16, 0, 30)
            toggleBtn.Position = UDim2.new(0, 8, 0, 32)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleBtn.Text = "AIMLOCK OFF (Q)"; toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 13; toggleBtn.TextColor3 = Color3.new(1,1,1)
            local tc = Instance.new("UICorner", toggleBtn); tc.CornerRadius = UDim.new(0, 6)

            local offsetLbl = Instance.new("TextLabel", Frame)
            offsetLbl.Size = UDim2.new(0.5, -8, 0, 20)
            offsetLbl.Position = UDim2.new(0, 8, 0, 68)
            offsetLbl.BackgroundTransparency = 1
            offsetLbl.Text = "Y Offset: 0"; offsetLbl.Font = Enum.Font.GothamSemibold
            offsetLbl.TextSize = 11; offsetLbl.TextColor3 = C.white
            offsetLbl.TextXAlignment = Enum.TextXAlignment.Left

            local offMinus = Instance.new("TextButton", Frame)
            offMinus.Size = UDim2.new(0, 40, 0, 24)
            offMinus.Position = UDim2.new(0.5, 4, 0, 66)
            offMinus.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
            offMinus.Text = "-"; offMinus.Font = Enum.Font.GothamBold
            offMinus.TextSize = 16; offMinus.TextColor3 = Color3.new(1,1,1)
            local mc = Instance.new("UICorner", offMinus); mc.CornerRadius = UDim.new(0, 5)

            local offPlus = Instance.new("TextButton", Frame)
            offPlus.Size = UDim2.new(0, 40, 0, 24)
            offPlus.Position = UDim2.new(0.5, 50, 0, 66)
            offPlus.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
            offPlus.Text = "+"; offPlus.Font = Enum.Font.GothamBold
            offPlus.TextSize = 16; offPlus.TextColor3 = Color3.new(1,1,1)
            local pc = Instance.new("UICorner", offPlus); pc.CornerRadius = UDim.new(0, 5)

            local statusLbl = Instance.new("TextLabel", Frame)
            statusLbl.Size = UDim2.new(1, -16, 0, 16)
            statusLbl.Position = UDim2.new(0, 8, 0, 96)
            statusLbl.BackgroundTransparency = 1
            statusLbl.Text = "Press Q to lock nearest enemy"
            statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 9
            statusLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
            statusLbl.TextXAlignment = Enum.TextXAlignment.Left

            AimlockEnabled = true
            u19 = FindNearestEnemy(); u4 = true

            local function updateToggleVisual()
                if u4 then
                    toggleBtn.Text = "AIMLOCK ON (Q)"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
                else
                    toggleBtn.Text = "AIMLOCK OFF (Q)"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
            end
            updateToggleVisual()

            toggleBtn.MouseButton1Click:Connect(function()
                if u4 then
                    u4 = false; u19 = nil
                else
                    u19 = FindNearestEnemy(); u4 = true
                end
                updateToggleVisual()
            end)

            offMinus.MouseButton1Click:Connect(function()
                AimlockVerticalOffset = math.max(AimlockVerticalOffset - 1, -5)
                offsetLbl.Text = "Y Offset: " .. AimlockVerticalOffset
            end)

            offPlus.MouseButton1Click:Connect(function()
                AimlockVerticalOffset = math.min(AimlockVerticalOffset + 1, 5)
                offsetLbl.Text = "Y Offset: " .. AimlockVerticalOffset
            end)

            closeBtn3.MouseButton1Click:Connect(function()
                AimlockEnabled = false; u4 = false; u19 = nil
                main:Destroy(); aimlockGui = nil
            end)

            task.spawn(function()
                local hue = 0
                while titleLbl and titleLbl.Parent do
                    hue = (hue + 5) % 360
                    titleLbl.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
                    task.wait(0.03)
                end
            end)
        end)
    else
        AimlockEnabled = false; u4 = false; u19 = nil
        if aimlockGui then aimlockGui:Destroy(); aimlockGui = nil end
    end
end)

-- ============================================================
--  PLAYER LOCK PAGE
-- ============================================================
addSectionTitle("Player Selection", playerPage, 1)

local playerDropdown = addDropdownRow("Player", GetPlayerList(), playerPage, 2, function(opt)
    if opt == "None" then SelectedPlayer = nil
    else SelectedPlayer = opt end
end)

addButtonRow("Refresh List", playerPage, 3, function()
    playerDropdown.refresh(GetPlayerList())
    addNotification("Player Lock", "List refreshed", C.green)
end)

addSectionTitle("Tracking", playerPage, 4)

addToggleRow("Tween to Player", "CFrame.Lerp + NoClip + Prediction", playerPage, 5, function(v)
    TeleportEnabled = v
    if v then
        StartTweenFollow()
        TeleportConnection = RunService.Heartbeat:Connect(function(dt)
            if not TeleportEnabled then return end
            pcall(function()
                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end

                if not SelectedPlayer then return end
                local target = Players:FindFirstChild(SelectedPlayer)
                if not target or not target.Character then return end
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if not targetHRP then return end

                local predictedPos = targetHRP.Position
                    + (targetHRP.Velocity * 0.13)
                    + Vector3.new(0, YOffset, 0)
                local targetCFrame = CFrame.new(predictedPos)
                    * CFrame.Angles(0, math.rad(targetHRP.Orientation.Y), 0)

                local dist = (myHRP.Position - predictedPos).Magnitude

                if dist < 0.1 then
                    myHRP.CFrame = targetCFrame
                else
                    local alpha = math.min(1, (TweenSpeedVal * dt) / dist)
                    myHRP.CFrame = myHRP.CFrame:Lerp(targetCFrame, alpha)
                end

                myHRP.Velocity = Vector3.new(0, 0, 0)
            end)
        end)
    else
        if TeleportConnection then TeleportConnection:Disconnect(); TeleportConnection = nil end
        StopTweenFollow()
    end
end)

addSliderRow("Tween Speed", 50, 350, 350, playerPage, 6, function(val)
    TweenSpeedVal = val
end)

addToggleRow("Instant TP", "Continuous teleport", playerPage, 7, function(v)
    InstaTeleportEnabled = v
    if v then
        InstaTpConnection = RunService.Stepped:Connect(function()
            if SelectedPlayer then
                pcall(function()
                    local target = Players:FindFirstChild(SelectedPlayer)
                    if target and target.Character then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, YOffset, 0)
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    end
                end)
            end
        end)
    else
        if InstaTpConnection then InstaTpConnection:Disconnect(); InstaTpConnection = nil end
    end
end)

addSliderRow("Y Offset", 0, 500, 0, playerPage, 8, function(val)
    YOffset = val
end)

addToggleRow("Spectate", "View another player's camera", playerPage, 9, function(v)
    SpectateEnabled = v
    if v then
        SpectateConnection = RunService.RenderStepped:Connect(function()
            if SelectedPlayer then
                local target = Players:FindFirstChild(SelectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            end
        end)
    else
        if SpectateConnection then SpectateConnection:Disconnect(); SpectateConnection = nil end
        pcall(function() workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid end)
    end
end)

addSectionTitle("Orbit & Tracker", playerPage, 10)

addToggleRow("Orbit Attack", "Orbit around enemy", playerPage, 11, function(v)
    OrbitEnabled = v
end)

addSliderRow("Orbit Distance", 2, 50, 5, playerPage, 12, function(val)
    OrbitDistance = val
end)

addSliderRow("Orbit Height", 2, 350, 2, playerPage, 13, function(val)
    OrbitHeight = val
end)

addSectionTitle("Auto Escape", playerPage, 14)

addToggleRow("Auto Escape", "Rise if health below threshold", playerPage, 15, function(v)
    AutoEscapeEnabled = v
    if v then
        AutoEscapeActive = false
        AutoEscapeConn = RunService.Heartbeat:Connect(function(dt)
            if not AutoEscapeEnabled then return end
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end

                local hpPercent = (hum.Health / hum.MaxHealth) * 100

                if hpPercent <= AutoEscapeThreshold and hum.Health > 0 then
                    AutoEscapeActive = true
                    local escapePos = hrp.Position + Vector3.new(0, 450 * dt, 0)
                    hrp.CFrame = CFrame.new(escapePos) * CFrame.Angles(0, math.rad(hrp.Orientation.Y), 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                else
                    if AutoEscapeActive then
                        AutoEscapeActive = false
                        SetCollide()
                    end
                end
            end)
        end)
        addNotification("Auto Escape", "Activated - Threshold: " .. AutoEscapeThreshold .. "%", C.green)
    else
        AutoEscapeActive = false
        if AutoEscapeConn then AutoEscapeConn:Disconnect(); AutoEscapeConn = nil end
        SetCollide()
    end
end)

addSliderRow("Health Threshold (%)", 20, 60, 30, playerPage, 16, function(val)
    AutoEscapeThreshold = val
end)

-- ============================================================
--  EXTRA FUNCTIONS PAGE
-- ============================================================
addSectionTitle("Fruit Attacks", extraPage, 1)

addToggleRow("Fruit Attack (Kitsune)", "Ultra Speed - LeftClickRemote", extraPage, 2, function(v)
    FruitAttackKitsune = v
    if v then
        task.spawn(function()
            while FruitAttackKitsune do
                task.wait(0.001)
                pcall(function()
                    local targetPlayer = GetNearestPlayer()
                    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
                        local tool = LocalPlayer.Character:FindFirstChild("Kitsune-Kitsune")
                        if tool then
                            local direction = (targetPlayer.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
                            tool:WaitForChild("LeftClickRemote"):FireServer(direction, 1, true)
                        end
                    end
                end)
            end
        end)
    end
end)

addToggleRow("Fruit Attack (T-Rex)", "Ultra Speed - LeftClickRemote", extraPage, 3, function(v)
    FruitAttackTRex = v
    if v then
        task.spawn(function()
            while FruitAttackTRex do
                task.wait(0.001)
                pcall(function()
                    local targetPlayer = GetNearestPlayer()
                    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
                        local tool = LocalPlayer.Character:FindFirstChild("T-Rex-T-Rex")
                        if tool then
                            local direction = (targetPlayer.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit
                            tool:WaitForChild("LeftClickRemote"):FireServer(direction, 1)
                        end
                    end
                end)
            end
        end)
    end
end)

addSectionTitle("Automation", extraPage, 4)

addToggleRow("Auto V4 Awakening", "Automatically activate awakening", extraPage, 5, function(v)
    AutoAwakening = v
    if v then
        if v4Connection then pcall(function() task.cancel(v4Connection) end) end
        v4Connection = task.spawn(function()
            while AutoAwakening do
                task.wait(0.5)
                pcall(function()
                    local tool = LocalPlayer.Backpack:FindFirstChild("Awakening") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Awakening"))
                    if tool and tool:FindFirstChild("RemoteFunction") then
                        tool.RemoteFunction:InvokeServer(true)
                    end
                end)
            end
        end)
    else
        if v4Connection then pcall(function() task.cancel(v4Connection) end); v4Connection = nil end
    end
end)

addSectionTitle("Other", extraPage, 6)

addToggleRow("Invisible Mode", "Destroys LowerTorso.Root", extraPage, 7, function(v)
    if v then
        local function destroyRoot()
            local char = LocalPlayer.Character
            if not char then return false end
            local lt = char:FindFirstChild("LowerTorso")
            if lt then
                local root = lt:FindFirstChild("Root")
                if root then root:Destroy(); return true end
            end
            return false
        end
        if destroyRoot() then
            addNotification("Invisible", "Invisible mode activated", C.green)
        else
            task.spawn(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                task.wait(1)
                if char and char:FindFirstChild("LowerTorso") then
                    local root = char.LowerTorso:FindFirstChild("Root")
                    if root then root:Destroy(); addNotification("Invisible", "Invisible mode activated", C.green)
                    else addNotification("Invisible", "LowerTorso.Root not found", C.orange) end
                else addNotification("Invisible", "LowerTorso not found", C.orange) end
            end)
        end
    end
end)

addToggleRow("One Shot (Shotho)", "Open panel - Auto off if HP <20%", extraPage, 7.5, function(on)
    if on then
        if oneShotGui then oneShotGui:Destroy(); oneShotGui = nil end
        task.spawn(function()
            local player = LocalPlayer
            local main = Instance.new("ScreenGui")
            main.Name = "OneShot_PANELBLOX"; main.Parent = player:WaitForChild("PlayerGui")
            main.ResetOnSpawn = false; main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            oneShotGui = main

            local Frame = Instance.new("Frame", main)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
            Frame.Position = UDim2.new(0.1, 0, 0.55, 0)
            Frame.Size = UDim2.new(0, 160, 0, 80)
            Frame.Active = true; Frame.Draggable = true
            local fc = Instance.new("UICorner", Frame); fc.CornerRadius = UDim.new(0, 8)
            local fs = Instance.new("UIStroke", Frame); fs.Color = C.accent; fs.Thickness = 1

            local titleLbl = Instance.new("TextLabel", Frame)
            titleLbl.Size = UDim2.new(1, -40, 0, 28)
            titleLbl.Position = UDim2.new(0, 0, 0, 0)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = "ONE SHOT"; titleLbl.Font = Enum.Font.GothamBlack
            titleLbl.TextSize = 13; titleLbl.TextColor3 = C.accent

            local closeBtn2 = Instance.new("TextButton", Frame)
            closeBtn2.Size = UDim2.new(0, 28, 0, 28)
            closeBtn2.Position = UDim2.new(1, -28, 0, 0)
            closeBtn2.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            closeBtn2.Text = "X"; closeBtn2.Font = Enum.Font.GothamBold
            closeBtn2.TextSize = 14; closeBtn2.TextColor3 = Color3.new(1,1,1)
            local cc = Instance.new("UICorner", closeBtn2); cc.CornerRadius = UDim.new(0, 6)

            local toggleBtn = Instance.new("TextButton", Frame)
            toggleBtn.Size = UDim2.new(1, -16, 0, 34)
            toggleBtn.Position = UDim2.new(0, 8, 0, 36)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleBtn.Text = "SHOTHO OFF"; toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 14; toggleBtn.TextColor3 = Color3.new(1,1,1)
            local tc = Instance.new("UICorner", toggleBtn); tc.CornerRadius = UDim.new(0, 6)

            local onenabledshotho = false

            toggleBtn.MouseButton1Click:Connect(function()
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                onenabledshotho = not onenabledshotho
                toggleBtn.Text = onenabledshotho and "SHOTHO ON" or "SHOTHO OFF"
                toggleBtn.BackgroundColor3 = onenabledshotho and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(50, 50, 50)

                if onenabledshotho then
                    task.spawn(function()
                        while onenabledshotho do
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                if humanoid.MaxHealth > 0 and (humanoid.Health / humanoid.MaxHealth) <= 0.2 then
                                    onenabledshotho = false
                                    toggleBtn.Text = "SHOTHO OFF"
                                    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                    addNotification("One Shot", "Auto-off: low HP", C.orange)
                                    break
                                end
                            end
                            local pos = hrp.Position
                            hrp.CFrame = CFrame.new(pos.X, pos.Y - 795679695796326795679695796326, pos.Z)
                            task.wait(0.01)
                        end
                    end)
                end
            end)

            closeBtn2.MouseButton1Click:Connect(function()
                onenabledshotho = false
                main:Destroy(); oneShotGui = nil
            end)
        end)
    else
        if oneShotGui then oneShotGui:Destroy(); oneShotGui = nil end
    end
end)

addSectionTitle("Profile Showcase", extraPage, 8)

local ShowcaseSlot = 1
local ShowcaseItemId = 786
local ShowcaseItemName = "Pirate King"

local ShowcaseItems = {
    {name = "Pirate King",          id = 786},
    {name = "Le Antigua",           id = 65},
    {name = "Super Ultra Pain",     id = 478},
    {name = "Cotton Candy Pain",    id = 478},
    {name = "YouTuber",             id = 680},
    {name = "Pink Portal",          id = 458},
    {name = "Equal to the Heaven",  id = 737},
    {name = "Dragon Fisica",        id = 254},
}

local slotNames = {"Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6"}
addDropdownRow("Slot", slotNames, extraPage, 9, function(opt)
    ShowcaseSlot = tonumber(opt:match("%d+")) or 1
end)

local itemNames = {}
for _, item in ipairs(ShowcaseItems) do table.insert(itemNames, item.name) end
addDropdownRow("Item", itemNames, extraPage, 10, function(opt)
    for _, item in ipairs(ShowcaseItems) do
        if item.name == opt then
            ShowcaseItemId = item.id
            ShowcaseItemName = item.name
            break
        end
    end
end)

addButtonRow("Apply Showcase", extraPage, 11, function()
    pcall(function()
        local args = {"Showcase", ShowcaseSlot, ShowcaseItemId}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdatePlayerProfileValue"):InvokeServer(unpack(args))
    end)
    addNotification("Showcase", ShowcaseItemName .. " on Slot " .. ShowcaseSlot, C.green)
end)

-- ============================================================
--  VISUAL PAGE (with Skeleton ESP)
-- ============================================================
addSectionTitle("ESP", visualPage, 1)

addToggleRow("ESP Players + NPCs", "Names above head (BillboardGui)", visualPage, 2, function(on)
    ESPEnabled = on; UpdateESP()
end)

addToggleRow("ESP Drawing", "With distance in meters (Drawing API)", visualPage, 3, function(on)
    ESPDrawingEnabled = on
end)

-- [NEW] Skeleton ESP Toggle
addToggleRow("Skeleton ESP", "Shows player skeleton (Neon lines)", visualPage, 3.5, function(on)
    ESP_SkeletonEnabled = on
    if on then
        UpdateSkeletonESP()
    else
        ClearSkeletonESP()
    end
end)

local drawingESPConnections = {}
local function CreateDrawingESP(plr)
    local NameTag = Drawing.new("Text")
    NameTag.Visible = false; NameTag.Center = true; NameTag.Outline = true
    NameTag.Font = 2; NameTag.Size = 14; NameTag.Color = C.accent

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if ESPDrawingEnabled and plr and plr.Parent and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= LocalPlayer then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
            if onScreen then
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist = myHRP and math.floor((myHRP.Position - hrp.Position).Magnitude) or 0
                NameTag.Position = Vector2.new(pos.X, pos.Y)
                NameTag.Text = plr.Name .. " [" .. dist .. "m]"
                NameTag.Visible = true
            else
                NameTag.Visible = false
            end
        else
            NameTag.Visible = false
            if not plr or not plr.Parent then
                NameTag:Remove(); connection:Disconnect()
            end
        end
    end)
    table.insert(drawingESPConnections, connection)
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateDrawingESP(v) end
end
Players.PlayerAdded:Connect(function(plr) CreateDrawingESP(plr) end)

task.spawn(function()
    while true do 
        task.wait(5)
        if ESPEnabled then UpdateESP() end
        if ESP_SkeletonEnabled then UpdateSkeletonESP() end
    end
end)

addSectionTitle("Performance", visualPage, 4)

local fpsBtn = Instance.new("TextButton", visualPage)
fpsBtn.Size = UDim2.new(1, 0, 0, 48); fpsBtn.BackgroundColor3 = C.item; fpsBtn.Text = ""
fpsBtn.LayoutOrder = 6; fpsBtn.ClipsDescendants = true
corner(8, fpsBtn); local fpsStroke = stroke(C.border, 1, fpsBtn)
trackTheme(fpsBtn, "BackgroundColor3", "item"); trackTheme(fpsStroke, "Color", "border")

local fpsTitle = label({Text = "FPS Booster", Font = Enum.Font.GothamSemibold, TextSize = 13, TextColor3 = C.text,
    Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 6)}, fpsBtn)
trackTheme(fpsTitle, "TextColor3", "text")
local fpsSubLabel = label({Text = "Press to execute",
    Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.sub,
    Size = UDim2.new(1, -20, 0, 14), Position = UDim2.new(0, 10, 0, 27)}, fpsBtn)

local fpsDot = Instance.new("Frame", fpsBtn)
fpsDot.Size = UDim2.new(0, 7, 0, 7); fpsDot.Position = UDim2.new(1, -18, 0.5, -3)
fpsDot.BackgroundColor3 = C.sub; corner(99, fpsDot)

fpsBtn.MouseEnter:Connect(function() tween(fpsBtn, 0.08, {BackgroundColor3 = C.itemHov}) end)
fpsBtn.MouseLeave:Connect(function() tween(fpsBtn, 0.08, {BackgroundColor3 = C.item}) end)

fpsBtn.MouseButton1Click:Connect(function()
    fpsSubLabel.Text = "Loading..."; tween(fpsDot, 0.3, {BackgroundColor3 = C.orange})
    task.spawn(function()
        local ok = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
        end)
        if ok then
            tween(fpsDot, 0.3, {BackgroundColor3 = C.green}); fpsSubLabel.Text = "FPS Booster active"
            fpsSubLabel.TextColor3 = C.green; addNotification("FPS Booster", "Executed successfully", C.green)
        else
            fpsSubLabel.Text = "Error executing"; fpsSubLabel.TextColor3 = C.red
            tween(fpsDot, 0.3, {BackgroundColor3 = C.red})
        end
    end)
end)

addSectionTitle("Visual Effects", visualPage, 7)

addToggleRow("Full Bright", "Maximum lighting", visualPage, 8, function(on)
    FullBrightEnabled = on
    if not on then
        pcall(function()
            game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            game.Lighting.ClockTime = 14; game.Lighting.FogEnd = 100000
        end)
    end
end)

addToggleRow("Plastic Mode", "Change materials to SmoothPlastic", visualPage, 9, function(on)
    if on then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") then pcall(function() v.Material = Enum.Material.SmoothPlastic end) end
        end
        addNotification("Visual", "Plastic mode activated", C.accent)
    end
end)

-- ============================================================
--  MOVEMENT PAGE
-- ============================================================
addSectionTitle("Movement", movePage, 1)

addToggleRow("Infinite Jump", nil, movePage, 2, function(on) iJ = on end)

addToggleRow("No Clip", "Disables collisions", movePage, 3, function(on) ncl = on end)

addToggleRow("Walk on Water", "Smart height Y=9.2", movePage, 4, function(on)
    walkWaterEnabled = on
    if not on and workspace:FindFirstChild("PANELBLOXWater") then
        workspace.PANELBLOXWater:Destroy()
    end
end)

addToggleRow("Fly V6", "Open flight panel", movePage, 5, function(on)
    if on then
        if flyGui then flyGui:Destroy(); flyGui = nil end
        task.spawn(function()
            local player = LocalPlayer
            local main = Instance.new("ScreenGui")
            main.Name = "FlyV6_PANELBLOX"; main.Parent = player:WaitForChild("PlayerGui")
            main.ResetOnSpawn = false; main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            flyGui = main

            local Frame = Instance.new("Frame", main)
            Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137); Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
            Frame.Position = UDim2.new(0.1, 0, 0.38, 0); Frame.Size = UDim2.new(0, 190, 0, 57)
            Frame.Active = true; Frame.Draggable = true

            local up = Instance.new("TextButton", Frame)
            up.BackgroundColor3 = Color3.fromRGB(79, 255, 152); up.Size = UDim2.new(0, 44, 0, 28)
            up.Font = Enum.Font.SourceSans; up.Text = "UP"; up.TextColor3 = Color3.new(0,0,0); up.TextSize = 14

            local down = Instance.new("TextButton", Frame)
            down.BackgroundColor3 = Color3.fromRGB(215, 255, 121); down.Position = UDim2.new(0, 0, 0.491, 0)
            down.Size = UDim2.new(0, 44, 0, 28)
            down.Font = Enum.Font.SourceSans; down.Text = "DOWN"; down.TextColor3 = Color3.new(0,0,0); down.TextSize = 14

            local onof = Instance.new("TextButton", Frame)
            onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74); onof.Position = UDim2.new(0.7, 0, 0.491, 0)
            onof.Size = UDim2.new(0, 56, 0, 28)
            onof.Font = Enum.Font.SourceSans; onof.Text = "fly"; onof.TextColor3 = Color3.new(0,0,0); onof.TextSize = 14

            local titleLbl = Instance.new("TextLabel", Frame)
            titleLbl.BackgroundColor3 = Color3.fromRGB(242, 60, 255); titleLbl.Position = UDim2.new(0.469, 0, 0, 0)
            titleLbl.Size = UDim2.new(0, 100, 0, 28)
            titleLbl.Font = Enum.Font.SourceSans; titleLbl.Text = "FLY V6 Premium"
            titleLbl.TextColor3 = Color3.new(0,0,0); titleLbl.TextScaled = true

            local plus = Instance.new("TextButton", Frame)
            plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255); plus.Position = UDim2.new(0.231, 0, 0, 0)
            plus.Size = UDim2.new(0, 45, 0, 28)
            plus.Font = Enum.Font.SourceSans; plus.Text = "+"; plus.TextColor3 = Color3.new(0,0,0)
            plus.TextScaled = true

            local speedLbl = Instance.new("TextLabel", Frame)
            speedLbl.BackgroundColor3 = Color3.fromRGB(255, 85, 0); speedLbl.Position = UDim2.new(0.468, 0, 0.491, 0)
            speedLbl.Size = UDim2.new(0, 44, 0, 28)
            speedLbl.Font = Enum.Font.SourceSans; speedLbl.Text = "1"; speedLbl.TextColor3 = Color3.new(0,0,0)
            speedLbl.TextScaled = true

            local mine = Instance.new("TextButton", Frame)
            mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247); mine.Position = UDim2.new(0.231, 0, 0.491, 0)
            mine.Size = UDim2.new(0, 45, 0, 29)
            mine.Font = Enum.Font.SourceSans; mine.Text = "-"; mine.TextColor3 = Color3.new(0,0,0)
            mine.TextScaled = true

            local closebutton = Instance.new("TextButton", Frame)
            closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0); closebutton.Font = Enum.Font.SourceSans
            closebutton.Size = UDim2.new(0, 45, 0, 28); closebutton.Text = "X"; closebutton.TextSize = 30
            closebutton.TextColor3 = Color3.fromRGB(255, 255, 255); closebutton.Position = UDim2.new(0, 0, -1, 27)

            local mini = Instance.new("TextButton", Frame)
            mini.BackgroundColor3 = Color3.fromRGB(133, 145, 255); mini.Font = Enum.Font.SourceSans
            mini.Size = UDim2.new(0, 45, 0, 28); mini.Text = "-"; mini.TextSize = 24
            mini.TextColor3 = Color3.new(0,0,0); mini.Position = UDim2.new(0, 44, -1, 27)

            local mini2 = Instance.new("TextButton", Frame)
            mini2.BackgroundColor3 = Color3.fromRGB(133, 145, 255); mini2.Font = Enum.Font.SourceSans
            mini2.Size = UDim2.new(0, 45, 0, 28); mini2.Text = "+"; mini2.TextSize = 24
            mini2.TextColor3 = Color3.new(0,0,0); mini2.Position = UDim2.new(0, 44, -1, 57)
            mini2.Visible = false

            local flySpeed = 1; local flyActive = false; local tpwalking = false
            local bodyVelocity2, bodyGyro2, flyConn, upConn, downConn = nil, nil, nil, nil, nil

            local function startFly()
                local char = player.Character; if not char then return end
                local hum = char:FindFirstChild("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart")
                if not hum or not root then return end
                flyActive = true; hum.PlatformStand = true
                local anim = char:FindFirstChild("Animate"); if anim then anim.Disabled = true end
                for i = 1, flySpeed do
                    task.spawn(function()
                        tpwalking = true; local chr = player.Character; local h = chr and chr:FindFirstChild("Humanoid")
                        while tpwalking and chr and h and h.Parent do
                            RunService.Heartbeat:Wait()
                            if h.MoveDirection.Magnitude > 0 then chr:TranslateBy(h.MoveDirection) end
                        end
                    end)
                end
                local states = {
                    Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
                    Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
                    Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
                    Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
                    Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
                    Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
                    Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
                    Enum.HumanoidStateType.Swimming,
                }
                for _, s in ipairs(states) do hum:SetStateEnabled(s, false) end
                hum:ChangeState(Enum.HumanoidStateType.Swimming)
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                if torso then
                    bodyGyro2 = Instance.new("BodyGyro", torso)
                    bodyGyro2.P = 9e4; bodyGyro2.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro2.CFrame = torso.CFrame
                    bodyVelocity2 = Instance.new("BodyVelocity", torso)
                    bodyVelocity2.Velocity = Vector3.new(0, 0.1, 0); bodyVelocity2.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                end
                local ctrl = {f=0,b=0,l=0,r=0}; local lastctrl = {f=0,b=0,l=0,r=0}; local maxspeed = 50; local currentSpeed = 0
                flyConn = RunService.Heartbeat:Connect(function()
                    if not flyActive or not player.Character then return end
                    local t = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                    if not t or not bodyVelocity2 or not bodyGyro2 then return end
                    ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
                    ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
                    ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
                    ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
                    local mv, ms = ctrl.f + ctrl.b, ctrl.l + ctrl.r
                    if mv ~= 0 or ms ~= 0 then currentSpeed = math.min(currentSpeed + 0.5 + currentSpeed/maxspeed, maxspeed)
                    else currentSpeed = math.max(currentSpeed - 1, 0) end
                    local cam = workspace.CurrentCamera
                    if mv ~= 0 or ms ~= 0 then
                        bodyVelocity2.Velocity = (cam.CFrame.LookVector*mv + cam.CFrame.RightVector*ms) * currentSpeed
                        lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
                    elseif currentSpeed ~= 0 then
                        bodyVelocity2.Velocity = (cam.CFrame.LookVector*(lastctrl.f+lastctrl.b) + cam.CFrame.RightVector*(lastctrl.l+lastctrl.r)) * currentSpeed
                    else bodyVelocity2.Velocity = Vector3.new(0,0,0) end
                    bodyGyro2.CFrame = cam.CFrame * CFrame.Angles(-math.rad(mv*50*currentSpeed/maxspeed), 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bodyVelocity2.Velocity += Vector3.new(0, 30, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bodyVelocity2.Velocity -= Vector3.new(0, 30, 0) end
                end)
            end

            local function stopFly()
                flyActive = false; tpwalking = false
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                local char = player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.PlatformStand = false
                        local states = {
                            Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
                            Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
                            Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
                            Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
                            Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
                            Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
                            Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
                            Enum.HumanoidStateType.Swimming,
                        }
                        for _, s in ipairs(states) do hum:SetStateEnabled(s, true) end
                        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                    end
                    local anim2 = char:FindFirstChild("Animate"); if anim2 then anim2.Disabled = false end
                    if bodyVelocity2 then bodyVelocity2:Destroy(); bodyVelocity2 = nil end
                    if bodyGyro2 then bodyGyro2:Destroy(); bodyGyro2 = nil end
                end
            end

            onof.MouseButton1Click:Connect(function()
                if flyActive then stopFly(); onof.Text = "fly" else startFly(); onof.Text = "STOP" end
            end)
            up.MouseButton1Down:Connect(function()
                upConn = RunService.Heartbeat:Connect(function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then root.CFrame = root.CFrame * CFrame.new(0, 1.5, 0) end
                end)
            end)
            up.MouseButton1Up:Connect(function() if upConn then upConn:Disconnect(); upConn = nil end end)
            up.MouseLeave:Connect(function() if upConn then upConn:Disconnect(); upConn = nil end end)
            down.MouseButton1Down:Connect(function()
                downConn = RunService.Heartbeat:Connect(function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then root.CFrame = root.CFrame * CFrame.new(0, -1.5, 0) end
                end)
            end)
            down.MouseButton1Up:Connect(function() if downConn then downConn:Disconnect(); downConn = nil end end)
            down.MouseLeave:Connect(function() if downConn then downConn:Disconnect(); downConn = nil end end)
            plus.MouseButton1Click:Connect(function()
                flySpeed = flySpeed + 1; speedLbl.Text = tostring(flySpeed)
                if flyActive then stopFly(); task.wait(0.1); startFly() end
            end)
            mine.MouseButton1Click:Connect(function()
                if flySpeed > 1 then flySpeed = flySpeed - 1; speedLbl.Text = tostring(flySpeed)
                    if flyActive then stopFly(); task.wait(0.1); startFly() end end
            end)
            closebutton.MouseButton1Click:Connect(function() stopFly(); main:Destroy(); flyGui = nil end)
            mini.MouseButton1Click:Connect(function()
                for _, v in ipairs({up,down,onof,plus,speedLbl,mine,mini}) do v.Visible = false end
                mini2.Visible = true; Frame.BackgroundTransparency = 1; closebutton.Position = UDim2.new(0, 0, -1, 57)
            end)
            mini2.MouseButton1Click:Connect(function()
                for _, v in ipairs({up,down,onof,plus,speedLbl,mine,mini}) do v.Visible = true end
                mini2.Visible = false; Frame.BackgroundTransparency = 0; closebutton.Position = UDim2.new(0, 0, -1, 27)
            end)
            player.CharacterAdded:Connect(function()
                if flyActive then stopFly(); task.wait(0.5); startFly() end
            end)
        end)
    else
        if flyGui then flyGui:Destroy(); flyGui = nil end
    end
end)

addSectionTitle("Config.", movePage, 6)

addToggleRow("Speed Hack", "Activate speed", movePage, 7, function(on) sAct = on end)

addSliderRow("Speed", 16, 500, 16, movePage, 8, function(val) sVal = val end)

addSectionTitle("Dash Boost", movePage, 9)

addToggleRow("Dash Boost", "Dash further (PC + Mobile)", movePage, 10, function(on)
    DashBoostEnabled = on
    if on then
        local function doCFrameBoost()
            if DashBoostIsDashing then return end
            DashBoostIsDashing = true
            task.spawn(function()
                local startTime = tick()
                local dashDuration = 0.35
                while DashBoostIsDashing and (tick() - startTime) < dashDuration do
                    pcall(function()
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChild("Humanoid")
                        if hrp and hum then
                            local dir = hum.MoveDirection
                            if dir.Magnitude < 0.1 then
                                dir = hrp.CFrame.LookVector
                            end
                            local boost = dir.Unit * (DashBoostMultiplier * 1.5)
                            hrp.CFrame = hrp.CFrame + boost
                        end
                    end)
                    task.wait()
                end
                DashBoostIsDashing = false
            end)
        end

        local function hookCharDash(char)
            if DashBoostDescConn then DashBoostDescConn:Disconnect() end
            DashBoostDescConn = char.DescendantAdded:Connect(function(obj)
                if not DashBoostEnabled then return end
                pcall(function()
                    if obj:IsA("LinearVelocity") and not obj:GetAttribute("_db") then
                        obj:SetAttribute("_db", true)
                        local vel = obj.VectorVelocity
                        if vel and vel.Magnitude > 0 then
                            obj.VectorVelocity = vel * DashBoostMultiplier
                        end
                        pcall(function()
                            if obj.MaxForce and typeof(obj.MaxForce) == "number" then
                                obj.MaxForce = obj.MaxForce * DashBoostMultiplier
                            end
                        end)
                        doCFrameBoost()
                    elseif obj:IsA("BodyVelocity") and not obj:GetAttribute("_db") then
                        obj:SetAttribute("_db", true)
                        obj.Velocity = obj.Velocity * DashBoostMultiplier
                        obj.MaxForce = obj.MaxForce * DashBoostMultiplier
                        doCFrameBoost()
                    end
                end)
            end)
        end
        if LocalPlayer.Character then hookCharDash(LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.1); hookCharDash(c) end)

        DashBoostKeyConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if not DashBoostEnabled then return end
            if input.KeyCode == Enum.KeyCode.Q then
                doCFrameBoost()
            end
        end)
    else
        DashBoostIsDashing = false
        if DashBoostDescConn then DashBoostDescConn:Disconnect(); DashBoostDescConn = nil end
        if DashBoostKeyConn then DashBoostKeyConn:Disconnect(); DashBoostKeyConn = nil end
    end
end)

addSliderRow("Dash Multiplier", 1, 5, 2, movePage, 11, function(val)
    DashBoostMultiplier = val
end)

addSectionTitle("Super Jump", movePage, 12)

addToggleRow("Super Jump", "Jump higher (dual method)", movePage, 13, function(on)
    SuperJumpEnabled = on
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            if on then
                hum.UseJumpPower = true
                hum.JumpPower = SuperJumpPower
            else
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end
        end
    end)
end)

addSliderRow("Jump Power", 50, 500, 100, movePage, 14, function(val)
    SuperJumpPower = val
    if SuperJumpEnabled then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = val
            end
        end)
    end
end)

addToggleRow("CFrame Jump Boost", "Extra impulse when jumping (anti-reset)", movePage, 15, function(on)
    SuperJumpCFrameMode = on
end)

-- ============================================================
--  TELEPORT PAGE (~40 locations)
-- ============================================================
local function doTP(x, y, z)
    local char = LocalPlayer.Character
    if char then char:PivotTo(CFrame.new(x, y, z)) end
end

addSectionTitle("Teleports", tpPage, 1)
addTpButton("Cursed Ship", "923, 126, 32852", Color3.fromRGB(0, 220, 140), tpPage, 2, function() doTP(923, 126, 32852) end)
addTpButton("Castle", "-5085, 316, -3156", Color3.fromRGB(123, 136, 255), tpPage, 3, function() doTP(-5085, 316, -3156) end)
addTpButton("Mansion", "-12463, 375, -7523", Color3.fromRGB(255, 170, 68), tpPage, 4, function() doTP(-12463, 375, -7523) end)

-- ============================================================
--  BOUNTY HUNT PAGE (NEW)
-- ============================================================
addSectionTitle("Auto Bounty Hunt", bountyPage, 1)

addToggleRow("Auto Bounty Hunt", "Auto TP + Attack players level 2000+", bountyPage, 2, function(on)
    AutoBountyEnabled = on
    if on then
        StartAutoBounty()
        addNotification("Bounty Hunt", "Auto Bounty started - Target: Level " .. AutoBountyMinLevel .. "+", C.green)
    else
        StopAutoBounty()
        addNotification("Bounty Hunt", "Auto Bounty stopped", C.red)
    end
end)

addSliderRow("Min Player Level", 1000, 2500, 2000, bountyPage, 3, function(val)
    AutoBountyMinLevel = val
    if AutoBountyEnabled then
        addNotification("Bounty Hunt", "Min level changed to " .. val, C.accent)
    end
end)

addSectionTitle("Bounty Stats", bountyPage, 4)

local bountyStatusFrame = Instance.new("Frame", bountyPage)
bountyStatusFrame.Size = UDim2.new(1, 0, 0, 80)
bountyStatusFrame.BackgroundColor3 = C.item
bountyStatusFrame.LayoutOrder = 5
corner(8, bountyStatusFrame)
stroke(C.border, 1, bountyStatusFrame)
trackTheme(bountyStatusFrame, "BackgroundColor3", "item")

local currentTargetLabel = label({Text = "Current Target: None", Font = Enum.Font.GothamSemibold, TextSize = 12,
    TextColor3 = C.text, Size = UDim2.new(1, -16, 0, 20), Position = UDim2.new(0, 8, 0, 8)}, bountyStatusFrame)
trackTheme(currentTargetLabel, "TextColor3", "text")

local targetsCountLabel = label({Text = "Available Targets: 0", Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = C.sub, Size = UDim2.new(1, -16, 0, 16), Position = UDim2.new(0, 8, 0, 32)}, bountyStatusFrame)
trackTheme(targetsCountLabel, "TextColor3", "sub")

local bountyStatusDot = Instance.new("Frame", bountyStatusFrame)
bountyStatusDot.Size = UDim2.new(0, 8, 0, 8)
bountyStatusDot.Position = UDim2.new(1, -20, 0, 12)
bountyStatusDot.BackgroundColor3 = AutoBountyEnabled and C.green or C.red
corner(99, bountyStatusDot)

-- Update bounty status display
task.spawn(function()
    while true do
        task.wait(2)
        if bountyStatusFrame and bountyStatusFrame.Parent then
            local targets = GetBountyTargets()
            targetsCountLabel.Text = "Available Targets: " .. #targets
            if AutoBountyCurrentTarget then
                currentTargetLabel.Text = "Current Target: " .. (AutoBountyCurrentTarget.Name or "None")
            else
                currentTargetLabel.Text = "Current Target: None"
            end
            bountyStatusDot.BackgroundColor3 = AutoBountyEnabled and C.green or C.red
        end
    end
end)

addButtonRow("Refresh Target List", bountyPage, 6, function()
    AutoBountyTargets = GetBountyTargets()
    addNotification("Bounty Hunt", "Target list refreshed - " .. #AutoBountyTargets .. " targets found", C.accent)
end)

-- ============================================================
--  SETTINGS PAGE (Colors + Security + Config Save/Load)
-- ============================================================
addSectionTitle("Colors", settingsPage, 1)

local colorNames = {}
for _, p in ipairs(ColorPresets) do table.insert(colorNames, p.name) end

addDropdownRow("Primary Color", colorNames, settingsPage, 2, function(name)
    SavedPrimary = name
    ApplyColorChange()
    addNotification("Colors", "Primary: " .. name, getPresetColor(name))
end)

addDropdownRow("Secondary Color", colorNames, settingsPage, 3, function(name)
    SavedSecondary = name
    ApplyColorChange()
    addNotification("Colors", "Secondary: " .. name, getPresetColor(name))
end)

addSectionTitle("Config Management", settingsPage, 4)

addButtonRow("Save All Settings", settingsPage, 5, function()
    SaveAllConfig()
end)

addButtonRow("Load All Settings", settingsPage, 6, function()
    LoadAllConfig()
    -- Refresh UI states after loading
    if FastAttackEnabled then StartFastAttack() else StopFastAttack() end
    if ESPEnabled then UpdateESP() end
    if ESP_SkeletonEnabled then UpdateSkeletonESP() else ClearSkeletonESP() end
    if AutoBountyEnabled then StartAutoBounty() else StopAutoBounty() end
    if TeleportEnabled and SelectedPlayer then
        StartTweenFollow()
    end
    if InstaTeleportEnabled and SelectedPlayer then
        InstaTpConnection = RunService.Stepped:Connect(function()
            if SelectedPlayer then
                pcall(function()
                    local target = Players:FindFirstChild(SelectedPlayer)
                    if target and target.Character then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, YOffset, 0)
                    end
                end)
            end
        end)
    end
    if SpectateEnabled and SelectedPlayer then
        SpectateConnection = RunService.RenderStepped:Connect(function()
            if SelectedPlayer then
                local target = Players:FindFirstChild(SelectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
                end
            end
        end)
    end
    if AutoEscapeEnabled then
        AutoEscapeConn = RunService.Heartbeat:Connect(function(dt)
            if not AutoEscapeEnabled then return end
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                local hpPercent = (hum.Health / hum.MaxHealth) * 100
                if hpPercent <= AutoEscapeThreshold and hum.Health > 0 then
                    local escapePos = hrp.Position + Vector3.new(0, 450 * dt, 0)
                    hrp.CFrame = CFrame.new(escapePos)
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end)
    end
    addNotification("Config", "All settings loaded", C.accent)
end)

addSectionTitle("Reset", settingsPage, 7)

addButtonRow("Reset Colors (Default)", settingsPage, 8, function()
    SavedPrimary = DEFAULT_PRIMARY
    SavedSecondary = DEFAULT_SECONDARY
    ApplyColorChange()
    addNotification("Colors", "Colors restored to default", C.accent)
end)

addButtonRow("Reset All Settings", settingsPage, 9, function()
    -- Reset all state variables to default
    FastAttackEnabled = false
    StopFastAttack()
    AimlockEnabled = false
    u4 = false
    u19 = nil
    TeleportEnabled = false
    InstaTeleportEnabled = false
    SpectateEnabled = false
    OrbitEnabled = false
    AutoEscapeEnabled = false
    FruitAttackKitsune = false
    FruitAttackTRex = false
    AutoAwakening = false
    ESPEnabled = false
    ESPDrawingEnabled = false
    ESP_SkeletonEnabled = false
    FullBrightEnabled = false
    iJ = false
    ncl = false
    walkWaterEnabled = false
    sAct = false
    DashBoostEnabled = false
    SuperJumpEnabled = false
    AutoBountyEnabled = false
    
    ClearESP()
    ClearSkeletonESP()
    StopAutoBounty()
    if AutoEscapeConn then AutoEscapeConn:Disconnect() end
    if TeleportConnection then TeleportConnection:Disconnect() end
    if InstaTpConnection then InstaTpConnection:Disconnect() end
    if SpectateConnection then SpectateConnection:Disconnect() end
    if v4Connection then task.cancel(v4Connection) end
    if tweenNoClipConn then tweenNoClipConn:Disconnect() end
    
    addNotification("Config", "All settings reset to default", C.orange)
end)

addSectionTitle("Security", settingsPage, 10)

addButtonRow("Activate Anti-Kick", settingsPage, 11, function()
    pcall(function()
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
            local Method = getnamecallmethod()
            if (Method == "Kick" or Method == "kick") and Self == LocalPlayer then
                task.spawn(function()
                    if #Players:GetPlayers() <= 1 then
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end)
                return nil
            end
            return OldNamecall(Self, ...)
        end))
    end)
    addNotification("Security", "Anti-Kick activated + Auto Rejoin", C.green)
end)

addButtonRow("Activate Anti-AFK", settingsPage, 12, function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
    addNotification("Security", "Anti-AFK activated", C.green)
end)

-- ============================================================
--  RUNSERVICE LOOPS
-- ============================================================

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        if AimlockEnabled then
            if u4 then u4 = false; u19 = nil
            else u19 = FindNearestEnemy(); u4 = true end
        end
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

UserInputService.JumpRequest:Connect(function()
    if iJ then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if SuperJumpEnabled then
        task.wait(0.3)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = SuperJumpPower
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if ncl and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if sAct and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(hum.MoveDirection * (sVal / 55))
        end
    end
end)

do
    local jumpBoostActive = false
    UserInputService.JumpRequest:Connect(function()
        if not SuperJumpCFrameMode then return end
        if jumpBoostActive then return end
        jumpBoostActive = true
        task.spawn(function()
            local boostDuration = 0.4
            local startTime = tick()
            while (tick() - startTime) < boostDuration do
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local upForce = (SuperJumpPower / 50) * 2.5
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, upForce, 0)
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(hrp.Velocity.Y, 0), hrp.Velocity.Z)
                    end
                end)
                task.wait()
            end
            jumpBoostActive = false
        end)
    end)
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if walkWaterEnabled and hrp then
        if hrp.Position.Y >= 9.5 and hrp.Velocity.Y <= 0 then
            local waterPart = workspace:FindFirstChild("PANELBLOXWater")
            if not waterPart then
                waterPart = Instance.new("Part", workspace)
                waterPart.Name = "PANELBLOXWater"
                waterPart.Size = Vector3.new(20, 1, 20)
                waterPart.Transparency = 1; waterPart.Anchored = true
                waterPart.CanCollide = true; waterPart.CanQuery = false
            end
            waterPart.CFrame = CFrame.new(hrp.Position.X, 9.2, hrp.Position.Z)
        else
            if workspace:FindFirstChild("PANELBLOXWater") then workspace.PANELBLOXWater:Destroy() end
        end
    else
        if workspace:FindFirstChild("PANELBLOXWater") then workspace.PANELBLOXWater:Destroy() end
    end
end)

RunService.Heartbeat:Connect(function()
    if FullBrightEnabled then
        pcall(function()
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.ClockTime = 14; game.Lighting.FogEnd = 9e9
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local target = SelectedPlayer and Players:FindFirstChild(SelectedPlayer)

            if OrbitEnabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                rot = rot + 0.15
                root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, rot, 0) * CFrame.new(OrbitDistance, OrbitHeight, 0)
            end
        end)
    end
end)

-- ============================================================
--  WINDOW CONTROLS
-- ============================================================
local minimized = false
local miniSize = UDim2.new(0, 180, 0, TITLEBAR_H)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        sidebar.Visible = false; sidebarLine.Visible = false
        contentFrame.Visible = false; titleLine.Visible = false
        premiumBadge.Visible = false
        minBtn.Text = "+"
        tween(mainFrame, 0.2, {Size = miniSize})
    else
        local sz = guiSizes[currentGuiSize]
        minBtn.Text = "-"
        tween(mainFrame, 0.2, {Size = UDim2.new(0, sz.w, 0, sz.h)})
        task.delay(0.2, function()
            sidebar.Visible = true; sidebarLine.Visible = true
            contentFrame.Visible = true; titleLine.Visible = true
            premiumBadge.Visible = true
        end)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    ESPEnabled = false; ClearESP(); ESPDrawingEnabled = false
    ClearSkeletonESP()
    StopAutoBounty()
    if workspace:FindFirstChild("PANELBLOXWater") then workspace.PANELBLOXWater:Destroy() end
    tween(mainFrame, 0.15, {BackgroundTransparency = 1})
    task.wait(0.18); screenGui:Destroy()
end)

-- ============================================================
--  ANIMATED GRADIENT (banner glow cycles between primary & secondary)
-- ============================================================
task.spawn(function()
    local toggle = true
    while bannerGlow and bannerGlow.Parent do
        toggle = not toggle
        local targetColor = toggle and C.accent or C.accent2
        tween(bannerGlow, 1.5, {BackgroundColor3 = targetColor})
        task.wait(1.5)
    end
end)

-- ============================================================
--  INIT
-- ============================================================
showPage("Home")
LoadAllConfig()  -- Auto load saved config
addNotification("PANELBLOX Premium", "v3.0 loaded successfully (Skeleton ESP + Bounty Hunt + Save Config)", C.accent)
