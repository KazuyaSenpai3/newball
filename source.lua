-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Ensure the "Remotes" folder exists
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    warn("Remotes folder not found in ReplicatedStorage!")
    return
end

-- Validate individual remotes
local VoteRestart = Remotes:FindFirstChild("VoteRestart")
local SkipVote = Remotes:FindFirstChild("SkipVote")
local SetSpeedUp = Remotes:FindFirstChild("SetSpeedUp")
local SpawnTowerServer = Remotes:FindFirstChild("SpawnTowerServer")
local VoteDifficulty = Remotes:FindFirstChild("VoteDifficulty")

if not VoteRestart then warn("VoteRestart remote not found!") end
if not SkipVote then warn("SkipVote remote not found!") end
if not SetSpeedUp then warn("SetSpeedUp remote not found!") end
if not SpawnTowerServer then warn("SpawnTowerServer remote not found!") end
if not VoteDifficulty then warn("VoteDifficulty remote not found!") end

-- Variables
local isRecording = false
local recordedActions = {}
local macroName = ""  -- Macro file name input

-- UI Creation
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local RecordButton = Instance.new("TextButton")
    local ReplayButton = Instance.new("TextButton")
    local NameInput = Instance.new("TextBox")
    local NotificationLabel = Instance.new("TextLabel")

    -- Parent UI to PlayerGui
    ScreenGui.Name = "ActionRecorderUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- MainFrame Properties
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- RecordButton Properties
    RecordButton.Name = "RecordButton"
    RecordButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    RecordButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    RecordButton.Text = "Start Recording"
    RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    RecordButton.TextSize = 16
    RecordButton.Parent = MainFrame

    -- ReplayButton Properties
    ReplayButton.Name = "ReplayButton"
    ReplayButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    ReplayButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    ReplayButton.Text = "Replay Actions"
    ReplayButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    ReplayButton.TextSize = 16
    ReplayButton.Parent = MainFrame

    -- NameInput Properties (for naming the macro)
    NameInput.Name = "NameInput"
    NameInput.Size = UDim2.new(0.8, 0, 0.2, 0)
    NameInput.Position = UDim2.new(0.1, 0, 0.7, 0)
    NameInput.PlaceholderText = "Enter Macro Name"
    NameInput.TextSize = 16
    NameInput.Parent = MainFrame

    -- Notification Label Properties
    NotificationLabel.Name = "NotificationLabel"
    NotificationLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
    NotificationLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
    NotificationLabel.Text = ""
    NotificationLabel.TextSize = 14
    NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationLabel.BackgroundTransparency = 1
    NotificationLabel.Parent = MainFrame

    return RecordButton, ReplayButton, NameInput, NotificationLabel
end

-- Create UI
local RecordButton, ReplayButton, NameInput, NotificationLabel = createUI()

-- Recording System
local function startRecording()
    if NameInput.Text == "" then
        NotificationLabel.Text = "Please enter a macro name!"
        return
    end

    macroName = NameInput.Text
    isRecording = true
    recordedActions = {}
    print("Recording started for macro:", macroName)
    NotificationLabel.Text = "Recording started for: " .. macroName
end

local function stopRecording()
    isRecording = false
    print("Recording stopped!")
    print("Recorded actions:", recordedActions)
    NotificationLabel.Text = "Recording stopped! Macro saved as: " .. macroName
end

-- Action Tracking
local function trackAction(remote, ...)
    if isRecording then
        table.insert(recordedActions, { remote = remote, args = { ... } })
        print("Action recorded:", remote, ...)
        -- Show notification for recorded action
        NotificationLabel.Text = "Action recorded: " .. remote.Name
        wait(2)  -- Wait for 2 seconds before hiding the notification
        NotificationLabel.Text = ""
    end
end

-- Replay System
local function replayActions()
    print("Replaying actions...")
    for _, action in ipairs(recordedActions) do
        local remote = action.remote
        local args = action.args
        if remote and typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        end
        wait(1) -- Add a delay between actions to simulate real-time replay
    end
    print("Replay finished!")
end

-- Button Functionality
RecordButton.MouseButton1Click:Connect(function()
    if not isRecording then
        RecordButton.Text = "Stop Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        startRecording()
    else
        RecordButton.Text = "Start Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        stopRecording()
    end
end)

ReplayButton.MouseButton1Click:Connect(function()
    if not isRecording and #recordedActions > 0 then
        replayActions()
    else
        print("No actions to replay or currently recording!")
    end
end)

-- Remote Tracking Example (You can add more remotes as needed)
if VoteRestart then
    VoteRestart.OnClientEvent:Connect(function(...)
        trackAction(VoteRestart, ...)
    end)
end

if SkipVote then
    SkipVote.OnClientEvent:Connect(function(...)
        trackAction(SkipVote, ...)
    end)
end

-- Save recorded actions to a file (example, to a file on your server)
local function saveMacroData()
    if macroName ~= "" and #recordedActions > 0 then
        local file = Instance.new("ModuleScript")
        file.Name = macroName .. "_Macro"
        file.Source = "return " .. game:GetService("HttpService"):JSONEncode(recordedActions)
        file.Parent = ReplicatedStorage:WaitForChild("Macros")
        print("Macro saved as", macroName)
    end
end

-- Save macro data when recording stops
local function saveMacroOnStop()
    if macroName ~= "" then
        saveMacroData()
    end
end

-- Connect the saving mechanism to stop recording
RecordButton.MouseButton1Click:Connect(function()
    if isRecording then
        saveMacroOnStop()
    end
end)
