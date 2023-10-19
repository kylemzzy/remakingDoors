local TweenService = game:GetService("TweenService")
local closet = require(script.Parent.Closet)
local furniture = {}

function furniture.OpenCloseDrawer(drawer)
    drawer:SetAttribute("Moving", true)

    local isOpen = drawer:GetAttribute("Open")
    -- if its closed set it to -1. 
    -- if its open set it to 1 
    local direction = isOpen and 1 or -1

    local cframe = drawer.CFrame * CFrame.new(0,0,1.5 * direction)
    local drawerTween = TweenService:Create(drawer, TweenInfo.new(0.5), {CFrame = cframe})

    local drawerSound = drawer.Sound
    drawerTween:Play()
    drawerSound:Play()
    drawerTween.Completed:Wait()
    drawer:SetAttribute("Moving", false)
    drawer:SetAttribute("Open", not isOpen)
end

-- the constructor when we create a new furniture object
-- pass in a furniture as well as the room
function furniture.New(template, roomModel)
    -- grab the furniture model
    local templateFurnitureModel = workspace.Furniture:FindFirstChild(template.Name)
    -- some rooms dont have it, so if it doesnt exist then dont spawn new furnitures
    if not templateFurnitureModel then
        return
    end
    -- clone the furniture model from workspace
    local furnitureModel = templateFurnitureModel:Clone()
    -- move the furniture to the red box template in each room
    furnitureModel:PivotTo(template.CFrame)

    -- item spawning within here
    local itemLocations = {}


    -- loop through the model to find if there are any drawers
    if furnitureModel:FindFirstChild("Drawers") then
        -- if there are, then loop through each drawer
        for i, drawer in ipairs (furnitureModel.Drawers:GetChildren()) do
            table.insert(itemLocations, drawer.Location)
            -- define attributes for each object specifically
            drawer:SetAttribute("Open", false)
            drawer:SetAttribute("Moving", false)
            -- proximity prompt for interaction 
            local prompt = Instance.new("ProximityPrompt")
            -- we only want the interact to show up
            prompt.ActionText = ""
            prompt.MaxActivationDistance = 5
            -- the drawer attachment is the handle for the prompt to show up when players get close
            prompt.Parent = drawer.Attachment
            -- when the player interacts with the prompt via E or left click
            prompt.Triggered:Connect(function()
                -- if the drawer is not in motion, open or close it
                if not drawer:GetAttribute("Moving") then
                    furniture.OpenCloseDrawer(drawer)
                end
            end)
        end
    end


    -- move the model into the furniture folder for each room
    furnitureModel.Parent = template.Parent
    -- destroy the template for the rooms
    template:Destroy()

    return itemLocations
end
function furniture.FurnishRoom(roomModel)
    -- create a supertable consisting of all the different locations  within the same room to spawn an item
    local roomItemLocations = {} 

    if roomModel:FindFirstChild("Furniture") then
        local templates = roomModel.Furniture:GetChildren()
        for _, part in ipairs(templates) do
            -- we need our own if statement for closets because it wont have drawers that
            -- we need to look for room locations in
            if part.Name == "Closet" then
                closet.New(part)
                continue
            end
            -- for each child in the furniture folder, send to constructor
            -- we are given back a table of the attachments list for each drawer in 1 furniture
            local locations = furniture.New(part, roomModel)
            -- loop through that table to insert it into ROOM super table
            if locations then
                for i, value in ipairs(locations) do
                    table.insert(roomItemLocations, value)
                end
            end
        end
    end
    if #roomItemLocations > 0 then
        return roomItemLocations
    end
end


return furniture