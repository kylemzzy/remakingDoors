local TweenService = game:GetService("TweenService")

local door = {}


function door.Open(doorModel)
    doorModel:SetAttribute("Open", true)

    -- we will tween here
    local cframe = doorModel.Hinge.CFrame * CFrame.Angles(0, math.rad(100),0)
    local doorTween = TweenService:Create(doorModel.Hinge, TweenInfo.new(0.5), {CFrame = cframe})

    doorTween:Play()
    doorModel.Door.OpenSound:Play()
end

function door.New(roomModel, number)
    local doorModel = workspace.Door:Clone()

    doorModel:PivotTo(roomModel.Exit.CFrame)
    -- attributes allow scripters to make our own data type on the part
    doorModel:SetAttribute("Open", false)
    -- add trailing 0's
    if number < 10 then
        number = "00" .. number
    elseif number < 100 then
        number = "0" .. number
    end
    doorModel.Sign.SurfaceGui.TextLabel.Text = number
    doorModel.Sensor.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and not doorModel:GetAttribute("Open") then
            door.Open(doorModel)
        end
    end)





    -- set parent last
    doorModel.Parent = roomModel

    return doorModel
end


return door