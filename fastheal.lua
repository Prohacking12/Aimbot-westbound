local AutoHeal = {}

function AutoHeal.Heal(LocalPlayer)
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

return AutoHeal
