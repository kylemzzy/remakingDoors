local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui") 

local DeathRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Death")
local BlackGui = PlayerGui:WaitForChild("ScreenGui")
local Scare = BlackGui:WaitForChild("Pic")
-- make GUI visible
local debounce = true
DeathRemote.OnClientEvent:Connect(function()
    if not debounce then return end
    Scare.Visible = false
    BlackGui.Enabled = true
    debounce = false
    print("ASDASDS")
    local laugh = workspace.Sounds.CreepyLaugh
    -- 50 % chance of it popping up instant, else math.random
    local rand = math.random(1,3)
    -- print(rand)
    if rand ~= 2 then
        task.wait(1)
        laugh:Play()
        rand = math.random(2,5)
        task.wait(rand)
        laugh:Stop()
    end
    workspace.Sounds.JumpScare:Play()
    Scare.Visible = true
end)

Player.CharacterAdded:Connect(function()
    task.wait()
    workspace.Sounds.JumpScare:Stop()
    BlackGui.Enabled = false
    Scare.Visible = false
    debounce = true
end)

-- -- remove death sound
-- local rootPart = script.Parent:WaitForChild("HumanoidRootPart")
-- local Found = rootPart:WaitForChild("Died")
-- Found:Destroy()