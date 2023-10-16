local ReplicatedStorage = game:GetService("ReplicatedStorage")
local room = require(ReplicatedStorage.Modules.Room.Room)
local door = require(ReplicatedStorage.Modules.Room.Door)


local prevRoom = workspace.StartRoom
local firstDoor = door.New(prevRoom)

for i=1, 100 do
    prevRoom = room.Generate(prevRoom)
end