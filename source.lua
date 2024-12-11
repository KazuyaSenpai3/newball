-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Variables
local isRecording = false
local recordedActions = {}
local recordStartTime = 0

-- Functions to Control Recording
local function startRecording()
    isRecording = true
    recordStartTime = tick()
    recordedActions = {}
    print("Recording started!")
end

local function stopRecording()
    isRecording = false
    print("Recording stopped! Recorded actions:")
    for i, action in ipairs(recordedActions) do
        print(i, action.remote.Name, action.args)
    end
end

-- Function to Replay Actions
local function replayActions()
    if #recordedActions == 0 then
        print("No actions recorded to replay.")
        return
    end

    print("Replaying actions...")
    for _, action in ipairs(recordedActions) do
        task.wait(action.time)
        action.remote:FireServer(unpack(action.args))
        print("Replayed action:", action.remote.Name, action.args)
    end
    print("Finished replaying actions.")
end

-- Function to Hook into Remotes for Recording
local function spyOnRemote(remote, name)
    local originalFireServer = remote.FireServer
    remote.FireServer = function(self, ...)
        local args = {...}
        if isRecording then
            local timeElapsed = tick() - recordStartTime
            table.insert(recordedActions, {
                remote = self,
                name = name,
                args = args,
                time = timeElapsed,
            })
            print("Recorded action:", name, args, "at", timeElapsed, "seconds")
        end
        return originalFireServer(self, ...)
    end
end

-- Attach Spies to Remotes
spyOnRemote(Remotes.VoteRestart, "VoteRestart")
spyOnRemote(Remotes.SkipVote, "SkipVote")
spyOnRemote(Remotes.SetSpeedUp, "SetSpeedUp")
spyOnRemote(Remotes.SpawnTowerServer, "SpawnTowerServer")
spyOnRemote(Remotes.VoteDifficulty, "VoteDifficulty")

-- UI Creation
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local RecordButton = Instance.new("TextButton")
    local ReplayButton = Instance.new("TextButton")

    -- ScreenGui Properties
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

-- Create and Connect the UI
local RecordButton, ReplayButton = createUI()

-- Connect Record Button
RecordButton.MouseButton1Click:Connect(function()
    if isRecording then
        stopRecording()
        RecordButton.Text = "Start Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        startRecording()
        RecordButton.Text = "Stop Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Connect Replay Button
ReplayButton.MouseButton1Click:Connect(function()
    replayActions()
end)
