-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Ego's Hub",
    LoadingTitle = "Be The Best Striker!",
    LoadingSubtitle = "Powered by Rayfield",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = true, -- Enable Rayfield key system
    KeySettings = {
        Title = "Ego's Hub Key System",
        Subtitle = "Enter your key to access the hub",
        Note = "Visit our Discord server to obtain a valid key.",
        FileName = "EgoHubKey", -- Unique file name for key storage
        SaveKey = true, -- Save the key locally for future use
        GrabKeyFromSite = false, -- Set to true if using an online key system
        Key = {"FreeToday", "Tanginamo123"} -- Replace with your valid keys
    }
})

-- Function to roll for the desired flow without needing money
local function rollFlow(flowName)
    local player = game.Players.LocalPlayer
    local flowService = game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.Spin
    local moneyService = game:GetService("ReplicatedStorage").Packages.Knit.Services.LevelService.RE.Money

    -- Get current money value
    local playerMoney = player.PlayerStats:FindFirstChild("Money")
    local originalMoney = playerMoney and playerMoney.Value or 0

    -- Set money to a large value temporarily to allow the spin
    local tempMoney = 1000000 -- You can set this to any large value

    -- Set player's money temporarily
    if playerMoney then
        playerMoney.Value = tempMoney
    end

    -- Wait for a small delay before proceeding with the spin
    task.wait(0.3)

    -- Trigger the flow spin
    flowService:FireServer()  -- Perform the spin even without money

    Rayfield:Notify({
        Title = "Spinning for Flow",
        Content = "Attempting to roll for " .. flowName,
        Duration = 5,
    })

    -- Restore the original money value after the spin
    task.wait(0.5)
    if playerMoney then
        playerMoney.Value = originalMoney
    end
end

-- Function to equip the aura/flow even without owning it
local function equipFlow(flowName)
    local player = game.Players.LocalPlayer
    local auraService = game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.AuraEquip

    -- Attempt to equip the Aura/Flow, even if the player doesn't have it
    pcall(function()
        auraService:FireServer(flowName)  -- Equip the flow aura
        Rayfield:Notify({
            Title = "Flow Infinite",
            Content = flowName .. " aura/flow has been equipped!",
            Duration = 5,
        })
    end)
end

-- Styles Tab
local StylesTab = Window:CreateTab("Styles", 4483362458)

StylesTab:CreateButton({
    Name = "King",
    Callback = function()
        rollStyle("King")
    end
})

StylesTab:CreateButton({
    Name = "Chigiri",
    Callback = function()
        rollStyle("Chigiri")
    end
})

StylesTab:CreateButton({
    Name = "Bachira",
    Callback = function()
        rollStyle("Bachira")
    end
})

StylesTab:CreateButton({
    Name = "Shidou",
    Callback = function()
        rollStyle("Shidou")
    end
})

StylesTab:CreateButton({
    Name = "Nagi",
    Callback = function()
        rollStyle("Nagi")
    end
})

StylesTab:CreateButton({
    Name = "Isagi",
    Callback = function()
        rollStyle("Isagi")
    end
})

StylesTab:CreateButton({
    Name = "Gagamaru",
    Callback = function()
        rollStyle("Gagamaru")
    end
})

StylesTab:CreateButton({
    Name = "Sae",
    Callback = function()
        rollStyle("Sae")
    end
})

StylesTab:CreateButton({
    Name = "Rin",
    Callback = function()
        rollStyle("Rin")
    end
})

-- Flow Styles Tab
local FlowTab = Window:CreateTab("Flow Styles", 4483362458)

FlowTab:CreateButton({
    Name = "Wild Card",
    Callback = function()
        rollFlow("Wild Card")
    end
})

FlowTab:CreateButton({
    Name = "Demon Wings",
    Callback = function()
        rollFlow("Demon Wings")
    end
})

FlowTab:CreateButton({
    Name = "Awakened Genius",
    Callback = function()
        rollFlow("Awakened Genius")
    end
})

-- Miscellaneous Tab (Renamed from Equip Aura and contains one button for Flow Infinite)
local MiscTab = Window:CreateTab("Miscellaneous", 4483362458)

MiscTab:CreateButton({
    Name = "Flow Infinite",
    Callback = function()
        equipFlow("Wild Card")  -- Change to the desired flow name
    end
})

-- Initialize the Window
Rayfield:LoadConfiguration()
