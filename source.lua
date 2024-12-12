-- AdvanceFalling Team
-- Some are scripts were modify to be toggleable :3

-- ALSO im sorry if this arsenal script have messy codes in it, I will try to make it organized in the future if im not lazy. 

--[[
⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄ ⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄
⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰
⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗ 
⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄ ⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄ 
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃⠄ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃⠄⠄ 
⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁⠄⠄⠄ ⠄⠄⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁⠄⠄⠄⠄⠄
⠄⠄⠄⠄⠄⠉⠻⣿⣿⣾⣦⡙⠻⣷⣾⣿⠃⠿⠋⠁⠄⠄⠄⠄⠄⢀⣠⣴ ⣿⣶⣶⣮⣥⣒⠲⢮⣝⡿⣿⣿⡆⣿⡿⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣠
]]


--[[
New stuff added:
 - Triggerbot Added
 - DeadHP & DeadAmmo changed into dropdown
 - Improved the autofarm a little

TODO:
 - add aimbot
 - need new esp library
 - other stuff i need to add but forgotten
]]--


local CoreGui = game:GetService("StarterGui")
CoreGui:SetCore("SendNotification", {
  Title = "AdvanceTech Arsenal",
  Text = "Working For Mobile and PC Executor",
  Duration = 8,
})

game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "Modify By:",
  Text = "AdvancedFalling Team",
  Icon = "rbxthumb://type=Asset&id=13508183954&w=150&h=150",
  Duration = 8,
})



-- actual fly script
local flySettings={fly=false,flyspeed=50}
local c local h local bv local bav local cam local flying local p=game.Players.LocalPlayer
local buttons={W=false,S=false,A=false,D=false,Moving=false}
local startFly=function()if not p.Character or not p.Character.Head or flying then return end c=p.Character h=c.Humanoid h.PlatformStand=true cam=workspace:WaitForChild('Camera') bv=Instance.new("BodyVelocity") bav=Instance.new("BodyAngularVelocity") bv.Velocity,bv.MaxForce,bv.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bav.AngularVelocity,bav.MaxTorque,bav.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bv.Parent=c.Head bav.Parent=c.Head flying=true h.Died:connect(function()flying=false end)end
local endFly=function()if not p.Character or not flying then return end h.PlatformStand=false bv:Destroy() bav:Destroy() flying=false end
game:GetService("UserInputService").InputBegan:connect(function(input,GPE)if GPE then return end for i,e in pairs(buttons)do if i~="Moving" and input.KeyCode==Enum.KeyCode[i]then buttons[i]=true buttons.Moving=true end end end)
game:GetService("UserInputService").InputEnded:connect(function(input,GPE)if GPE then return end local a=false for i,e in pairs(buttons)do if i~="Moving"then if input.KeyCode==Enum.KeyCode[i]then buttons[i]=false end if buttons[i]then a=true end end end buttons.Moving=a end)
local setVec=function(vec)return vec*(flySettings.flyspeed/vec.Magnitude)end
game:GetService("RunService").Heartbeat:connect(function(step)if flying and c and c.PrimaryPart then local p=c.PrimaryPart.Position local cf=cam.CFrame local ax,ay,az=cf:toEulerAnglesXYZ()c:SetPrimaryPartCFrame(CFrame.new(p.x,p.y,p.z)*CFrame.Angles(ax,ay,az))if buttons.Moving then local t=Vector3.new()if buttons.W then t=t+(setVec(cf.lookVector))end if buttons.S then t=t-(setVec(cf.lookVector))end if buttons.A then t=t-(setVec(cf.rightVector))end if buttons.D then t=t+(setVec(cf.rightVector))end c:TranslateBy(t*step)end end end)






local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bitef4/Recode/main/UI/Kavo_1.lua"))()
local Window = Library.CreateLib("AdvanceTech | Arsenal | v1.7 ", "BlueTheme")

local Welcome = Window:NewTab("Main")
local MainSection = Welcome:NewSection("Welcome To AdvanceTech | " .. game.Players.LocalPlayer.Name)

