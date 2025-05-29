local FastRob = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local RobRemote = ReplicatedStorage:WaitForChild("GeneralEvents"):WaitForChild("Rob")

FastRob.Enabled = false

function FastRob.toggle()
    FastRob.Enabled = not FastRob.Enabled
end

function FastRob.FastRobSafe(Item)
    if Item:FindFirstChild("Open").Value then
        RobRemote:FireServer("Safe", Item)
    else
        Item:FindFirstChild("OpenSafe"):FireServer("Completed")
        RobRemote:FireServer("Safe", Item)
    end
end

RunService.RenderStepped:Connect(function()
    if FastRob.Enabled then
        for _, Item in pairs(Workspace:GetChildren()) do
            if Item:IsA("Model") and Item.Name == "Safe" and Item:FindFirstChild("Amount") and Item.Amount.Value > 0 then
                FastRob.FastRobSafe(Item)
            end
        end
    end
end)

return FastRob
