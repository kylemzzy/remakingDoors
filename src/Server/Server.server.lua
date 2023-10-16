local ReplicatedStorage = game:GetService("ReplicatedStorage")
local room = require(ReplicatedStorage.Modules.Room.Room)
local door = require(ReplicatedStorage.Modules.Room.Door)


local prevRoom = workspace.StartRoom
-- initial starting room,
door.New(prevRoom, 1)
-- start at 2 since we have starting room
for i=2, 100 do
    prevRoom = room.Generate(prevRoom, i)
end