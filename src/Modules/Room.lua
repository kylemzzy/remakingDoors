local room = {}
-- why create an object?
room.random = Random.new()
room.info = require(script.Parent.RoomInfo)
room.lastTurnDirection = nil
-- GetRandom rooms function -- this functions will add edge cases to what rooms can be genned
-- prevRoom = previous room to cframe 
function room.GetRandom(prevRoom)
	-- get all possible rooms
	-- local possibleRooms = workspace.Rooms:GetChildren()
	-- -- create a random number between 1 and the number of rooms
	-- local randomRoom = possibleRooms[room.random:NextInteger(1, #possibleRooms)]


	-- NEED TO FIND BETER WAY FOR PROBABILITY STUFF
	local totalWeight = 0
	for _, info in pairs(room.info) do
		totalWeight += info.Weight
	end
	-- 
	local randomWeight = room.random:NextInteger(0, totalWeight)
	local currentWeight = 0
	local randomRoom = nil
	for i, info in pairs(room.info) do
		currentWeight += info.Weight
		if randomWeight <= currentWeight then
			randomRoom = workspace.Rooms[i]
			break
		end
	end
	-- print(randomWeight)
	if randomRoom.Name == "RareRoom" then
		print(" RAREEEEEEEEEEEEEEEEEEEEEEEEE ")
	end


	-- [1] Next Room must be different from prev
	-- [2] if turn, we must turn other direction
	-- [3] if prev has stairs avoid other ones. 

	local direction = room.info[randomRoom.Name]["Direction"]
	local hasStairs = room.info[randomRoom.Name]["Stairs"]
	local prevHadStairs = room.info[prevRoom.Name]["Stairs"]

	-- if we have the same room, then recursively call the function to get a new room
	if (prevRoom.Name == randomRoom.Name) 
		or direction == room.lastTurnDirection
		or hasStairs and prevHadStairs
	then
		return room.GetRandom(prevRoom)
	end

	--  if direction we are at is turning, then set it 
	if direction ~= "Straight" then
		room.lastTurnDirection = direction
	end
	return randomRoom
end


-- Generate rooms function
-- prevRoom = previous room to set the cframe 
function room.Generate(prevRoom)
	local randomRoom = room.GetRandom(prevRoom)
	local newRoom = randomRoom:Clone()

	-- when pivoting and not specifying, we need to identify a primary part
	newRoom.PrimaryPart = newRoom.Entrance
	newRoom:PivotTo(prevRoom.Exit.CFrame)

	newRoom.Parent = workspace.GeneratedRooms

	return newRoom

end

return room