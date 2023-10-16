local door = require(script.Parent.Door)
local furniture = require(script.Parent.Furniture)
local item = require(script.Parent.Item)

local room = {}
-- why create an object?
room.random = Random.new()
-- with each room instance being created, we want to have its own variables.
room.info = require(script.Parent.RoomInfo)

room.lastTurnDirection = nil
-- GetRandom rooms function -- this functions will add edge cases to what rooms can be genned
-- prevRoom = previous room to cframe 
function room.GetRandom(prevRoom)
	-- get all possible rooms
	-- local possibleRooms = workspace.Rooms:GetChildren()
	-- -- create a random number between 1 and the number of rooms
	-- local randomRoom = possibleRooms[room.random:NextInteger(1, #possibleRooms)]


	local totalWeight = 0
	for _, info in pairs(room.info) do
		totalWeight += info.Weight
	end
	-- 
	local randomWeight = room.random:NextNumber(0, totalWeight)

	local currentWeight = 0
	local randomRoom = nil
	for i, info in pairs(room.info) do
		currentWeight += info.Weight
		-- why does this algorithm work? need to draw it out
		if randomWeight <= currentWeight then
			randomRoom = workspace.Rooms[i]
			break
		end
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
function room.Generate(prevRoom, number)
	local randomRoom = room.GetRandom(prevRoom)
	local newRoom = randomRoom:Clone()

	-- when pivoting and not specifying, we need to identify a primary part
	newRoom.PrimaryPart = newRoom.Entrance
	newRoom:PivotTo(prevRoom.Exit.CFrame)
	newRoom.Exit.Transparency = 1
	newRoom.Entrance.Transparency = 1

	local locations = furniture.FurnishRoom(newRoom)
	local requiresKey = false
	-- if this room has furniture where we can store keys in
	if locations then
		-- randomly generate locks in the room that consist of drawers
		if room.random:NextInteger(1,3) == 3 then
			requiresKey = true
		end
		local random = room.random:NextInteger(1, #locations)
		local randomLocation = locations[random]
		-- only spawn key if need key
		if requiresKey then
			item.New(randomLocation, "Key")
		end
	end
	door.New(newRoom, number, requiresKey)

	-- Parent last after adding visual updates
	newRoom.Parent = workspace.GeneratedRooms

	return newRoom

end

return room