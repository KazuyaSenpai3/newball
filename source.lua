-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Fetch HWID for the current client
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local HWID = RbxAnalyticsService:GetClientId() -- Get unique HWID

-- API endpoint for key validation
local API_URL = "https://<your-replit-url>/keys/validate" -- Replace with your Flask server URL

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
        GrabKeyFromSite = true, -- Fetch the key validation status from Flask server
        Key = {} -- Empty because validation is handled via Flask
    }
})

-- Function to validate keys with HWID
local function validateKey(key)
    local payload = {
        key = key,
        hwid = HWID
    }
    local success, response = pcall(function()
        return HttpService:PostAsync(API_URL, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)
    if success then
        local result = HttpService:JSONDecode(response)
        if result.status == "success" then
            return true, result.message -- Key is valid
        else
            return false, result.message -- Invalid key
        end
    else
        return false, "Failed to connect to the validation server."
    end
end

-- Prompt user for key
Rayfield:Prompt({
    Title = "Key Validation",
    Content = "Please enter your key to continue.",
    InputPlaceholder = "Enter your key here...",
    Callback = function(inputKey)
        local isValid, message = validateKey(inputKey)
        if isValid then
            Rayfield:Notify({
                Title = "Validation Successful",
                Content = message,
                Duration = 5,
                Type = "Success"
            })
        else
            Rayfield:Notify({
                Title = "Validation Failed",
                Content = message,
                Duration = 5,
                Type = "Error"
            })
            Rayfield:Destroy()
        end
    end
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

-- Miscellaneous Tab
local MiscTab = Window:CreateTab("Miscellaneous", 4483362458)

MiscTab:CreateButton({
    Name = "Flow Infinite",
    Callback = function()
        equipFlow("Wild Card")  -- Change to the desired flow name
    end
})

-- Initialize the Window
Rayfield:LoadConfiguration()
