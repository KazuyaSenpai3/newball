-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Ego's Hub",
    Icon = 0, -- No icon in top bar
    LoadingTitle = "Ego's Hub Loading",
    LoadingSubtitle = "Powering your game!",
    Theme = "Default", -- Can be changed to other themes like "DarkBlue", "Ocean", etc.
    DisableRayfieldPrompts = false, -- Keep Rayfield prompts enabled
    DisableBuildWarnings = false, -- Disable version mismatch warnings

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EgoHubConfigs", -- Custom folder for config saving
        FileName = "CombatQuestHub"
    },

    Discord = {
        Enabled = false, -- Discord integration disabled
        Invite = "", -- No Discord invite provided
        RememberJoins = false -- Doesn't prompt for rejoining Discord
    },

    KeySystem = false -- Key system is not enabled for this example
})

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Define Combat Remote
local CombatRemote = ReplicatedStorage.Remotes.Server.Combat.M1

-- Define Quest Claim Remote
local ClaimQuestRemote = ReplicatedStorage.Remotes.Server.Data.DeleteSlot.ClaimQuest

-- Quest Data
local questData = {
    ["type"] = "Kill",
    ["set"] = "Yuki Fortress Set",
    ["rewards"] = {
        ["essence"] = 12,
        ["chestMeter"] = 55,
        ["exp"] = 1258186,
        ["cash"] = 10728
    },
    ["rewardsText"] = "$10728 | 1318100 EXP | 12 Mission Essence",
    ["difficulty"] = 3,
    ["title"] = "Defeat",
    ["level"] = 316,
    ["grade"] = "Special Grade",
    ["subtitle"] = "a Curse User"
}

-- Variables for Toggles
local AutoM1Enabled = false
local AutoClaimEnabled = false

-- Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458) -- Combat tab
local QuestTab = Window:CreateTab("Quests", 4483362458) -- Quest tab

-- Rapid M1 Toggle
CombatTab:CreateToggle({
    Name = "Enable Rapid M1",
    CurrentValue = false,
    Flag = "AutoM1Toggle", -- Identifier for the toggle
    Callback = function(value)
        AutoM1Enabled = value
        if value then
            Rayfield:Notify({
                Title = "Rapid M1 Enabled",
                Content = "Rapid M1 has been activated.",
                Duration = 5,
                Type = "Success"
            })
        else
            Rayfield:Notify({
                Title = "Rapid M1 Disabled",
                Content = "Rapid M1 has been deactivated.",
                Duration = 5,
                Type = "Info"
            })
        end
    end
})

-- Auto Claim Quest Toggle
QuestTab:CreateToggle({
    Name = "Enable Auto Quest Claim",
    CurrentValue = false,
    Flag = "AutoClaimToggle", -- Identifier for the toggle
    Callback = function(value)
        AutoClaimEnabled = value
        if value then
            Rayfield:Notify({
                Title = "Auto Quest Claim Enabled",
                Content = "Auto quest claiming has been activated.",
                Duration = 5,
                Type = "Success"
            })
        else
            Rayfield:Notify({
                Title = "Auto Quest Claim Disabled",
                Content = "Auto quest claiming has been deactivated.",
                Duration = 5,
                Type = "Info"
            })
        end
    end
})

-- Functionality Loops
task.spawn(function()
    while true do
        task.wait(0.01) -- Rapid M1 delay
        if AutoM1Enabled then
            local success, response = pcall(function()
                CombatRemote:FireServer(1, {})
            end)
            if not success then
                warn("Error in Rapid M1:", response)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5) -- Delay for auto quest claiming
        if AutoClaimEnabled then
            local success, response = pcall(function()
                return ClaimQuestRemote:InvokeServer(questData)
            end)

            if success then
                Rayfield:Notify({
                    Title = "Quest Claimed",
                    Content = "Successfully claimed the quest!",
                    Duration = 5,
                    Type = "Success"
                })
            else
                warn("Error in Auto Quest Claim:", response)
                Rayfield:Notify({
                    Title = "Quest Claim Error",
                    Content = "Failed to claim the quest.",
                    Duration = 5,
                    Type = "Error"
                })
            end
        end
    end
end)

-- Finalize Rayfield UI
Rayfield:LoadConfiguration()
