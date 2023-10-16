local furniture = {}

function furniture.New(template, roomModel)
    local furnitureModel = workspace.Furniture:FindFirstChild(template.Name)

    if not furnitureModel then
        return
    end

    furnitureModel = furnitureModel:Clone()
    furnitureModel:PivotTo(template.CFrame)
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