local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local shadow = {}

function shadow.FindPlayers(model)
    -- local players = Players:GetPlayers()
    -- local characters = {}
    -- for i, player in ipairs(players) do
        
    -- end
    
end

function shadow.LerpTo(model, target)
    -- percentage at which the model is relative to the target
    local alpha = 0
    -- speed in which we want to ghost to move to
    local speed = 50

    local distance = (model.PrimaryPart.Position - target.Position).Magnitude

    local relativeSpeed = distance / speed 

    local startCFrame = model.PrimaryPart.CFrame
    local loop = nil

    local reachedTarget = Instance.new("BindableEvent")
    reachedTarget.Parent = ReplicatedStorage.Bindables

    loop = RunService.Heartbeat:Connect(function(delta)
        shadow.FindPlayers(model)
        local goalCFrame = startCFrame:Lerp(target.CFrame, alpha)
        model:PivotTo(goalCFrame)
        alpha += delta / relativeSpeed
        if alpha >= 1 then
            loop:Disconnect()
            reachedTarget:Fire()
        end
    end)

    reachedTarget.Event:Wait()
end

function shadow.Navigate(model, prevNum, maxNum, generatedRooms)
    for i = prevNum, maxNum do
        local room = generatedRooms[i]

        local waypoints = room:FindFirstChild("Waypoints")
        if waypoints then
            for j = 1, #waypoints:GetChildren() do
                shadow.LerpTo(model, waypoints[j])
            end
        else 
            -- if no waypoints, lerp to the entrance
            shadow.LerpTo(model, room.Entrance)
        end
        shadow.LerpTo(model, room.Exit)
    end
end

function shadow.New(number, generatedRooms)
    local enemyModel = workspace.Enemies.Shadow:Clone()

    local prevNum = number - 1
    local maxNum = number + 2
    local prevRoom = generatedRooms[prevNum]
    -- if we want shadow to appear before room 3, we need an edge case for prevNumber going before startRoom
    -- if maxNum is out of bounds
    if not generatedRooms[maxNum] then
        maxNum = #generatedRooms
    end
    local maxRoom = generatedRooms[maxNum]

    enemyModel:PivotTo(prevRoom.Entrance.CFrame)
    enemyModel.Parent = workspace

    shadow.Navigate(enemyModel, prevNum, maxNum, generatedRooms)
    enemyModel:Destroy()
end

return shadow