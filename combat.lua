local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local killAuraLoaded = false
local Homelander = require(script.Parent.Parent)

return {
    autoHeal = function()
        if not Homelander.Config.Combat.AutoHeal then return end
        local character = LocalPlayer.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health >= Homelander.Config.Combat.AutoHealThreshold then return end

        local healthPotion = character:FindFirstChild("Health Potion")
        if not healthPotion then return end

        local drinkPotion = healthPotion:FindFirstChild("DrinkPotion")
        if drinkPotion then
            if drinkPotion:IsA("RemoteEvent") then
                drinkPotion:FireServer()
            elseif drinkPotion:IsA("RemoteFunction") then
                drinkPotion:InvokeServer()
            end
        end
    end,
    
    activateKillAura = function()
        if killAuraLoaded then return end
        local success, err = pcall(function()
            local url = "https://gist.githubusercontent.com/Prohacking12/ac46591ae6546dca1e10a7b3a6847501/raw"
            local response = game:HttpGet(url)
            loadstring(response)()
            killAuraLoaded = true
            return true
        end)
        
        if not success then
            warn("Error loading Kill Aura: "..tostring(err))
            return false
        end
        return true
    end,
    
    toggleAutoHeal = function()
        Homelander.Config.Combat.AutoHeal = not Homelander.Config.Combat.AutoHeal
        if Homelander.GUI then
            Homelander.GUI.updateButtons()
        end
    end
}