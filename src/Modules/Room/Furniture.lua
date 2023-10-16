local TweenService = game:GetService("TweenService")
local furniture = {}

function furniture.OpenDrawer(drawer)
    drawer:SetAttribute("Moving", true)

    local isOpen = drawer:GetAttribute("Open")
    -- if its closed set it to 1. 
    -- if its open set it to -1 
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

function furniture.New(template, roomModel)
    local furnitureModel = workspace.Furniture:FindFirstChild(template.Name)

    if not furnitureModel then
        return
    end

    furnitureModel = furnitureModel:Clone()
    furnitureModel:PivotTo(template.CFrame)

    if furnitureModel:FindFirstChild("Drawers") then
        for i, drawer in ipairs (furnitureModel.Drawers:GetChildren()) do
            drawer:SetAttribute("Open", false)
            drawer:SetAttribute("Moving", false)

            local prompt = Instance.new("ProximityPrompt")
            prompt.ActionText = ""
            prompt.MaxActivationDistance = 5
            prompt.Parent = drawer.Attachment

            prompt.Triggered:Connect(function()
                if not drawer:GetAttribute("Moving") then
                    furniture.OpenDrawer(drawer)
                end
            end)
        end
    end



    furnitureModel.Parent = template.Parent
    template:Destroy()

end
function furniture.FurnishRoom(roomModel)
    if roomModel:FindFirstChild("Furniture") then
        local templates = roomModel.Furniture:GetChildren()
        for _, part in ipairs(templates) do
            -- for each child in the furniture folder, send to constructor
            furniture.New(part, roomModel)
        end
    end
end


return furniture