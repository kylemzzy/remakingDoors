local door = {}

function door.New(roomModel)
    local doorModel = workspace.Door:Clone()

    doorModel:PivotTo(roomModel.Exit.CFrame)
    doorModel.Parent = roomModel

    return doorModel
end


return door