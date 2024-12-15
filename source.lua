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

-- Function to roll for the desired style
local function rollStyle(styleName)
    local player = game.Players.LocalPlayer
    local styleService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Spin

    while true do
        task.wait(0.3) -- Slight delay for performance
        if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Style") then
            if player.PlayerStats.Style.Value ~= styleName then
                styleService:FireServer()
            else
                Rayfield:Notify({
                    Title = "Style Achieved!",
                    Content = styleName .. " Style has been activated!",
                    Duration = 5,
                })
                break -- Stop the loop when the style is achieved
            end
        end
    end
end

-- Function to roll for the desired flow
local function rollFlow(flowName)
    local player = game.Players.LocalPlayer
    local flowService = game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.Spin

    while true do
        task.wait(0.3) -- Slight delay for performance
        if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            if player.PlayerStats.Flow.Value ~= flowName then
                flowService:FireServer()
            else
                Rayfield:Notify({
                    Title = "Flow Achieved!",
                    Content = flowName .. " Flow has been activated!",
                    Duration = 5,
                })
                break -- Stop the loop when the flow is achieved
            end
        end
    end
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

-- Initialize the Window
Rayfield:LoadConfiguration()
