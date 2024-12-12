-- Load the Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Key System
local key = "AuzaHubKey123" -- Replace this with your desired key
local keyEntered = false

local function checkKey(input)
    return input == key
end

local function initKeySystem()
    -- Create Key System Window
    local keyWindow = OrionLib:MakeWindow({
        Name = "Auza Hub Key System",
        HidePremium = false
    })

    local userKey = ""
    keyWindow:MakeTab({
        Name = "Key System",
        Icon = "rbxassetid://4483345998"
    }):AddTextbox({
        Name = "Enter Key",
        Default = "",
        TextDisappear = true,
        Callback = function(value)
            userKey = value
        end
    }):AddButton({
        Name = "Check Key",
        Callback = function()
            if checkKey(userKey) then
                keyWindow:Destroy() -- Close the Key System window
                OrionLib:MakeNotification({
                    Name = "Access Granted",
                    Content = "Welcome to Auza Hub!",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                loadHub() -- Open the main hub after key validation
            else
                OrionLib:MakeNotification({
                    Name = "Access Denied",
                    Content = "Invalid key. Try again.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    })
end

-- Anti-Kick Implementation
local function preventKick()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then
            return nil
        end
        return old(self, ...)
    end)
end

-- ESP Implementation
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0) -- Default ESP color is red

local function toggleESP(enabled)
    espEnabled = enabled
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        if enabled then
                            local adornment = Instance.new("BoxHandleAdornment")
                            adornment.Adornee = part
                            adornment.Size = part.Size
                            adornment.Color3 = espColor
                            adornment.Transparency = 0.5
                            adornment.AlwaysOnTop = true
                            adornment.ZIndex = 5
                            adornment.Parent = part
                        else
                            for _, adornment in ipairs(part:GetChildren()) do
                                if adornment:IsA("BoxHandleAdornment") then
                                    adornment:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Main Hub Functionality
local function loadHub()
    -- Create the main window
    local Window = OrionLib:MakeWindow({
        Name = "Auza Hub | Arsenal | v1.7",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "AuzaHubConfig"
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

    -- Main Tab
    local MainTab = Window:MakeTab({
        Name = "Main",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    -- Welcome Section
    MainTab:AddLabel("Welcome To Auza Hub | " .. LocalPlayer.Name)

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

    -- ESP Section
    local ESPSection = MainTab:AddSection({ Name = "ESP Features" })

    ESPSection:AddToggle({
        Name = "Enable ESP",
        Default = false,
        Callback = function(state)
            toggleESP(state)
        end
    })

    ESPSection:AddColorpicker({
        Name = "ESP Color",
        Default = espColor,
        Callback = function(color)
            espColor = color
            if espEnabled then
                toggleESP(false)
                toggleESP(true)
            end
        end
    })

    -- Anti-Kick Section
    MainTab:AddSection({ Name = "Anti-Kick" })
        :AddButton({
            Name = "Enable Anti-Kick",
            Callback = preventKick
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
end

-- Run the Key System
initKeySystem()
