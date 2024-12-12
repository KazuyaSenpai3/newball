-- Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Auza Hub | Arsenal | v1.7",
    LoadingTitle = "Auza Hub",
    LoadingSubtitle = "Making Arsenal Easy",
    Theme = "Ocean", -- Using the Ocean theme for a beautiful aesthetic
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AuzaHubConfig",
        FileName = "ArsenalConfig"
    },
    KeySystem = true, -- Key system enabled
    KeySettings = {
        Title = "Auza Hub Key System",
        Subtitle = "Enter your key to unlock the hub",
        Note = "Visit our Discord server for the latest keys",
        FileName = "AuzaHubKey", -- Unique file for key storage
        SaveKey = true, -- Save the key locally for future use
        GrabKeyFromSite = false, -- Set to true if fetching keys from a website
        Key = {"YourKey123", "AnotherKey456"} -- Replace with your valid keys
    }
})

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local hitboxEnabled = false
local hitboxSize = 21
local hitboxTransparency = 6
local triggerbotEnabled = false
local triggerbotDelay = 0.2
local flyEnabled = false
local flySpeed = 50
local infiniteAmmoEnabled = false
local fastReloadEnabled = false
local weaponModules = ReplicatedStorage:FindFirstChild("Weapons") and ReplicatedStorage.Weapons:GetChildren()

-- Infinite Ammo Implementation
local function infiniteAmmo(state)
    for _, weapon in ipairs(weaponModules) do
        if weapon:FindFirstChild("Ammo") then
            -- Setting ammo to a high value so it never depletes
            weapon.Ammo.Value = state and math.huge or weapon.Ammo.Value
        end
    end
end

-- Fast Reload Implementation
local function fastReload(state)
    for _, weapon in ipairs(weaponModules) do
        if weapon:FindFirstChild("ReloadTime") then
            -- Modify ReloadTime for the weapon
            weapon.ReloadTime.Value = state and 0.1 or weapon.ReloadTime.Value -- Set to 0.1 for instant reload if enabled
        end
    end
end

-- Functions for Triggerbot
local function triggerbot()
    if triggerbotEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if (head.Position - Workspace.CurrentCamera.CFrame.Position).magnitude < 500 then
                    mouse1click()
                    wait(triggerbotDelay)
                end
            end
        end
    end
end

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483345998) -- Icon ID or Lucide Icon Name
MainTab:CreateLabel("Welcome to Auza Hub | " .. LocalPlayer.Name)

MainTab:CreateDivider() -- Add a divider for better layout

MainTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(state)
        hitboxEnabled = state
        if state then
            updateHitboxes()
            Rayfield:Notify({
                Title = "Hitbox Enabled",
                Content = "Hitboxes are now active with your set size and transparency.",
                Duration = 5
            })
        end
    end
})

MainTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 25},
    Increment = 1,
    CurrentValue = hitboxSize,
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

MainTab:CreateSlider({
    Name = "Hitbox Transparency",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = hitboxTransparency,
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483345998)
CombatTab:CreateToggle({
    Name = "Enable Triggerbot",
    CurrentValue = false,
    Callback = function(state)
        triggerbotEnabled = state
        if state then
            RunService:BindToRenderStep("Triggerbot", Enum.RenderPriority.Camera.Value + 1, triggerbot)
        else
            RunService:UnbindFromRenderStep("Triggerbot")
        end
    end
})

CombatTab:CreateSlider({
    Name = "Triggerbot Delay",
    Range = {0.1, 1.0},
    Increment = 0.1,
    CurrentValue = triggerbotDelay,
    Callback = function(value)
        triggerbotDelay = value
    end
})

-- Gun Mods Tab
local GunModsTab = Window:CreateTab("Gun Mods", 4483345998)

GunModsTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Callback = function(state)
        infiniteAmmo(state)
    end
})

GunModsTab:CreateToggle({
    Name = "Fast Reload",
    CurrentValue = false,
    Callback = function(state)
        fastReload(state)
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483345998)

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(state)
        toggleFly(state)
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 150},
    Increment = 10,
    CurrentValue = flySpeed,
    Callback = function(value)
        flySpeed = value
    end
})

-- Finish Initialization
Rayfield:LoadConfiguration()
