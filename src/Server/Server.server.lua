local ReplicatedStorage = game:GetService("ReplicatedStorage")
local room = require(ReplicatedStorage.Modules.Room)

local prevRoom = workspace.StartRoom

for i=1, 100 do
    prevRoom = room.Generate(prevRoom)
end