local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local closetCameraEvent = Events:WaitForChild("ClosetCamera")

local closet = {}

function closet.MoveHinge(hinge, direction)
    local openAngle = 110
    local goalCFrame = hinge.CFrame * CFrame.Angles(0, math.rad(openAngle * direction), 0)
    local doorTween = TweenService:Create(hinge,TweenInfo.new(0.5), {CFrame = goalCFrame})
    doorTween:Play()
end

function closet.MoveDoors(model, direction)
    closet.MoveHinge(model.LeftHinge, 1 * direction)
    closet.MoveHinge(model.RightHinge, -1 * direction)
    -- be careful with the wait, tween will overlap when doors close if the wait is not appropriate time
    -- causing weirdness
    task.wait(.5)
end

function closet.PlayerLeave(player, model)
    -- get players character 
    local character = player.Character
    if not character then return end

    model.hasPlayer.Value = player
    -- reset
    closet.MoveDoors(model, -1)
    -- we look backwards cause the front of the outside part is facing inwards
    -- we need to change orientation by multiplying y rotation by 180 (flip)
    character:PivotTo(model.Outside.CFrame * CFrame.Angles(0, math.rad(180), 0))
    character.Humanoid.WalkSpeed = 16
    character.Humanoid.JumpPower = 50
    closet.MoveDoors(model, 1)
    model.hasPlayer.Value = nil
end

function closet.PlayerEnter(player, model)
    -- get players character 
    local character = player.Character
    if not character then return end

    model.hasPlayer.Value = player
    character.Humanoid.WalkSpeed = 0
    character.Humanoid.JumpPower = 0
    character:PivotTo(model.Outside.CFrame)
    closetCameraEvent:FireClient(player, model.Outside.CFrame)
    closet.MoveDoors(model, -1)
    character:PivotTo(model.Inside.CFrame)
    closetCameraEvent:FireClient(player, model.Inside.CFrame)
    closet.MoveDoors(model, 1)
end

function closet.New(template)
    local model = workspace.Furniture.Closet:Clone()
    model:PivotTo(template.CFrame)
    model.Parent = template.Parent

    -- keep track of player. cant use attribute,  cause it cant hold a player data type
    local hasPlayer = Instance.new("ObjectValue")
    hasPlayer.Name = "hasPlayer"
    -- this is an old fashion attribute
    hasPlayer.Parent = model

    local outsidePrompt = Instance.new("ProximityPrompt")
    outsidePrompt.ActionText = ""
    outsidePrompt.MaxActivationDistance = 5
    outsidePrompt.Parent = model.Outside

    local insidePrompt = Instance.new("ProximityPrompt")
    insidePrompt.ActionText = ""
    insidePrompt.MaxActivationDistance = 2
    insidePrompt.Parent = model.InsidePrompt

    local sound = workspace.Sounds.OpenDoorSound

    outsidePrompt.Triggered:Connect(function(playerWhoTriggered)
        -- if no player is in here
        if hasPlayer.Value == nil then
            outsidePrompt.Enabled = false
            sound:Play()
            closet.PlayerEnter(playerWhoTriggered, model)
        end
    end)

    insidePrompt.Triggered:Connect(function(playerWhoTriggered)
        if hasPlayer.Value == playerWhoTriggered then
            insidePrompt.Enabled = false
            sound:Play()
            closet.PlayerLeave(playerWhoTriggered, model)
            insidePrompt.Enabled = true
            outsidePrompt.Enabled = true
        end
    end)
    template:Destroy()
end

return closet