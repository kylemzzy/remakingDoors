local ReplicatedStorage = game:GetService("ReplicatedStorage")
local room = require(ReplicatedStorage.Modules.Room.Room)
local door = require(ReplicatedStorage.Modules.Room.Door)
local shadow = require(ReplicatedStorage.Modules.Entities.Shadow)

local playerEnter = ReplicatedStorage:WaitForChild("Bindables"):WaitForChild("PlayerEnterRoom")



local prevRoom = workspace.StartRoom
-- initial starting room,
door.New(prevRoom, 1)

-- keep track of generated rooms
local generatedRooms = {prevRoom}

-- start at 2 since we have starting room
for i=2, 100 do
    prevRoom = room.Generate(prevRoom, i)
    generatedRooms[i] = prevRoom
end

playerEnter.Event:Connect(function(number)
    -- print(number)
    -- every 4 rooms
    if number % 4 == 0 then
        -- spawn in monster
        -- 50 percent change of spawning 
        local rand = math.random(2)
        if rand == 2 then return end
        workspace.Sounds.Flicker:Play()
        room.Blackout(generatedRooms[number])
        room.Blackout(generatedRooms[number+1])
        task.wait(.2)
        shadow.New(number, generatedRooms)
    end
end)
