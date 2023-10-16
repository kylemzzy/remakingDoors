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

function door.New(roomModel, number, locked)
    local doorModel = workspace.Door:Clone()

    doorModel:PivotTo(roomModel.Exit.CFrame)
    -- attributes allow scripters to make our own data type on the part
    doorModel:SetAttribute("Open", false)
    -- add trailing 0's
    -- %03d meaning
    -- % - we want to substitute in a value (number in this case )
    -- 03 - minimum of 3 digits. it autofills trailing 0's
    -- d - decimal
    doorModel.Sign.SurfaceGui.TextLabel.Text = string.format("%03d", number)
    -- if its locked, set it to 0, if its unlocked set it to 1 
    doorModel.Lock.Transparency = locked and 0 or 1
    doorModel.Sensor.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and not doorModel:GetAttribute("Open") then
            if not locked then
                door.Open(doorModel)
            elseif humanoid.Parent:FindFirstChild("Key") then
                doorModel.Lock:Destroy()
                humanoid.Parent.Key:Destroy()
                -- play unlock key  here
                workspace.Sounds.Unlock:Play()
                -- pause before updating door
                task.wait(1)
                door.Open(doorModel)
            end
        end
    end)





    -- set parent last
    doorModel.Parent = roomModel

    return doorModel
end


return door