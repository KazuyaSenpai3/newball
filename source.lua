-- Tiger Spy (Original Turtle Spy Rebranded)

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local RemoteScrollFrame = Instance.new("ScrollingFrame")
local RemoteButton = Instance.new("TextButton")
local RemoteName = Instance.new("TextLabel")
local RemoteIcon = Instance.new("ImageLabel")

local remotes = {}
local remoteArgs = {}
local remoteButtons = {}
local remoteScripts = {}
local IgnoreList = {}
local BlockList = {}

local buttonOffset = -25
local scrollSizeOffset = 287
local connections = {}

-- Setup for the Tiger Spy UI
local function setupUI()
    ScreenGui.Name = "TigerSpyGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    RemoteScrollFrame.Name = "RemoteScrollFrame"
    RemoteScrollFrame.Parent = ScreenGui
    RemoteScrollFrame.Size = UDim2.new(0, 207, 0, 287)
    RemoteScrollFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    RemoteScrollFrame.ScrollBarThickness = 8
    RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollSizeOffset)
    
    RemoteButton.Name = "RemoteButton"
    RemoteButton.Parent = RemoteScrollFrame
    RemoteButton.Size = UDim2.new(0, 182, 0, 26)
    RemoteButton.Text = "Remote Button"
    
    RemoteName.Name = "RemoteName"
    RemoteName.Parent = RemoteButton
    RemoteName.Text = "Remote Event"
    RemoteName.Position = UDim2.new(0, 5, 0, 0)
    
    RemoteIcon.Name = "RemoteIcon"
    RemoteIcon.Parent = RemoteButton
    RemoteIcon.Image = "rbxassetid://413369506"
    RemoteIcon.Position = UDim2.new(0.84, 0, 0.02, 0)
end

-- Hook remote event and function calls
local function hookRemote(remote)
    local function originalFireServer(self, ...)
        table.insert(remotes, remote)
        table.insert(remoteArgs, {...})
        -- Store remote call and args for later use
        return originalFireServer(self, ...)
    end
    
    remote.FireServer = hookfunction(remote.FireServer, originalFireServer)
end

-- Detect and add remotes
local function detectRemotes()
    for _, remote in pairs(ReplicatedStorage.Remotes:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            hookRemote(remote)
        end
    end
end

-- Add remote buttons to the UI
local function addToUI(remote, args)
    local rButton = RemoteButton:Clone()
    rButton.Parent = RemoteScrollFrame
    rButton.Visible = true
    rButton.Position = UDim2.new(0, 17, 0, buttonOffset)
    rButton.RemoteName.Text = remote.Name
    buttonOffset = buttonOffset + 35
    remoteButtons[#remotes] = rButton
    remoteArgs[#remotes] = args
    remoteScripts[#remotes] = (isSynapse() and getcallingscript() or rawget(getfenv(0), "script"))
end

-- Connect the remotes to the list and UI
local function onRemoteFire(remote, ...)
    addToUI(remote, {...})
end

-- Set up event listeners for remote actions
ReplicatedStorage.Remotes.ChildAdded:Connect(function(remote)
    if remote:IsA("RemoteEvent") then
        onRemoteFire(remote)
    end
end)

-- Initialize UI and remotes
setupUI()
detectRemotes()

-- Make sure the script tracks new remote events that are created
local function monitorRemote()
    for _, remote in ipairs(ReplicatedStorage.Remotes:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            hookRemote(remote)
        end
    end
end

-- Call the monitorRemote function to start tracking new remote events
monitorRemote()

print("Tiger Spy is active and monitoring remotes!")
