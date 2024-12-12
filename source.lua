-- Load Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Initialize Window
local Window = OrionLib:MakeWindow({
    Name = "ZO Exploit | Tiger Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "TigerHubConfigs"
})

-- Tabs for Different Features
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

-- Feature 1: Autoparry System
MainTab:AddToggle({
    Name = "Autoparry",
    Default = false,
    Callback = function(enabled)
        getgenv().AutoParryEnabled = enabled
        if enabled then
            print("Autoparry Enabled")
            -- Insert autoparry logic here
        else
            print("Autoparry Disabled")
        end
    end
})

-- Feature 2: ESP
VisualsTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(enabled)
        getgenv().ESPEnabled = enabled
        if enabled then
            print("ESP Enabled")
            -- Insert ESP logic here
        else
            print("ESP Disabled")
        end
    end
})

-- Feature 3: Chams
VisualsTab:AddToggle({
    Name = "Chams",
    Default = false,
    Callback = function(enabled)
        getgenv().ChamsEnabled = enabled
        if enabled then
            print("Chams Enabled")
            -- Insert chams logic here
        else
            print("Chams Disabled")
        end
    end
})

-- Feature 4: Weapon-Specific Timing
MainTab:AddTextbox({
    Name = "Set Weapon Timing",
    Default = "Katana",
    TextDisappear = true,
    Callback = function(value)
        print("Set timing for weapon:", value)
        -- Insert weapon-specific timing logic here
    end
})

-- Feature 5: Anti-Kick
SettingsTab:AddToggle({
    Name = "Anti-Kick",
    Default = false,
    Callback = function(enabled)
        getgenv().AntiKickEnabled = enabled
        if enabled then
            print("Anti-Kick Enabled")
            -- Insert anti-kick logic here
        else
            print("Anti-Kick Disabled")
        end
    end
})

-- Feature 6: Speed Control
SettingsTab:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        print("Walkspeed set to", value)
    end
})

-- Feature 7: Jump Control
SettingsTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 150,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        print("Jump Power set to", value)
    end
})

-- Initialize Orion Library
OrionLib:Init()
