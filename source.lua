-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- UI Creation
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local RecordButton = Instance.new("TextButton")
    local ReplayButton = Instance.new("TextButton")

    -- Parent UI to PlayerGui
    ScreenGui.Name = "ActionRecorderUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- MainFrame Properties
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 100)
    MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- RecordButton Properties
    RecordButton.Name = "RecordButton"
    RecordButton.Size = UDim2.new(0.8, 0, 0.4, 0)
    RecordButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    RecordButton.Text = "Start Recording"
    RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    RecordButton.TextSize = 16
    RecordButton.Parent = MainFrame

    -- ReplayButton Properties
    ReplayButton.Name = "ReplayButton"
    ReplayButton.Size = UDim2.new(0.8, 0, 0.4, 0)
    ReplayButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    ReplayButton.Text = "Replay Actions"
    ReplayButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    ReplayButton.TextSize = 16
    ReplayButton.Parent = MainFrame

    return RecordButton, ReplayButton
end

-- Create UI
local RecordButton, ReplayButton = createUI()

-- Recording System
local function startRecording()
    isRecording = true
    recordedActions = {}
    print("Recording started!")
end

local function stopRecording()
    isRecording = false
    print("Recording stopped!")
    print("Recorded actions:", recordedActions)
end

-- Action Tracking
local function trackAction(remote, ...)
    if isRecording then
        table.insert(recordedActions, { remote = remote, args = { ... } })
        print("Action recorded:", remote, ...)
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
