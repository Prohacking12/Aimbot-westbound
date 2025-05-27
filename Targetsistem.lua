local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AnimalsFolder = workspace:FindFirstChild("Animals") or Instance.new("Folder")

local lockedTargetPart = nil
local Homelander = require(script.Parent.Parent)

return {
    getClosestEnemy = function(maxDistance, targetTeam)
        local closest, shortest = nil, maxDistance
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == targetTeam then
                local character = player.Character
                if character and Homelander.Utils.isValidTarget(character) then
                    local part = Homelander.Utils.getTargetPart(character, Homelander.Config.Aimbot.AimAtChest)
                    if part then
                        local distance = (part.Position - Camera.CFrame.Position).Magnitude
                        if distance < shortest and Homelander.Utils.raycastCheck(Camera.CFrame.Position, part.Position) then
                            shortest = distance
                            closest = part
                        end
                    end
                end
            end
        end
        return closest
    end,
    
    getClosestAnimal = function(maxDistance)
        if not Homelander.Config.Combat.AnimalAimbot then return nil end
        local closest, shortest = nil, maxDistance
        for _, animal in pairs(AnimalsFolder:GetChildren()) do
            local part = Homelander.Utils.getTargetPart(animal, Homelander.Config.Aimbot.AimAtChest)
            if part and animal:FindFirstChildOfClass("Humanoid") and animal:FindFirstChildOfClass("Humanoid").Health > 0 then
                local distance = (part.Position - Camera.CFrame.Position).Magnitude
                if distance < shortest and Homelander.Utils.raycastCheck(Camera.CFrame.Position, part.Position) then
                    shortest = distance
                    closest = part
                end
            end
        end
        return closest
    end,
    
    getCurrentTarget = function()
        return lockedTargetPart or 
               self.getClosestEnemy(Homelander.Config.Aimbot.PlayerMaxDistance, Homelander.Config.Aimbot.TargetTeamName) or 
               self.getClosestAnimal(Homelander.Config.Aimbot.AnimalMaxDistance)
    end,
    
    switchTargetTeam = function()
        Homelander.Config.Aimbot.TargetTeamName = (Homelander.Config.Aimbot.TargetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        lockedTargetPart = nil
        if Homelander.GUI then
            Homelander.GUI.updateButtons()
        end
    end,
    
    toggleLockTarget = function()
        if lockedTargetPart then
            lockedTargetPart = nil
        else
            lockedTargetPart = self.getClosestEnemy(Homelander.Config.Aimbot.PlayerMaxDistance, Homelander.Config.Aimbot.TargetTeamName)
        end
        if Homelander.GUI then
            Homelander.GUI.updateButtons()
        end
    end
}
