local UserInputService = game:GetService("UserInputService")
local combat = require(script.Parent.combat)
local visuals = require(script.Parent.visuals)

local module = {}

function module.init()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            combat.aimbotEnabled = not combat.aimbotEnabled
            print("Aimbot: " .. (combat.aimbotEnabled and "ON" or "OFF"))
        elseif input.KeyCode == Enum.KeyCode.F2 then
            visuals.toggleFullbright()
            print("Fullbright: " .. (visuals.fullbrightEnabled and "ON" or "OFF"))
        elseif input.KeyCode == Enum.KeyCode.F3 then
            visuals.toggleXray()
            print("X-Ray: " .. (visuals.xrayEnabled and "ON" or "OFF"))
        elseif input.KeyCode == Enum.KeyCode.F4 then
            combat.animalAimbotEnabled = not combat.animalAimbotEnabled
            print("Animal Aimbot: " .. (combat.animalAimbotEnabled and "ON" or "OFF"))
        end
    end)
end

return module
