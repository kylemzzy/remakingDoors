local closet = {}

function closet.PlayerEnter(player, model)
    -- get players character 
    local character = player.Character
    if not character then return end

    model.hasPlayer.Value = player
    character.Humanoid.WalkSpeed = 0
    character.Humanoid.JumpPower = 0
    character:PivotTo(model.Outside.CFrame)
    task.wait(1)
    character:PivotTo(model.Inside.CFrame)
end

function closet.New(template)
    print("CLOSET HI")
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

    outsidePrompt.Triggered:Connect(function(playerWhoTriggered)
        -- if no player is in here
        if hasPlayer.Value == nil then
            outsidePrompt.Enabled = false
            closet.PlayerEnter(playerWhoTriggered, model)
        end
    end)
    template:Destroy()
end

return closet