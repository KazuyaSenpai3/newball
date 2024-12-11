local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Action Recorder Variables
local recording = false
local recordedActions = {}

-- Recording UI (basic for demonstration)
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local RecordButton = Instance.new("TextButton")
    local PlayButton = Instance.new("TextButton")

    ScreenGui.Name = "ActionRecorderUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 100)
    MainFrame.Position = UDim2.new(0.5, -100, 0.8, -50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainFrame.Parent = ScreenGui

    RecordButton.Name = "RecordButton"
    RecordButton.Size = UDim2.new(0, 180, 0, 40)
    RecordButton.Position = UDim2.new(0, 10, 0, 10)
    RecordButton.Text = "Start Recording"
    RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    RecordButton.Parent = MainFrame

    PlayButton.Name = "PlayButton"
    PlayButton.Size = UDim2.new(0, 180, 0, 40)
    PlayButton.Position = UDim2.new(0, 10, 0, 50)
    PlayButton.Text = "Play Actions"
    PlayButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    PlayButton.Parent = MainFrame

    return RecordButton, PlayButton
end

-- Function to start recording actions
local function startRecording()
    recording = true
    recordedActions = {} -- Reset previous actions
    print("Recording started...")
end

-- Function to stop recording actions
local function stopRecording()
    recording = false
    print("Recording stopped. Recorded actions:", recordedActions)
end

-- Function to play back recorded actions
local function playRecordedActions()
    if #recordedActions == 0 then
        print("No actions recorded to play.")
        return
    end

    print("Playing recorded actions...")
    for _, action in ipairs(recordedActions) do
        task.wait(action.delay) -- Wait for the delay between actions
        local remote = action.remote
        local args = action.args

        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        elseif remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(args))
        end

        print("Replayed action:", remote.Name, args)
    end
    print("Finished playing actions.")
end

-- Spy function to monitor and record remotes
local function spyOnRemote(remote)
    if remote:IsA("RemoteEvent") then
        local originalFireServer = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            if recording then
                table.insert(recordedActions, {
                    remote = self,
                    args = args,
                    delay = tick() - (recordedActions[#recordedActions] and recordedActions[#recordedActions].time or tick()),
                    time = tick()
                })
            end
            print("Spied RemoteEvent:", self.Name, args)
            return originalFireServer(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local originalInvokeServer = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local args = {...}
            if recording then
                table.insert(recordedActions, {
                    remote = self,
                    args = args,
                    delay = tick() - (recordedActions[#recordedActions] and recordedActions[#recordedActions].time or tick()),
                    time = tick()
                })
            end
            print("Spied RemoteFunction:", self.Name, args)
            return originalInvokeServer(self, ...)
        end
    end
end

-- Attach the spy to all remotes in ReplicatedStorage
for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        spyOnRemote(remote)
    end
end

-- UI Creation and Button Logic
local RecordButton, PlayButton = createUI()

RecordButton.MouseButton1Click:Connect(function()
    if recording then
        stopRecording()
        RecordButton.Text = "Start Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        startRecording()
        RecordButton.Text = "Stop Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

PlayButton.MouseButton1Click:Connect(function()
    playRecordedActions()
end)
