-- remove death sound
local rootPart = script.Parent.Parent:WaitForChild("HumanoidRootPart")
local Found = rootPart:WaitForChild("Died")
Found:Destroy()