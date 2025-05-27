local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AnimalsFolder = workspace:WaitForChild("Animals")

local module = {
    killAuraLoaded = false,
    autoHealEnabled = false,
    aimbotEnabled = true,
    animalAimbotEnabled = true,
    targetTeamName = "Outlaws",
    aimAtChest = false,
    playerMaxDistance = 120,
    animalMaxDistance = 90,
    lockedTargetPart = nil
}

function module.getTargetPart(model)
    if not model then return nil end
    return model:FindFirstChild(module.aimAtChest and "HumanoidRootPart" or "Head") or model:FindFirstChild("ChestPart")
end

function module.activateKillAura()
    if module.killAuraLoaded then return end
    local success, err = pcall(function()
        local url = "https://gist.githubusercontent.com/Prohacking12/ac46591ae6546dca1e10a7b3a6847501/raw"
        local response = game:HttpGet(url)
        loadstring(response)()
        module.killAuraLoaded = true
    end)
    if not success then
        warn("Error al cargar Kill Aura: "..tostring(err))
    end
end

function module.isValidTarget(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if character:FindFirstChild("Knocked") and character.Knocked.Value == true then return false end
    return true
end

function module.getClosestEnemy()
    local closest, shortest = nil, module.playerMaxDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team and player.Team.Name == module.targetTeamName then
            local character = player.Character
            if character and module.isValidTarget(character) then
                local part = module.getTargetPart(character)
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

function module.autoHeal()
    if not module.autoHealEnabled then return end
    local character = LocalPlayer.Character
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

function module.getClosestAnimal()
    if not module.animalAimbotEnabled then return nil end
    local closest, shortest = nil, module.animalMaxDistance
    for _, animal in pairs(AnimalsFolder:GetChildren()) do
        local part = module.getTargetPart(animal)
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

function module.init()
    task.spawn(function()
        while true do
            module.autoHeal()
            task.wait(1)
        end
    end)
end

return module