local HitboxSection = Welcome:NewSection("> Hitbox Settings <")
local triggerbot = Welcome:NewSection("> Triggerbot <")

local hitboxEnabled = false
local noCollisionEnabled = false
local hitbox_original_properties = {}
local hitboxSize = 21
local hitboxTransparency = 6
local teamCheck = "FFA" 

local defaultBodyParts = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local WarningText = Instance.new("TextLabel", ScreenGui)
-- useless
WarningText.Size = UDim2.new(0, 200, 0, 50)
WarningText.TextSize = 16
WarningText.Position = UDim2.new(0.5, -150, 0, 0)
WarningText.Text = "" -- made it into empty string, you can add whatever
WarningText.TextColor3 = Color3.new(1, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Visible = false

-- -------------------------------------
-- Utility Functions
-- -------------------------------------
local function savedPart(player, part)
    if not hitbox_original_properties[player] then
        hitbox_original_properties[player] = {}
    end
    if not hitbox_original_properties[player][part.Name] then
        hitbox_original_properties[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoredPart(player)
    if hitbox_original_properties[player] then
        for partName, properties in pairs(hitbox_original_properties[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = properties.CanCollide
                part.Transparency = properties.Transparency
                part.Size = properties.Size
            end
        end
    end
end

local function findClosestPart(player, partName)
    if not player.Character then return nil end
    local characterParts = player.Character:GetChildren()
    for _, part in ipairs(characterParts) do
        if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
            return part
        end
    end
    return nil
end

-- -------------------------------------
-- Hitbox Functions
-- -------------------------------------
local function extendHitbox(player)
    for _, partName in ipairs
    local defaultBodyParts = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local WarningText = Instance.new("TextLabel", ScreenGui)
-- useless
WarningText.Size = UDim2.new(0, 200, 0, 50)
WarningText.TextSize = 16
WarningText.Position = UDim2.new(0.5, -150, 0, 0)
WarningText.Text = "" -- made it into empty string, you can add whatever
WarningText.TextColor3 = Color3.new(1, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Visible = false

-- -------------------------------------
-- Utility Functions
-- -------------------------------------
local function savedPart(player, part)
    if not hitbox_original_properties[player] then
        hitbox_original_properties[player] = {}
    end
    if not hitbox_original_properties[player][part.Name] then
        hitbox_original_properties[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoredPart(player)
    if hitbox_original_properties[player] then
        for partName, properties in pairs(hitbox_original_properties[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = properties.CanCollide
                part.Transparency = properties.Transparency
                part.Size = properties.Size
            end
        end
    end
end

local function findClosestPart(player, partName)
    if not player.Character then return nil end
    local characterParts = player.Character:GetChildren()
    for _, part in ipairs(characterParts) do
        if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
            return part
        end
    end
    return nil
end

-- -------------------------------------
-- Hitbox Functions
-- -------------------------------------
local function extendHitbox(player)
    for _, partName in ipairs(defaultBodyParts) do
        local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
        if part and part:IsA("BasePart") then
            savedPart(player, part)
            part.CanCollide = not noCollisionEnabled
            part.Transparency = hitboxTransparency / 10
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
end

local function isEnemy(player)
    if teamCheck == "FFA" or teamCheck == "Everyone" then
        return true
    end
    local localPlayerTeam = LocalPlayer.Team
    return player.Team ~= localPlayerTeam
end

local function shouldExtendHitbox(player)
    return isEnemy(player)
end

local function updateHitboxes()
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if shouldExtendHitbox(v) then
                extendHitbox(v)
            else
                restoredPart(v)
            end
        end
    end
end

-- -------------------------------------
-- Event Handlers
-- -------------------------------------
local function onCharacterAdded(character)
    task.wait(0.1)
    if hitboxEnabled then
        updateHitboxes()
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    player.CharacterRemoving:Connect(function()
        restoredPart(player)
        hitbox_original_properties[player] = nil
    end)
end

local function checkForDeadPlayers()
    for player, properties in pairs(hitbox_original_properties) do
        if not player.Parent or not player.Character or not player.Character:IsDescendantOf(game) then
            restoredPart(player)
            hitbox_original_properties[player] = nil
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

--Orion Lib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "AdvanceTech | Arsenal | v1.7",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AdvanceTechArsenal"
})

local WelcomeTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998", -- Replace with a relevant icon
    PremiumOnly = false
})

local GunTab = Window:MakeTab({
    Name = "Gun Modded",
    Icon = "rbxassetid://4483345998", -- Replace with a relevant icon
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998", -- Replace with a relevant icon
    PremiumOnly = false
})


-- Main Tab (Welcome and Hitbox)
WelcomeTab:AddLabel("Welcome To AdvanceTech | " .. game.Players.LocalPlayer.Name)

WelcomeTab:AddButton({
    Name = "[CLICK THIS FIRST] Enable Hitbox",
    Callback = function()
        coroutine.wrap(function()
            while true do
                if hitboxEnabled then
                    updateHitboxes()
                    checkForDeadPlayers()
                end
                task.wait(0.1)
            end
        end)()
    end
})

WelcomeTab:AddToggle({
    Name = "Enable Hitbox",
    Default = false,
    Callback = function(enabled)
        hitboxEnabled = enabled
        if not enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                restoredPart(player)
            end
            hitbox_original_properties = {}
        else
            updateHitboxes()
        end
    end
})

WelcomeTab:AddSlider({
    Name = "Hitbox Size",
    Min = 1,
    Max = 25,
    Default = 21,
    Increment = 1,
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

WelcomeTab:AddSlider({
    Name = "Hitbox Transparency",
    Min = 0,
    Max = 10,
    Default = 6,
    Increment = 1,
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

WelcomeTab:AddDropdown({
    Name = "Team Check",
    Default = "FFA",
    Options = {"FFA", "Team-Based", "Everyone"},
    Callback = function(value)
        teamCheck = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

WelcomeTab:AddToggle({
    Name = "No Collision",
    Default = false,
    Callback = function(enabled)
        noCollisionEnabled = enabled
        WarningText.Visible = enabled
        coroutine.wrap(function()
            while noCollisionEnabled do
                if hitboxEnabled then
                    updateHitboxes()
                end
                task.wait(0.01)
            end
            if hitboxEnabled then
                updateHitboxes()
            end
        end)()
    end
})

-- Triggerbot
WelcomeTab:AddToggle({
    Name = "Enable Triggerbot",
    Default = false,
    Callback = function(state)
        getgenv().triggerb = state
    end
})

WelcomeTab:AddDropdown({
    Name = "Team Check Mode (Triggerbot)",
    Default = "Team-Based",
    Options = {"FFA", "Team-Based", "Everyone"},
    Callback = function(selected)
        teamcheck = selected
    end
})

WelcomeTab:AddSlider({
    Name = "Shot Delay (Triggerbot)",
    Min = 1,
    Max = 10,
    Default = 2,
    Increment = 1,
    Callback = function(value)
        delay = value / 10
                end
    end
})

-- AutoFarm
WelcomeTab:AddToggle({
    Name = "AutoFarm",
    Default = false,
    Callback = function(bool)
        getgenv().AutoFarm = bool

        local runServiceConnection
        local mouseDown = false
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera

        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = bool and "Infinite Ammo" or ""

        local function closestplayer()
            local closestDistance = math.huge
            local closestPlayer = nil

            for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
                if enemyPlayer ~= player and enemyPlayer.TeamColor ~= player.TeamColor and enemyPlayer.Character then
                    local character = enemyPlayer.Character
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = enemyPlayer
                        end
                    end
                end
            end

            return closestPlayer
        end

        local function AutoFarm()
            game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 12

            runServiceConnection = game:GetService("RunService").Stepped:Connect(function()
                if getgenv().AutoFarm then
                    local closestPlayer = closestplayer()
                    if closestPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyRootPart = closestPlayer.Character.HumanoidRootPart

                        local targetPosition = enemyRootPart.Position - enemyRootPart.CFrame.LookVector * 2 + Vector3.new(0, 2, 0)
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                        if closestPlayer.Character:FindFirstChild("Head") then
                            local enemyHead = closestPlayer.Character.Head.Position
                            camera.CFrame = CFrame.new(camera.CFrame.Position, enemyHead)
                        end

                        if not mouseDown then
                            mouse1press()
                            mouseDown = true
                        end
                    else
                        if mouseDown then
                            mouse1release()
                            mouseDown = false
                        end
                    end
                else
                    if runServiceConnection then
                        runServiceConnection:Disconnect()
                        runServiceConnection = nil
                    end
                    if mouseDown then
                        mouse1release()
                        mouseDown = false
                    end
                end
            end)
        end

        local function onCharacterAdded(character)
            wait(0.5)
            AutoFarm()
        end

        player.CharacterAdded:Connect(onCharacterAdded)

        if bool then
            wait(0.5)
            AutoFarm()
        else
            game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = ""
            getgenv().AutoFarm = false
            game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 1
            if runServiceConnection then
                runServiceConnection:Disconnect()
                runServiceConnection = nil
            end
            if mouseDown then
                mouse1release()
                mouseDown = false
            end
        end
    end
})


-- Gun Modded Tab
GunTab:AddToggle({
    Name = "Infinite Ammo v1",
    Default = false,
    Callback = function(v)
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = v and "Infinite Ammo" or ""
    end
})

GunTab:AddToggle({
    Name = "Infinite Ammo v2",
    Default = false,
    Callback = function(K)
        local SettingsInfinite = K
        if SettingsInfinite then
            game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    if SettingsInfinite then
                        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                        playerGui.GUI.Client.Variables.ammocount.Value = 99
                        playerGui.GUI.Client.Variables.ammocount2.Value = 99
                    end
                end)
            end)
        end
    end
})

-- ... (Rest of the Gun Modded toggles - Fast Reload, Fast Fire Rate, etc.)

local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

local function handleWeaponProperty(propertyName, valueName, defaultValue, state)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == valueName then
            if state then
                if not originalValues[propertyName][v] then
                    originalValues[propertyName][v] = v.Value
                end
                v.Value = defaultValue
            else
                if originalValues[propertyName][v] then
                    v.Value = originalValues[propertyName][v]
                else
                    v.Value = defaultValue -- Restore to default if no original value saved
                end
            end
        end
    end
end

GunTab:AddToggle({Name = "Fast Reload", Default = false, Callback = function(x) handleWeaponProperty("ReloadTime", "ReloadTime", 0.01, x) handleWeaponProperty("EReloadTime", "EReloadTime", 0.01, x) end})
GunTab:AddToggle({Name = "Fast Fire Rate", Default = false, Callback = function(state) handleWeaponProperty("FireRate", "FireRate", 0.02, state) handleWeaponProperty("FireRate", "BFireRate", 0.02, state) end})
GunTab:AddToggle({Name = "Always Auto", Default = false, Callback = function(state) handleWeaponProperty("Auto", "Auto", true, state) handleWeaponProperty("Auto", "AutoFire", true, state) handleWeaponProperty("Auto", "Automatic", true, state) handleWeaponProperty("Auto", "AutoShoot", true, state) handleWeaponProperty("Auto", "AutoGun", true, state) end})
GunTab:AddToggle({Name = "No Spread", Default = false, Callback = function(state) handleWeaponProperty("Spread", "MaxSpread", 0, state) handleWeaponProperty("Spread", "Spread", 0, state) handleWeaponProperty("Spread", "SpreadControl", 0, state) end})
GunTab:AddToggle({Name = "No Recoil", Default = false, Callback = function(state) handleWeaponProperty("Recoil", "RecoilControl", 0, state) handleWeaponProperty("Recoil", "Recoil", 0, state) end})



-- Player Tab (Fly)
PlayerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        if state then
            startFly()
        else
            endFly()
        end
    end
})

OrionLib:Init()
    
