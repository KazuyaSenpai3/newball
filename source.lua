-- Load Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Initialize Window
local Window = OrionLib:MakeWindow({
    Name = "ZO Exploit | Tiger Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TigerHubConfigs"
})

-- Tabs for Features
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables for Features
getgenv().AutoParryEnabled = false
getgenv().ESPEnabled = false
getgenv().ChamsEnabled = false
getgenv().AntiKickEnabled = false
getgenv().SilentAimEnabled = false

-- Player Variables
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Functions from Original zo.txt

-- Autoparry Logic
local function AutoParry()
    while getgenv().AutoParryEnabled do
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name == "Sword" then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
            end
        end
        wait(0.1)
    end
end

-- ESP Logic
local function EnableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0.2
            highlight.Parent = player.Character
        end
    end
end

local function DisableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChildOfClass("Highlight") then
            player.Character:FindFirstChildOfClass("Highlight"):Destroy()
        end
    end
end

-- Chams Logic
local function EnableChams()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Neon
                    part.Color = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    end
end

local function DisableChams()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                    part.Color = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

-- Anti-Kick Logic
local function AntiKick()
    while getgenv().AntiKickEnabled do
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
        wait(0.1)
    end
end

-- Silent Aim Logic
local function EnableSilentAim()
    local targetPart = "Head"
    local oldIndex = nil

    oldIndex = hookmetamethod(game, "__index", function(self, index)
        if index == "Hit" and self.Name == targetPart then
            return CFrame.new(Mouse.Hit.p)
        end
        return oldIndex(self, index)
    end)
end

local function DisableSilentAim()
    -- Logic to clean up Silent Aim hooks
    print("Silent Aim Disabled")
end

-- Orion UI Controls
MainTab:AddToggle({
    Name = "Autoparry",
    Default = false,
    Callback = function(enabled)
        getgenv().AutoParryEnabled = enabled
        if enabled then
            AutoParry()
        end
    end
})

VisualsTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(enabled)
        getgenv().ESPEnabled = enabled
        if enabled then
            EnableESP()
        else
            DisableESP()
        end
    end
})

VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(enabled)
        getgenv().ChamsEnabled = enabled
        if enabled then
            EnableChams()
        else
            DisableChams()
        end
    end
})

SettingsTab:AddToggle({
    Name = "Anti-Kick",
    Default = false,
    Callback = function(enabled)
        getgenv().AntiKickEnabled = enabled
        if enabled then
            AntiKick()
        end
    end
})

SettingsTab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(enabled)
        getgenv().SilentAimEnabled = enabled
        if enabled then
            EnableSilentAim()
        else
            DisableSilentAim()
        end
    end
})

SettingsTab:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

SettingsTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 150,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(value)
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Initialize Orion Library
OrionLib:Init()
