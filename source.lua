-- Load the Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create the main window
local Window = OrionLib:MakeWindow({
    Name = "AdvanceTech | Arsenal | v1.7",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AdvanceTechConfig"
})

-- Variables
local flySettings = { fly = false, flyspeed = 50 }
local hitboxEnabled = false
local noCollisionEnabled = false
local hitboxSize = 21
local hitboxTransparency = 6
local teamCheck = "FFA"
local triggerbotEnabled = false
local triggerbotDelay = 0.2
local triggerbotTeamCheck = "Team-Based"
local originalValues = {
    FireRate = {},
    ReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

local defaultBodyParts = {"UpperTorso", "Head", "HumanoidRootPart"}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
local function savedPart(player, part)
    if not originalValues[player] then
        originalValues[player] = {}
    end
    if not originalValues[player][part.Name] then
        originalValues[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoredPart(player)
    if originalValues[player] then
        for partName, properties in pairs(originalValues[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = properties.CanCollide
                part.Transparency = properties.Transparency
                part.Size = properties.Size
            end
        end
    end
end

local function extendHitbox(player)
    for _, partName in ipairs(defaultBodyParts) do
        local part = player.Character and player.Character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            savedPart(player, part)
            part.CanCollide = not noCollisionEnabled
            part.Transparency = hitboxTransparency / 10
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
end

local function updateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheck == "FFA" or player.Team ~= LocalPlayer.Team then
                extendHitbox(player)
            else
                restoredPart(player)
            end
        end
    end
end

-- Triggerbot Implementation
local function isEnemy(targetPlayer)
    if triggerbotTeamCheck == "FFA" then
        return true
    elseif triggerbotTeamCheck == "Everyone" then
        return targetPlayer ~= LocalPlayer
    elseif triggerbotTeamCheck == "Team-Based" then
        return targetPlayer.Team ~= LocalPlayer.Team
    end
    return false
end

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Welcome Section
MainTab:AddLabel("Welcome To AdvanceTech | " .. LocalPlayer.Name)

-- Hitbox Section
local HitboxSection = MainTab:AddSection({ Name = "Hitbox Settings" })

HitboxSection:AddButton({
    Name = "[CLICK THIS FIRST] Enable Hitbox",
    Callback = function()
        coroutine.wrap(function()
            while true do
                if hitboxEnabled then
                    updateHitboxes()
                end
                task.wait(0.1)
            end
        end)()
    end
})

HitboxSection:AddToggle({
    Name = "Enable Hitbox",
    Default = false,
    Callback = function(enabled)
        hitboxEnabled = enabled
        if not enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                restoredPart(player)
            end
        else
            updateHitboxes()
        end
    end
})

HitboxSection:AddSlider({
    Name = "Hitbox Size",
    Min = 1,
    Max = 25,
    Default = hitboxSize,
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

HitboxSection:AddSlider({
    Name = "Hitbox Transparency",
    Min = 1,
    Max = 10,
    Default = hitboxTransparency,
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

HitboxSection:AddDropdown({
    Name = "Team Check",
    Default = "FFA",
    Options = {"FFA", "Team-Based", "Everyone"},
    Callback = function(value)
        teamCheck = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

-- Triggerbot Section
local TriggerbotSection = MainTab:AddSection({ Name = "Triggerbot Settings" })

TriggerbotSection:AddToggle({
    Name = "Enable Triggerbot",
    Default = false,
    Callback = function(state)
        triggerbotEnabled = state
    end
})

TriggerbotSection:AddDropdown({
    Name = "Team Check Mode",
    Default = "Team-Based",
    Options = {"FFA", "Team-Based", "Everyone"},
    Callback = function(selected)
        triggerbotTeamCheck = selected
    end
})

TriggerbotSection:AddSlider({
    Name = "Shot Delay",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        triggerbotDelay = value / 10
    end
})

-- Gun Mods Tab
local GunModsTab = Window:MakeTab({
    Name = "Gun Mods",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GunModsSection = GunModsTab:AddSection({ Name = "Overpowered Gun Features" })

GunModsSection:AddToggle({
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(state)
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = state and "Infinite Ammo" or ""
    end
})

GunModsSection:AddToggle({
    Name = "Fast Reload",
    Default = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if v:FindFirstChild("ReloadTime") then
                originalValues.ReloadTime[v] = v.ReloadTime.Value
                v.ReloadTime.Value = state and 0.01 or originalValues.ReloadTime[v]
            end
        end
    end
})

-- Add other gun mod toggles here following the same pattern.

-- Player Tab
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerSection = PlayerTab:AddSection({ Name = "Player Features" })

PlayerSection:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        if state then
            startFly()
        else
            endFly()
        end
    end
})

-- Finish Initialization
OrionLib:Init()
