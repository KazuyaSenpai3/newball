-- Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "AdvanceTech | Arsenal | v1.7",
    LoadingTitle = "AdvanceTech Hub",
    LoadingSubtitle = "Powered by Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AdvanceTechConfig",
        FileName = "ArsenalConfig"
    },
    KeySystem = false -- Set to true if you want a key system
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
local weaponModules = ReplicatedStorage:FindFirstChild("Weapons") and ReplicatedStorage.Weapons:GetChildren()

-- Functions
local function updateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, partName in ipairs({"UpperTorso", "Head", "HumanoidRootPart"}) do
                local part = player.Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    part.Transparency = hitboxTransparency / 10
                    part.CanCollide = false
                end
            end
        end
    end
end

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

local function infiniteAmmo(state)
    for _, weapon in ipairs(weaponModules) do
        if weapon:FindFirstChild("Ammo") then
            weapon.Ammo.Value = state and math.huge or weapon.Ammo.Value
        end
    end
end

local function toggleFly(state)
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

        RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Input.Value, function()
            bodyVelocity.Velocity = LocalPlayer.Character.Humanoid.MoveDirection * flySpeed
        end)
    else
        RunService:UnbindFromRenderStep("FlyMovement")
        if LocalPlayer.Character:FindFirstChild("BodyVelocity") then
            LocalPlayer.Character.BodyVelocity:Destroy()
        end
    end
end

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483345998) -- Icon ID or Lucide Icon Name
MainTab:CreateLabel("Welcome To AdvanceTech | " .. LocalPlayer.Name)

MainTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(state)
        hitboxEnabled = state
        if state then
            updateHitboxes()
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
        for _, weapon in ipairs(weaponModules) do
            if weapon:FindFirstChild("ReloadTime") then
                weapon.ReloadTime.Value = state and 0.1 or 1.0
            end
        end
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
