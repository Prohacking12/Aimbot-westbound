local Keybinds = {}
local binds = {}

function Keybinds.init(sharedState)
    -- No necesita inicialización especial
end

function Keybinds.bind(key, callback)
    binds[key] = callback
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    for key, callback in pairs(binds) do
        if input.KeyCode == key then
            callback()
        end
    end
end)

return Keybinds
