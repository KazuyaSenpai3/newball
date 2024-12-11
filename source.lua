-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remotes
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local SpawnTowerRemote = Remotes:FindFirstChild("SpawnTowerServer")
local UpgradeTowerRemote = Remotes:FindFirstChild("UpgradeTowerServer")

-- Variables
local isRecording = false
local recordedActions = {}
local fileName = "RecordedActions"

-- Function to start recording
local function startRecording()
    isRecording = true
    recordedActions = {}
    print("Recording started!")
end

-- Function to stop recording
local function stopRecording()
    isRecording = false
    print("Recording stopped!")
    print("Recorded actions:", recordedActions)
end

-- Track remote events and record their actions
local function trackAction(remote, ...)
    if isRecording then
        table.insert(recordedActions, {
            remoteName = remote.Name,
            args = { ... },
            timestamp = tick()  -- Store the timestamp to calculate delay between actions
        })
        print("Action recorded:", remote.Name, ...)
    end
end

-- Function to save recorded actions to a file
local function saveToFile()
    if not fileName or fileName == "" then
        warn("No file name specified!")
        return
    end

    -- Ensure folder structure exists for storing the macro file
    local path = "internal storage/Delta/Workspace/ballhub/macro/" .. fileName .. ".txt"

    -- Check if the directory exists (executor-specific code for file access)
    -- Replace with your executor's method for file and directory management

    -- Create the file path if it doesn't exist
    local filePath = "internal storage/Delta/Workspace/ballhub/macro/"  -- Adjust based on executor file access API
    local directoryExists = isfile(filePath)
    if not directoryExists then
        makefolder(filePath)  -- Ensure the folder exists
    end

    -- Serialize recorded actions into a JSON string
    local HttpService = game:GetService("HttpService")
    local jsonData = HttpService:JSONEncode(recordedActions)

    -- Write to the file using executor's file-writing API
    -- Replace with your executor's method of saving a file
    writefile(filePath .. fileName .. ".txt", jsonData)  -- This is the standard method for file-saving

    print("Actions saved to file:", filePath .. fileName .. ".txt")
end

-- Function to replay recorded actions
local function replayActions()
    print("Replaying actions...")
    for _, action in ipairs(recordedActions) do
        local remoteName = action.remoteName
        local args = action.args
        local remote = Remotes:FindFirstChild(remoteName)

        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))  -- Re-fire the remote event with the original arguments
            wait(1)  -- Add a delay between actions to simulate real-time replay
        end
    end
    print("Replay finished!")
end

-- UI creation for controlling recording and replaying
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

-- Create the UI
local RecordButton, ReplayButton = createUI()

-- Button functionality
RecordButton.MouseButton1Click:Connect(function()
    if not isRecording then
        RecordButton.Text = "Stop Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        startRecording()
    else
        RecordButton.Text = "Start Recording"
        RecordButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        stopRecording()

        -- Save the recorded actions to file
        saveToFile()
    end
end)

ReplayButton.MouseButton1Click:Connect(function()
    if not isRecording and #recordedActions > 0 then
        replayActions()
    else
        print("No actions to replay or currently recording!")
    end
end)

-- Hook into the remote events to track their usage
local function hookRemoteEvents()
    if SpawnTowerRemote then
        -- Track SpawnTowerServer actions
        SpawnTowerRemote.OnClientEvent:Connect(function(...)
            trackAction(SpawnTowerRemote, ...)
        end)
    end

    if UpgradeTowerRemote then
        -- Track UpgradeTowerServer actions
        UpgradeTowerRemote.OnClientEvent:Connect(function(...)
            trackAction(UpgradeTowerRemote, ...)
        end)
    end
end

-- Start hooking the remotes
hookRemoteEvents()
