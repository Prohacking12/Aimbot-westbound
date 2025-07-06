local Aimbot = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AnimalsFolder = workspace:WaitForChild("Animals")

Aimbot.aimbotEnabled = true
Aimbot.animalAimbotEnabled = true
Aimbot.targetTeamName = "Outlaws"
Aimbot.aimAtChest = false
Aimbot.playerMaxDistance = 120
Aimbot.animalMaxDistance = 90
Aimbot.lockedTargetPart = nil
Aimbot.killAuraLoaded = false
Aimbot.autoHealEnabled = false
Aimbot.aimAllPlayers = false

function Aimbot.toggleAimbot() Aimbot.aimbotEnabled = not Aimbot.aimbotEnabled end
function Aimbot.toggleAnimalAimbot() Aimbot.animalAimbotEnabled = not Aimbot.animalAimbotEnabled end
function Aimbot.toggleAimPart() Aimbot.aimAtChest = not Aimbot.aimAtChest end
function Aimbot.toggleTeam()
    Aimbot.targetTeamName = (Aimbot.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
    Aimbot.lockedTargetPart = nil
end
function Aimbot.toggleLock()
    if Aimbot.lockedTargetPart then
        Aimbot.lockedTargetPart = nil
    else
        Aimbot.lockedTargetPart = Aimbot.getClosestEnemy()
    end
end
function Aimbot.toggleAimAllPlayers()
    Aimbot.aimAllPlayers = not Aimbot.aimAllPlayers
    Aimbot.lockedTargetPart = nil
end

function Aimbot.getTargetPart(model)
    if not model then return nil end
    return model:FindFirstChild(Aimbot.aimAtChest and "HumanoidRootPart" or "Head") or model:FindFirstChild("ChestPart")
end

function Aimbot.activateKillAura()
    if Aimbot.killAuraLoaded then return end
    local url = "https://gist.githubusercontent.com/Prohacking12/ac46591ae6546dca1e10a7b3a6847501/raw"
    local response = game:HttpGet(url)
    loadstring(response)()
    Aimbot.killAuraLoaded = true
end

function Aimbot.isValidTarget(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if character:FindFirstChild("Knocked") and character.Knocked.Value == true then return false end
    return true
end

function Aimbot.getClosestEnemy()
    local closest, shortest = nil, Aimbot.playerMaxDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Aimbot.aimAllPlayers or (player.Team and player.Team.Name == Aimbot.targetTeamName) then
                local character = player.Character
                if character and Aimbot.isValidTarget(character) then
                    local part = Aimbot.getTargetPart(character)
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
    end
    return closest
end

function Aimbot.getAllEnemies()
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Aimbot.aimAllPlayers or (player.Team and player.Team.Name == Aimbot.targetTeamName) then
                local character = player.Character
                if character and Aimbot.isValidTarget(character) then
                    local part = Aimbot.getTargetPart(character)
                    if part then
                        local distance = (part.Position - Camera.CFrame.Position).Magnitude
                        if distance <= Aimbot.playerMaxDistance then
                            local params = RaycastParams.new()
                            params.FilterDescendantsInstances = {LocalPlayer.Character}
                            params.FilterType = Enum.RaycastFilterType.Blacklist
                            local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * distance, params)
                            if not result or result.Instance:IsDescendantOf(character) then
                                table.insert(targets, part)
                            end
                        end
                    end
                end
            end
        end
    end
    return targets
end

function Aimbot.autoHeal()
    if not Aimbot.autoHealEnabled then return end
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

function Aimbot.getClosestAnimal()
    if not Aimbot.animalAimbotEnabled then return nil end
    local closest, shortest = nil, Aimbot.animalMaxDistance
    for _, animal in pairs(AnimalsFolder:GetChildren()) do
        local part = Aimbot.getTargetPart(animal)
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
