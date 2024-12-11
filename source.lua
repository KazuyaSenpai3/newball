-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local recordedActions = {}
local isRecording = false
local recordStartTime = 0

-- Function to start recording
local function startRecording()
    isRecording = true
    recordStartTime = tick()
    recordedActions = {}
    print("Recording started...")
end

-- Function to stop recording
local function stopRecording()
    isRecording = false
    print("Recording stopped. Recorded actions:")
    for i, action in ipairs(recordedActions) do
        print(i, action.remote.Name, action.args)
    end
end

-- Function to replay recorded actions
local function replayActions()
    if #recordedActions == 0 then
        print("No actions recorded to replay.")
        return
    end

    print("Replaying actions...")
    for _, action in ipairs(recordedActions) do
        task.wait(action.time)
        if action.remote:IsA("RemoteEvent") then
            action.remote:FireServer(unpack(action.args))
        elseif action.remote:IsA("RemoteFunction") then
            action.remote:InvokeServer(unpack(action.args))
        end
        print("Replayed action:", action.remote.Name, action.args)
    end
    print("Finished replaying actions.")
end

-- Spy function to monitor remotes and record if enabled
local function spyOnRemote(remote)
    if remote:IsA("RemoteEvent") then
        local originalFireServer = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            if isRecording then
                local timeElapsed = tick() - recordStartTime
                table.insert(recordedActions, {
                    remote = self,
                    args = args,
                    time = timeElapsed,
                })
                print("Recorded action:", self.Name, args, "at", timeElapsed, "seconds")
            end
            return originalFireServer(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local originalInvokeServer = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local args = {...}
            if isRecording then
                local timeElapsed = tick() - recordStartTime
                table.insert(recordedActions, {
                    remote = self,
                    args = args,
                    time = timeElapsed,
                })
                print("Recorded action:", self.Name, args, "at", timeElapsed, "seconds")
            end
            return originalInvokeServer(self, ...)
        end
    end
end

-- Attach spy to remotes
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        spyOnRemote(remote)
    end
end

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

-- Create and connect the UI
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
