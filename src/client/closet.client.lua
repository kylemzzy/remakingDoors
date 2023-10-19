local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local closetCameraEvent = Events:WaitForChild("ClosetCamera")

closetCameraEvent.OnClientEvent:Connect(function(cframe)
    workspace.CurrentCamera.CFrame = cframe
end)