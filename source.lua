-- Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the main window
local Window = Rayfield:CreateWindow({
    Name = "Auza Hub | Arsenal | v1.7",
    LoadingTitle = "Auza Hub",
    LoadingSubtitle = "Making Arsenal Easy",
    Theme = "Ocean",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AuzaHubConfig",
        FileName = "ArsenalConfig"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Auza Hub Key System",
        Subtitle = "Enter your key to unlock the hub",
        Note = "Visit our Discord server for the latest keys",
        FileName = "AuzaHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"YourKey123", "AnotherKey456"}
    }
})

-- Variables and Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Core variables
local hitboxEnabled = false
local hitboxSize = 21
local hitboxTransparency = 6
local triggerbotEnabled = false
local triggerbotDelay = 0.2
local flyEnabled = false
local flySpeed = 50
local espEnabled = false
local espColor = Color3.new(1, 0, 0) -- Default ESP color (red)
local espInstances = {}

-- Functions

-- Utility: Get Closest Player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- ESP: Add or Remove ESP for Players
local function toggleESP(state)
    espEnabled = state

    -- Remove all ESP instances
    for _, esp in pairs(espInstances) do
        if esp then esp:Destroy() end
    end
    espInstances = {}

    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local billboard = Instance.new("BillboardGui", player.Character.HumanoidRootPart)
                billboard.Size = UDim2.new(1, 0, 1, 0)
                billboard.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel", billboard)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.TextColor3 = espColor
                textLabel.TextScaled = true
                textLabel.BackgroundTransparency = 1
                textLabel.Text = player.Name

                table.insert(espInstances, billboard)
            end
        end
    end
end

-- Hitbox Handling
local function updateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, partName in ipairs({"Head", "HumanoidRootPart"}) do
                local part = player.Character:FindFirstChild(partName)
                if part then
                    part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    part.Transparency = hitboxTransparency / 10
                    part.CanCollide = false
                end
            end
        end
    end
end

-- Fly Handling
local function toggleFly(state)
    flyEnabled = state
    if flyEnabled then
        RunService.Stepped:Connect(function(_, delta)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * flySpeed * delta
            end
        end)
    end
end

-- Triggerbot
local function triggerbot()
    if triggerbotEnabled then
        local targetPlayer = getClosestPlayer()
        if targetPlayer then
            local head = targetPlayer.Character:FindFirstChild("Head")
            if head then
                mouse1click()
                wait(triggerbotDelay)
            end
        end
    end
end

-- UI Integration
local MainTab = Window:CreateTab("Main", 4483345998)
MainTab:CreateLabel("Welcome to Auza Hub | " .. LocalPlayer.Name)

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

local VisualTab = Window:CreateTab("Visuals", 4483345998)
VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(state)
        toggleESP(state)
    end
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    CurrentColor = espColor,
    Callback = function(color)
        espColor = color
        if espEnabled then toggleESP(true) end
    end
})

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

-- Finish Configuration Loading
Rayfield:LoadConfiguration()
