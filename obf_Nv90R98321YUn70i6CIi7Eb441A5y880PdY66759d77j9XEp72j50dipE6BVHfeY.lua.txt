-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Define Services and Remote Paths
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CombatRemote = ReplicatedStorage.Remotes.Server.Combat.M1
local ClaimQuestRemote = ReplicatedStorage.Remotes.Server.Data.DeleteSlot.ClaimQuest

-- Quest Data Structure (example)
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

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Rapid M1 & Quest Claim UI",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Initializing...",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Create Tab for M1 Attacks
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Add Toggle for Auto M1
CombatTab:CreateToggle({
    Name = "Enable Rapid M1",
    CurrentValue = false,
    Flag = "AutoM1Toggle",
    Callback = function(value)
        AutoM1Enabled = value
        if value then
            print("Rapid M1 Enabled")
        else
            print("Rapid M1 Disabled")
        end
    end
})

-- Create Tab for Quest Claiming
local QuestTab = Window:CreateTab("Quest Auto Claim", 4483362458)

-- Add Toggle for Auto Claim
QuestTab:CreateToggle({
    Name = "Enable Auto Claim",
    CurrentValue = false,
    Flag = "AutoClaimToggle",
    Callback = function(value)
        AutoClaimEnabled = value
        if value then
            print("Auto Claim Enabled")
        else
            print("Auto Claim Disabled")
        end
    end
})

-- Auto Rapid M1 Functionality
task.spawn(function()
    while true do
        task.wait(0.01) -- Rapid M1 delay
        if AutoM1Enabled then
            local success, response = pcall(function()
                CombatRemote:FireServer(1, {})
            end)
            if not success then
                warn("Failed to execute M1:", response)
            end
        end
    end
end)

-- Auto Claim Quest Functionality
task.spawn(function()
    while true do
        task.wait(5) -- Wait for 5 seconds before the next claim
        if AutoClaimEnabled then
            local success, response = pcall(function()
                return ClaimQuestRemote:InvokeServer(questData)
            end)

            if success then
                print("Quest claimed successfully:", response)
                Rayfield:Notify({
                    Title = "Quest Claimed",
                    Content = "Quest claimed successfully!",
                    Duration = 5,
                    Type = "Success"
                })
            else
                warn("Failed to claim quest:", response)
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Failed to claim quest.",
                    Duration = 5,
                    Type = "Error"
                })
            end
        end
    end
end)
