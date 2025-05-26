local Aimbot = {}

function Aimbot.GetTargetPart(model, aimAtChest)
    if not model then return nil end
    return model:FindFirstChild(aimAtChest and "HumanoidRootPart" or "Head") or model:FindFirstChild("ChestPart")
end

function Aimbot.IsValidTarget(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if character:FindFirstChild("Knocked") and character.Knocked.Value == true then return false end
    return true
end

function Aimbot.GetClosestEnemy(Players, LocalPlayer, Camera, config)
    local closest, shortest = nil, config.playerMaxDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team and player.Team.Name == config.targetTeamName then
            local character = player.Character
            if character and Aimbot.IsValidTarget(character) then
                local part = Aimbot.GetTargetPart(character, config.aimAtChest)
                if part then
                    local distance = (part.Position - Camera.CFrame.Position).Magnitude
                    if distance < shortest then
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * distance, params)
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

function Aimbot.GetClosestAnimal(AnimalsFolder, Camera, LocalPlayer, config)
    if not config.animalAimbotEnabled then return nil end
    local closest, shortest = nil, config.animalMaxDistance
    for _, animal in pairs(AnimalsFolder:GetChildren()) do
        local part = Aimbot.GetTargetPart(animal, config.aimAtChest)
        if part and animal:FindFirstChild("Humanoid") and animal.Humanoid.Health > 0 then
            local distance = (part.Position - Camera.CFrame.Position).Magnitude
            if distance < shortest then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * distance, params)
                if not result or result.Instance:IsDescendantOf(animal) then
                    shortest = distance
                    closest = part
                end
            end
        end
    end
    return closest
end

return Aimbot
