local ReplicatedStorage = game:GetService("ReplicatedStorage")
local room = require(ReplicatedStorage.Modules.Room.Room)
local door = require(ReplicatedStorage.Modules.Room.Door)


local prevRoom = workspace.StartRoom
local firstDoor = door.New(prevRoom, 1)

for i=2, 100 do
    prevRoom = room.Generate(prevRoom, i)
end