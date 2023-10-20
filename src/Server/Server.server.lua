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
    print(number)
    -- every 4 rooms
    if number % 3 == 0 then
        -- spawn in monster
        shadow.New(number, generatedRooms)
    end
end)
