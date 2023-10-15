local room = {}
-- why create an object?
room.random = Random.new()
-- Generate rooms function
-- prevRoom = previous room to avoid 
function room.Generate(prevRoom)
	-- get all possible rooms
	local possibleRooms = workspace.Rooms:GetChildren()
	-- create a random number between 1 and the number of rooms
	local randomRoom = possibleRooms[room.random:NextInteger(1, #possibleRooms)]
	-- clone the model 
	local newRoom = randomRoom:Clone()

	-- when pivoting and not specifying, we need to identify a primary part
	newRoom.PrimaryPart = newRoom.Entrance
	newRoom:PivotTo(prevRoom.Exit.CFrame)

	newRoom.Parent = workspace.GeneratedRooms

	return newRoom

end

return room