local Combat = {}
local shared
local lockedTargetPart = nil
local indicatorCircle

function Combat.init(sharedState)
    shared = sharedState
end

function Combat.getTargetPart(model)
    if not model then return nil end
    return model:FindFirstChild(shared.config.aimAtChest and "HumanoidRootPart" or "Head") or model:FindFirstChild("ChestPart")
end

function Combat.isValidTarget(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if character:FindFirstChild("Knocked") and character.Knocked.Value == true then return false end
    return true
end

function Combat.getClosestEnemy()
    local closest, shortest = nil, shared.config.playerMaxDistance
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= shared.LocalPlayer and player.Team and player.Team.Name == shared.config.targetTeamName then
            local character = player.Character
            if character and Combat.isValidTarget(character) then
                local part = Combat.getTargetPart(character)
                if part then
                    local distance = (part.Position - shared.Camera.CFrame.Position).Magnitude
                    if distance < shortest then
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {shared.LocalPlayer.Character}
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        local result = workspace:Raycast(shared.Camera.CFrame.Position, (part.Position - shared.Camera.CFrame.Position).Unit * distance, params)
                        if not result or result.Instance:IsDescendantOf(character) then
                            shortest = distance
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

function Combat.getClosestAnimal()
    if not shared.config.animalAimbotEnabled then return nil end
    local closest, shortest = nil, shared.config.animalMaxDistance
    for _, animal in pairs(shared.AnimalsFolder:GetChildren()) do
        local part = Combat.getTargetPart(animal)
        if part and animal:FindFirstChild("Humanoid") and animal.Humanoid.Health > 0 then
            local distance = (part.Position - shared.Camera.CFrame.Position).Magnitude
            if distance < shortest then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {shared.LocalPlayer.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local result = workspace:Raycast(shared.Camera.CFrame.Position, (part.Position - shared.Camera.CFrame.Position).Unit * distance, params)
                if not result or result.Instance:IsDescendantOf(animal) then
                    shortest = distance
                    closest = part
                end
            end
        end
    end
    return closest
end

function Combat.lockClosestTarget()
    lockedTargetPart = Combat.getClosestEnemy() or Combat.getClosestAnimal()
    shared.UI.updateLockButton(lockedTargetPart ~= nil)
end

function Combat.activateKillAura()
    if shared.config.killAuraLoaded then return end
    loadstring(game:HttpGet("https://gist.githubusercontent.com/Prohacking12/ac46591ae6546dca1e10a7b3a6847501/raw"))()
    shared.config.killAuraLoaded = true
end

function Combat.autoHeal()
    if not shared.config.autoHealEnabled then return end
    local character = shared.LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local healthPotion = character:FindFirstChild("Health Potion")
    if not humanoid or not healthPotion then return end

    if humanoid.Health < 100 then
        local drinkPotion = healthPotion:FindFirstChild("DrinkPotion")
        if drinkPotion then
            if drinkPotion:IsA("RemoteEvent") then
                drinkPotion:FireServer()
            elseif drinkPotion:IsA("RemoteFunction") then
                drinkPotion:InvokeServer()
            end
        end
    end
end

function Combat.update()
    if shared.config.aimbotEnabled then
        local targetPart = lockedTargetPart or Combat.getClosestEnemy() or Combat.getClosestAnimal()
        if targetPart then
            local camPos = shared.Camera.CFrame.Position
            shared.Camera.CFrame = CFrame.new(camPos, targetPart.Position)
        end
    end
end

return Combat
