local ProximityPromptService = game:GetService("ProximityPromptService")
local item = {}

function item.Interact(player, prompt, template, itemName)
    if player.Character then
        if itemName == "Key"then
            local tool = workspace.Items.Key:Clone()
            -- if we want to have it equippd straight do player.Character
            tool.Parent = player.Character
            -- tool.Parent = player.Backpack
        end
        workspace.Sounds.Collect:Play()
        prompt.Enabled = false
        template:Destroy()
    end
end
-- this function takes in the location of where to put the item spawn in
function item.New(location, itemName)
    -- finds the object in workspace of the appropriate name
    local itemObject = workspace.Items:FindFirstChild(itemName)
    -- safe check if it exists
    if itemObject then
        -- clone the tool
        local itemWhole = itemObject:Clone()
        -- however we only want to get the mesh part
        -- this is cause with tools, we auto pick it up if we get close to it.
        -- we want to use the proximity again
        local passKey = itemWhole.Key
        itemWhole.Key.Position = location.WorldPosition
        -- weld the key position to the drawer
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = passKey
        weld.Part1 = location.Parent
        weld.Parent = passKey

        itemWhole.Key.Parent = location
        -- create proximity pickup
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = ""
        prompt.MaxActivationDistance = 5
        prompt.Parent = location

        prompt.Triggered:Connect(function(player)
            item.Interact(player, prompt, passKey, itemName)
        end)
    end
end

return item







-- function item.New(location, itemName)
--     local itemObject = workspace.Items:FindFirstChild(itemName)

--     if itemObject then
--         print("AAH")
--         local itemHandle = itemObject.Handle:Clone()
--         itemHandle.Position = location.WorldPosition

--         local weld = Instance.new("WeldConstraint")
--         weld.Part0 = itemHandle
--         weld.Part1 = location.Parent
--         weld.Parent = itemHandle

--         itemHandle.Parent = location

--         local prompt = Instance.new("ProximityPrompt")
--         prompt.ActionText = ""
--         prompt.MaxActivationDistance = 5
--         prompt.Parent = location

--         prompt.Triggered:Connect(function(player)
--             item.Interact(player, prompt, itemHandle, itemName)
--         end)
--     end
-- end