-- AdvanceFalling Team
-- Some are scripts were modify to be toggleable :3

-- ALSO im sorry if this arsenal script have messy codes in it, I will try to make it organized in the future if im not lazy. 

--[[
⣿⠿⠿⠶⠿⢿⣿⣿⣿⣿⣦⣤⣄⢀⡅⢠⣾⣛⡉⠄⠄⠄⠸⢀⣿⠄ ⢀⡋⣡⣴⣶⣶⡀⠄⠄⠙⢿⣿⣿⣿⣿⣿⣴⣿⣿⣿⢃⣤⣄⣀⣥⣿⣿⠄
⢸⣇⠻⣿⣿⣿⣧⣀⢀⣠⡌⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⠄⢸⣿⣷⣤⣤⣤⣬⣙⣛⢿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡍⠄⠄⢀⣤⣄⠉⠋⣰
⣖⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⢇⣿⣿⡷⠶⠶⢿⣿⣿⠇⢀⣤ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣷⣶⣥⣴⣿⡗ 
⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄ ⣦⣌⣛⣻⣿⣿⣧⠙⠛⠛⡭⠅⠒⠦⠭⣭⡻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄ 
⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠄⠹⠈⢋⣽⣿⣿⣿⣿⣵⣾⠃⠄ ⣿⣿⣿⣿⣿⣿⣿⣿⠄⣴⣿⣶⣄⠄⣴⣶⠄⢀⣾⣿⣿⣿⣿⣿⣿⠃⠄⠄ 
⠈⠻⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⠄⣿⣿⡀⣾⣿⣿⣿⣿⣛⠛⠁⠄⠄⠄ ⠄⠄⠈⠛⢿⣿⣿⣿⠁⠞⢿⣿⣿⡄⢿⣿⡇⣸⣿⣿⠿⠛⠁⠄⠄⠄⠄⠄
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

HitboxSection:NewButton("[CLICK THIS FIRST] Enable Hitbox", '?', function()
    coroutine.wrap(function()
        while true do
            if hitboxEnabled then
                updateHitboxes()
                checkForDeadPlayers()
            end
            task.wait(0.1)
        end
    end)()
end)

HitboxSection:NewToggle("Enable Hitbox", '?', function(enabled)
    hitboxEnabled = enabled
    if not enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            restoredPart(player)
        end
        hitbox_original_properties = {}
    else
        updateHitboxes()
    end
end)

HitboxSection:NewSlider("Hitbox Size", '?', 25, 1, function(value)
    hitboxSize = value
    if hitboxEnabled then
        updateHitboxes()
    end
end)

HitboxSection:NewSlider("Hitbox Transparency", '?', 10, 1,  function(value)
    hitboxTransparency = value
    if hitboxEnabled then
        updateHitboxes()
    end
end)

HitboxSection:NewDropdown("Team Check", '?', {"FFA", "Team-Based", "Everyone"}, function(value)
    teamCheck = value
    if hitboxEnabled then
        updateHitboxes()
    end
end)

HitboxSection:NewToggle("No Collision", '?', function(enabled)
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
end)

MainSection:NewToggle("AutoFarm", "?", function(bool)
    getgenv().AutoFarm = bool

    local runServiceConnection
    local mouseDown = false
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera

    game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = bool and "Infinite Ammo" or ""

    function closestplayer()
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
end)


getgenv().triggerb = false
local teamcheck = "Team-Based"
local delay = 0.2
local isAlive = true

triggerbot:NewToggle("Enable Triggerbot", "triggerbot on or off", function(state)
    getgenv().triggerb = state
end)

triggerbot:NewDropdown("Team Check Mode", "teamchecking mode", {"FFA", "Team-Based", "Everyone"}, function(selected)
    teamcheck = selected
end)

triggerbot:NewSlider("Shot Delay", "delay between shots (1-10)", 10, 1, function(value)
    delay = value / 10
end)

local function isEnemy(targetPlayer)
    if teamcheck == "FFA" then
        return true
    elseif teamcheck == "Everyone" then
        return targetPlayer ~= game.Players.LocalPlayer
    elseif teamcheck == "Team-Based" then
        local localPlayerTeam = game.Players.LocalPlayer.Team
        return targetPlayer.Team ~= localPlayerTeam
    end
    return false
end

local function checkhealth()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.HealthChanged:Connect(function(health)
            isAlive = health > 0
        end)
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(checkhealth)
checkhealth()

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().triggerb and isAlive then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") and target.Parent.Name ~= player.Name then
            local targetPlayer = game:GetService("Players"):FindFirstChild(target.Parent.Name)
            if targetPlayer and isEnemy(targetPlayer) then
                mouse1press()
                wait(delay)
                mouse1release()
            end
        end
    end
end)










local Gun = Window:NewTab("Gun Modded")
local GunmodsSection = Gun:NewSection("> Overpower Gun <")

GunmodsSection:NewToggle("Infinite Ammo v1", "?", function(v)
    game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = v and "Infinite Ammo" or ""
end)

local SettingsInfinite = false
GunmodsSection:NewToggle("Infinite Ammo v2", "?", function(K)
    SettingsInfinite = K
    if SettingsInfinite then
        game:GetService("RunService").Stepped:connect(function()
            pcall(function()
                if SettingsInfinite then
                    local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                    playerGui.GUI.Client.Variables.ammocount.Value = 99
                    playerGui.GUI.Client.Variables.ammocount2.Value = 99
                end
            end)
        end)
    end
end)

local originalValues = { -- saves/stores the original Values of the gun value :3
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

GunmodsSection:NewToggle("Fast Reload", "?", function(x)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
        if v:FindFirstChild("ReloadTime") then
            if x then
                if not originalValues.ReloadTime[v] then
                    originalValues.ReloadTime[v] = v.ReloadTime.Value
                end
                v.ReloadTime.Value = 0.01
            else
                if originalValues.ReloadTime[v] then
                    v.ReloadTime.Value = originalValues.ReloadTime[v]
                else
                    v.ReloadTime.Value = 0.8 
                end
            end
        end
        if v:FindFirstChild("EReloadTime") then
            if x then
                if not originalValues.EReloadTime[v] then
                    originalValues.EReloadTime[v] = v.EReloadTime.Value
                end
                v.EReloadTime.Value = 0.01
            else
                if originalValues.EReloadTime[v] then
                    v.EReloadTime.Value = originalValues.EReloadTime[v]
                else
                    v.EReloadTime.Value = 0.8 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("Fast Fire Rate", "?", function(state)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == "FireRate" or v.Name == "BFireRate" then
            if state then
                if not originalValues.FireRate[v] then
                    originalValues.FireRate[v] = v.Value
                end
                v.Value = 0.02
            else
                if originalValues.FireRate[v] then
                    v.Value = originalValues.FireRate[v]
                else
                    v.Value = 0.8 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("Always Auto", "?", function(state)
    for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
        if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
            if state then
                if not originalValues.Auto[v] then
                    originalValues.Auto[v] = v.Value
                end
                v.Value = true
            else
                if originalValues.Auto[v] then
                    v.Value = originalValues.Auto[v]
                else
                    v.Value = false 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("No Spread", "?", function(state)
    for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
            if state then
                if not originalValues.Spread[v] then
                    originalValues.Spread[v] = v.Value
                end
                v.Value = 0
            else
                if originalValues.Spread[v] then
                    v.Value = originalValues.Spread[v]
                else
                    v.Value = 1 
                end
            end
        end
    end
end)

GunmodsSection:NewToggle("No Recoil", "?", function(state)
    for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        if v.Name == "RecoilControl" or v.Name == "Recoil" then
            if state then
                if not originalValues.Recoil[v] then
                    originalValues.Recoil[v] = v.Value
                end
                v.Value = 0
            else
                if originalValues.Recoil[v] then
                    v.Value = originalValues.Recoil[v]
                else
                    v.Value = 1 
                end
            end
        end
    end
end)


local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("> Fly Hacks <")
PlayerSection:NewToggle("Fly", "Allows the player to fly", function(state)
  if state then
    startFly()
  else
    endFly()
  end
end)
